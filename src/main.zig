const std = @import("std");
const fit = @import("fit/fit.zig");
const ui = @import("ui.zig");
const db = @import("db.zig");
const units = @import("units.zig");
const zbox = @import("zbox");
const dt = @import("datetime");
const sqlite = @import("sqlite");

usingnamespace @import("log_handler.zig");

const PATH = "/home/mjh/fit_files";

const FileAndPath = struct {
    path: []const u8,
    file: fit.File,
};

fn parseVal(comptime T: type, comptime metric: units.Metric, value: anytype) units.UnittedType(T, metric.standard()) {
    const v = @intToFloat(T, value);
    return units.parseVal(T, metric, v);
}

fn sort(context: void, lhs: FileAndPath, rhs: FileAndPath) bool {
    return lhs.file.session.start_time > rhs.file.session.start_time;
}

const Bar = struct {
    x_label: []const u8,
    y: f32,
    y_label: []const u8,
};

const BarGraph = struct {
    allocator: *std.mem.Allocator,
    values: std.ArrayList(Bar),
    max_val: f32,
    max_label_cols: usize,

    const Self = @This();

    fn init(allocator: *std.mem.Allocator) Self {
        return .{ .allocator = allocator, .values = std.ArrayList(Bar).init(allocator), .max_val = 0.0, .max_label_cols = 0 };
    }

    // Must be added in the order you want them to appear
    fn add(self: *Self, comptime x_fmt_string: []const u8, x_args: anytype, y: f32, comptime y_fmt_string: []const u8, y_args: anytype) !void {
        var x_label = std.ArrayList(u8).init(self.allocator);
        try x_label.writer().print(x_fmt_string, x_args);
        var y_label = std.ArrayList(u8).init(self.allocator);
        try y_label.writer().print(y_fmt_string, y_args);
        const label_cols = x_label.items.len + y_label.items.len;
        try self.values.append(.{
            .x_label = x_label.toOwnedSlice(),
            .y_label = y_label.toOwnedSlice(),
            .y = y,
        });
        if (y > self.max_val) self.max_val = y;
        if (label_cols > self.max_label_cols) self.max_label_cols = label_cols;
    }

    // TODO: just take a buffer here and use its width and height
    fn draw(self: *const Self, output: *zbox.Buffer, height: usize, width: usize) !void {
        const each_column_val = self.max_val / @intToFloat(f32, width - self.max_label_cols - 4);
        var cursor = output.cursorAt(0, 0);
        for (self.values.items) |bar| {
            try cursor.writer().print(" {s} ", .{bar.x_label});
            const bar_width = @floatToInt(u32, bar.y / each_column_val);
            var i: usize = 0;
            cursor.attribs.fg_white = false;
            cursor.attribs.fg_cyan = true;
            while (i < bar_width) : (i += 1) {
                _ = try cursor.writer().write("▇");
            }
            cursor.attribs.fg_white = true;
            cursor.attribs.fg_cyan = false;
            try cursor.writer().print(" {s}\n", .{bar.y_label});
            if (cursor.row_num >= height) {
                break;
            }
        }
    }

    fn deinit(self: *Self) void {
        for (self.values.items) |*v| {
            self.allocator.free(v.x_label);
            self.allocator.free(v.y_label);
        }
        self.values.deinit();
    }
};

fn getDistancesBy(period: []const u8, allocator: *std.mem.Allocator, cache: *sqlite.Db) !BarGraph {
    var distances_by_month = try db.getDistanceByTimePeriod(cache, allocator, period);
    defer {
        for (distances_by_month) |dbm| {
            allocator.free(dbm.period);
        }
        allocator.free(distances_by_month);
    }
    var bar_graph = BarGraph.init(allocator);
    for (distances_by_month) |dbm| {
        const miles = try parseVal(f32, .distance, dbm.distance).toUnit(.miles);
        try bar_graph.add("{s}", .{dbm.period}, miles, "{d:.2}{s}", .{ miles, units.Unit.miles.toString() });
    }
    return bar_graph;
}

const ListView = struct {
    allocator: *std.mem.Allocator,
    list: ui.List,
    rest: zbox.Buffer,
    names: [][]const u8,
    activities: []const db.Activity,

    const Self = @This();

    fn init(allocator: *std.mem.Allocator, names: [][]const u8, activities: []const db.Activity) !Self {
        const size = try zbox.size();
        var list = try ui.List.init(allocator, names);
        var rest = try zbox.Buffer.init(allocator, size.height, 2 * size.width / 3);

        return Self{ .allocator = allocator, .list = list, .rest = rest, .names = names, .activities = activities };
    }

    fn draw(self: *Self, output: *zbox.Buffer) !void {
        const size = try zbox.size();
        const list_width = size.width / 3;
        try self.list.resize(size.height, list_width);
        try self.list.draw();
        output.blit(self.list.buf, 0, 1);

        self.rest.clear();
        try self.rest.resize(size.height - 2, list_width * 2 - 3);
        if (self.activities.len != 0) {
            const activity = &self.activities[self.list.selected];
            var cursor = self.rest.wrappedCursorAt(0, 0);
            var writer = cursor.writer();
            try writer.print("{s}\n", .{self.names[self.list.selected]});
            try parseVal(f32, .distance, activity.total_distance).printUnit(writer, "Distance: {d:.2}{s}\n", .miles);
            try parseVal(f32, .time, activity.total_timer_time).printTime(writer, "Moving time: {s}\n");
            try parseVal(f32, .time, activity.total_elapsed_time).printTime(writer, "Total time: {s}\n");
            try parseVal(f32, .speed, activity.avg_speed).printUnit(writer, "Avg speed: {d:.2}{s}\n", .mph);
            if (activity.avg_heart_rate) |val| {
                try parseVal(f16, .frequency, val).printUnit(writer, "Avg heart rate: {d:.0}{s}\n", .bpm);
            }
            if (activity.min_heart_rate) |val| {
                try parseVal(f16, .frequency, val).printUnit(writer, "Min heart rate: {d:.0}{s}\n", .bpm);
            }
            if (activity.max_heart_rate) |val| {
                try parseVal(f16, .frequency, val).printUnit(writer, "Max heart rate: {d:.0}{s}\n", .bpm);
            }
            if (activity.avg_temperature) |val| {
                try parseVal(f16, .temperature, val).printUnit(writer, "Avg temperature: {d:.0}{s}\n", .celcius);
            }
            output.blit(self.rest, 1, @intCast(isize, list_width + 2));
        }
        try ui.drawBoxRect(output, 0, list_width + 1, size.height, list_width * 2 - 1);
    }

    fn handleInput(self: *Self, e: zbox.Event) void {
        self.list.handleInput(e);
    }

    fn deinit(self: *Self) void {
        self.rest.deinit();
        self.list.deinit();
    }
};

const HELP_TEXT: [6][]const u8 = .{
    "Welcome to zolter, a program to track your bike rides",
    "",
    "Views (accessed by given function key):",
    "F1: This help screen",
    "F2: Summary of all rides (bar charts of distance)",
    "F3: Individual files",
};

fn getLinesMaxLen(lines: []const []const u8) usize {
    var max: usize = 0;
    for (lines) |l| {
        if (l.len > max) max = l.len;
    }
    return max;
}

const View = enum {
    help,
    summary,
    activities_list,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    var cache = try db.openDb();

    var names = std.ArrayList([]const u8).init(&gpa.allocator);
    defer names.deinit();

    var activities = try db.getActivities(&cache, &gpa.allocator);
    defer {
        for (activities) |a| {
            gpa.allocator.free(a.name);
        }
        gpa.allocator.free(activities);
    }

    for (activities) |a| {
        try names.append(a.name);
    }

    try zbox.init(&gpa.allocator);
    defer zbox.deinit();

    try zbox.ignoreSignalInput();
    try zbox.cursorHide();
    defer zbox.cursorShow() catch {};

    var size = try zbox.size();
    std.debug.print("size {any} {}", .{ size, size.width / 3 });

    var output = try zbox.Buffer.init(&gpa.allocator, size.height, size.width);
    defer output.deinit();

    var list_view = try ListView.init(&gpa.allocator, names.items, activities);
    defer list_view.deinit();

    var distances_by_month = try getDistancesBy("%Y-%m", &gpa.allocator, &cache);
    defer distances_by_month.deinit();
    var distances_by_year = try getDistancesBy("%Y", &gpa.allocator, &cache);
    defer distances_by_year.deinit();

    var left = try zbox.Buffer.init(&gpa.allocator, size.height, size.width / 2);
    defer left.deinit();
    var right = try zbox.Buffer.init(&gpa.allocator, size.height, size.width / 2);
    defer right.deinit();

    var view = View.help;

    while (try zbox.nextEvent()) |e| {
        output.clear();

        size = try zbox.size();

        try output.resize(size.height, size.width);

        switch (view) {
            .help => {
                const max_line_width = getLinesMaxLen(HELP_TEXT[0..]);
                const left_pos = size.width / 2 - max_line_width / 2;
                const y_center = size.height / 2 - HELP_TEXT.len / 2;
                var cursor = output.cursorAt(y_center, 0);
                for (HELP_TEXT) |line| {
                    cursor.col_num = left_pos;
                    var tmp: [1024]u8 = undefined;
                    try cursor.writer().print("{s}\n", .{line});
                }

                try ui.drawBoxRect(&output, 0, 1, output.height, output.width - 1);
            },
            .activities_list => try list_view.draw(&output),
            .summary => {
                const width = size.width / 2;
                try left.resize(size.height, width);
                try right.resize(size.height, width);
                try distances_by_month.draw(&left, size.height, width);
                try distances_by_year.draw(&right, size.height, width);

                output.blit(left, 0, 0);
                output.blit(right, 0, @intCast(isize, width));
            },
        }

        try zbox.push(output);

        switch (e) {
            .escape => return,
            .other => |s| {
                if (std.mem.eql(u8, "\x1bOP", s)) {
                    view = .help;
                } else if (std.mem.eql(u8, "\x1bOQ", s)) {
                    view = .summary;
                } else if (std.mem.eql(u8, "\x1bOR", s)) {
                    view = .activities_list;
                }
            },
            else => list_view.handleInput(e),
        }
    }
}

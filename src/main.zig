const std = @import("std");
const ui = @import("ui.zig");
const db = @import("db.zig");
const fit = @import("fit/fit.zig");
const units = @import("units.zig");
const zbox = @import("zbox");
const sqlite = @import("sqlite");
const clap = @import("clap");

usingnamespace @import("log_handler.zig");

fn import(allocator: *std.mem.Allocator, cache: *sqlite.Db, base_path: []const u8) !void {
    var last_index = base_path.len;
    if (base_path[last_index - 1] == '/') {
        last_index -= 1;
    }
    std.log.debug("got base path: {s}", .{base_path});
    var walker = try std.fs.walkPath(allocator, base_path[0..last_index]);
    defer walker.deinit();

    while (try walker.next()) |node| {
        var f = try std.fs.openFileAbsolute(node.path, .{});
        defer f.close();
        std.log.debug("got path: {s}", .{node.path});
        var reader = std.io.bufferedReader(f.reader()).reader();
        const file = try fit.Parser.parse_reader(allocator, reader);
        const activity = db.activityFromSession(node.path, &file.session);

        db.insertActivity(cache, &activity) catch |e| {
            switch (e) {
                error.AlreadyExists => {
                    try std.io.getStdOut().writer().print("Skipped {s}\n", .{node.path});
                    continue;
                },
                else => return e,
            }
        };

        try std.io.getStdOut().writer().print("Imported {s}\n", .{node.path});
    }
}

fn parseVal(comptime T: type, comptime metric: units.Metric, value: anytype) units.UnittedType(T, metric.standard()) {
    const v = @intToFloat(T, value);
    return units.parseVal(T, metric, v);
}

fn getDistancesBy(period: []const u8, allocator: *std.mem.Allocator, cache: *sqlite.Db) !ui.BarGraph {
    var distances_by_month = try db.getDistanceByTimePeriod(cache, allocator, period);
    defer {
        for (distances_by_month) |dbm| {
            allocator.free(dbm.period);
        }
        allocator.free(distances_by_month);
    }
    var bar_graph = ui.BarGraph.init(allocator);
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

    const params = comptime [_]clap.Param(clap.Help){
        clap.parseParam("-h, --help             Display this help and exit.              ") catch unreachable,
        clap.parseParam("-i <PATH>              Imports fit files from PATH") catch unreachable,
    };

    var diag: clap.Diagnostic = undefined;
    var args = clap.parse(clap.Help, &params, &gpa.allocator, &diag) catch |err| {
        // Report useful error and exit
        diag.report(std.io.getStdErr().writer(), err) catch {};
        return err;
    };
    defer args.deinit();

    if (args.option("-i")) |path| {
        try import(&gpa.allocator, &cache, path);
        return;
    }

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

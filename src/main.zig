const std = @import("std");
const fit = @import("fit/fit.zig");
const ui = @import("ui.zig");
const units = @import("units.zig");
const zbox = @import("zbox");
const dt = @import("datetime");

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
        const each_column_val = self.max_val / @intToFloat(f32, width - self.max_label_cols - 3);
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

fn getDistancesByMonth(allocator: *std.mem.Allocator, files: []const fit.File) !BarGraph {
    var last_date = dt.Date.fromSeconds(0);
    var val: u32 = 0;
    var bar_graph = BarGraph.init(allocator);
    for (files) |f| {
        const corrected_ts = f.session.start_time + fit.GARMIN_EPOCH;
        const datetime = dt.Date.fromSeconds(@intToFloat(f64, corrected_ts));
        const start_of_month = datetime.shiftDays(-@intCast(i16, datetime.day - 1));
        if (!start_of_month.eql(last_date)) {
            if (last_date.toSeconds() != 0) {
                const miles = try parseVal(f32, .distance, val).toUnit(.miles);
                try bar_graph.add(" {d:0>2}/{d:0>2}", .{
                    last_date.month,
                    last_date.year - 2000,
                }, miles, "{d:.2}{s}", .{
                    miles,
                    units.Unit.miles.toString(),
                });
            }

            last_date = start_of_month;
            val = f.session.total_distance;
            continue;
        }
        val += f.session.total_distance;
    }
    return bar_graph;
}

fn getDistancesByYear(allocator: *std.mem.Allocator, files: []const fit.File) !BarGraph {
    var last_date = dt.Date.fromSeconds(0);
    var val: u32 = 0;
    var bar_graph = BarGraph.init(allocator);
    for (files) |f| {
        const corrected_ts = f.session.start_time + fit.GARMIN_EPOCH;
        var datetime = dt.Date.fromSeconds(@intToFloat(f64, corrected_ts));
        datetime.day = 1;
        datetime.month = 1;
        if (!datetime.eql(last_date)) {
            if (last_date.toSeconds() != 0) {
                const miles = try parseVal(f32, .distance, val).toUnit(.miles);
                try bar_graph.add(" {} ", .{last_date.year}, miles, "{d:.2}{s}", .{
                    miles,
                    units.Unit.miles.toString(),
                });
            }

            last_date = datetime;
            val = f.session.total_distance;
            continue;
        }
        val += f.session.total_distance;
    }

    if (last_date.toSeconds() != 0) {
        const miles = try parseVal(f32, .distance, val).toUnit(.miles);
        try bar_graph.add(" {} ", .{last_date.year}, miles, "{d:.2}{s}", .{
            miles,
            units.Unit.miles.toString(),
        });
    }
    return bar_graph;
}

const ListView = struct {
    allocator: *std.mem.Allocator,
    list: ui.List,
    rest: zbox.Buffer,
    rest_para: zbox.Buffer,
    paths: [][]const u8,
    files: []const fit.File,

    const Self = @This();

    fn init(allocator: *std.mem.Allocator, paths: [][]const u8, files: []const fit.File) !Self {
        const size = try zbox.size();
        var list = try ui.List.init(allocator, paths);
        var rest = try zbox.Buffer.init(allocator, size.height, 2 * size.width / 3);
        var rest_para = try zbox.Buffer.init(allocator, size.height, 2 * size.width / 3);

        return Self{ .allocator = allocator, .list = list, .rest = rest, .rest_para = rest_para, .paths = paths, .files = files };
    }

    fn draw(self: *Self, output: *zbox.Buffer) !void {
        const size = try zbox.size();
        const list_width = size.width / 3;
        try self.list.resize(size.height, list_width);
        try self.list.draw();
        output.blit(self.list.buf, 0, 1);

        self.rest.clear();
        try self.rest.resize(size.height, list_width * 2 - 1);
        try ui.drawBox(&self.rest);

        self.rest_para.clear();
        try self.rest_para.resize(size.height - 2, list_width * 2 - 3);
        const file = &self.files[self.list.selected];
        var cursor = self.rest_para.wrappedCursorAt(0, 0);
        var writer = cursor.writer();
        try writer.print("{s}\n", .{self.paths[self.list.selected]});
        try parseVal(f32, .distance, file.session.total_distance).printUnit(writer, "Distance: {d:.2}{s}\n", .miles);
        try parseVal(f32, .time, file.session.total_timer_time).printTime(writer, "Moving time: {s}\n");
        try parseVal(f32, .time, file.session.total_elapsed_time).printTime(writer, "Total time: {s}\n");
        try parseVal(f32, .speed, file.session.avg_speed).printUnit(writer, "Avg speed: {d:.2}{s}\n", .mph);
        try parseVal(f16, .frequency, file.session.avg_heart_rate).printUnit(writer, "Avg heart rate: {d:.0}{s}\n", .bpm);
        try parseVal(f16, .frequency, file.session.min_heart_rate).printUnit(writer, "Min heart rate: {d:.0}{s}\n", .bpm);
        try parseVal(f16, .frequency, file.session.max_heart_rate).printUnit(writer, "Max heart rate: {d:.0}{s}\n", .bpm);
        try parseVal(f16, .temperature, file.session.avg_temperature).printUnit(writer, "Avg temperature: {d:.0}{s}\n", .celcius);
        self.rest.blit(self.rest_para, 1, 1);

        output.blit(self.rest, 0, @intCast(isize, list_width + 1));
    }

    fn handleInput(self: *Self, e: zbox.Event) void {
        self.list.handleInput(e);
    }

    fn deinit(self: *Self) void {
        self.rest.deinit();
        self.rest_para.deinit();
        self.list.deinit();
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    std.log.debug("path: {s}", .{PATH});

    var walker = try std.fs.walkPath(&gpa.allocator, PATH);
    defer walker.deinit();

    var files_and_paths = std.ArrayList(FileAndPath).init(&gpa.allocator);

    while (try walker.next()) |node| {
        const path = try gpa.allocator.alloc(u8, node.path.len);
        std.mem.copy(u8, path, node.path);

        var f = try std.fs.openFileAbsolute(path, .{});
        defer f.close();
        var reader = std.io.bufferedReader(f.reader()).reader();
        const file = try fit.Parser.parse_reader(&gpa.allocator, reader);
        try files_and_paths.append(.{ .path = path, .file = file });
    }

    std.sort.sort(FileAndPath, files_and_paths.items, {}, sort);

    var paths = std.ArrayList([]const u8).init(&gpa.allocator);
    defer {
        for (paths.items) |p| {
            gpa.allocator.free(p);
        }
        paths.deinit();
    }
    var files = std.ArrayList(fit.File).init(&gpa.allocator);
    defer files.deinit();

    for (files_and_paths.items) |*fp| {
        try paths.append(fp.path);
        try files.append(fp.file);
    }
    files_and_paths.deinit();

    try zbox.init(&gpa.allocator);
    defer zbox.deinit();

    try zbox.ignoreSignalInput();
    try zbox.cursorHide();
    defer zbox.cursorShow() catch {};

    var size = try zbox.size();
    std.debug.print("size {any} {}", .{ size, size.width / 3 });

    var output = try zbox.Buffer.init(&gpa.allocator, size.height, size.width);
    defer output.deinit();

    var list_view = try ListView.init(&gpa.allocator, paths.items, files.items);
    defer list_view.deinit();

    var distances_by_month = try getDistancesByMonth(&gpa.allocator, files.items);
    defer distances_by_month.deinit();
    var distances_by_year = try getDistancesByYear(&gpa.allocator, files.items);
    defer distances_by_year.deinit();

    var left = try zbox.Buffer.init(&gpa.allocator, size.height, size.width / 2);
    defer left.deinit();
    var right = try zbox.Buffer.init(&gpa.allocator, size.height, size.width / 2);
    defer right.deinit();

    while (try zbox.nextEvent()) |e| {
        output.clear();

        size = try zbox.size();

        try output.resize(size.height, size.width);

        const width = size.width / 2;
        try left.resize(size.height, width);
        try right.resize(size.height, width);
        try distances_by_month.draw(&left, size.height, width);
        try distances_by_year.draw(&right, size.height, width);

        output.blit(left, 0, 0);
        output.blit(right, 0, @intCast(isize, width));

        // try list_view.draw(&output);

        try zbox.push(output);

        switch (e) {
            .escape => return,
            else => list_view.handleInput(e),
        }
    }
}

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

fn getDistancesByYear(allocator: *std.mem.Allocator, files: []const fit.File) !std.AutoArrayHashMap(u16, u32) {
    var hm = std.AutoArrayHashMap(u16, u32).init(allocator);
    for (files) |f| {
        const corrected_ts = f.session.start_time + fit.GARMIN_EPOCH;
        const year = dt.Date.fromSeconds(@intToFloat(f64, corrected_ts)).year;
        var e = try hm.getOrPut(year);
        if (!e.found_existing) e.entry.value = 0;
        e.entry.value += f.session.total_distance;
    }
    return hm;
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

    var distances_by_year = try getDistancesByYear(&gpa.allocator, files.items);
    defer distances_by_year.deinit();

    var max_distance: u32 = 0;
    for (distances_by_year.items()) |entry| {
        if (entry.value > max_distance) {
            max_distance = entry.value;
        }
    }

    while (try zbox.nextEvent()) |e| {
        output.clear();

        size = try zbox.size();

        try output.resize(size.height, size.width);

        const width = size.width / 2;
        var cursor = output.cursorAt(0, 0);
        const each_column_val = @intToFloat(f32, max_distance) / @intToFloat(f32, width);
        for (distances_by_year.items()) |entry| {
            try cursor.writer().print(" {} ", .{entry.key});
            const bar_width = @floatToInt(u32, @intToFloat(f32, entry.value) / each_column_val);
            var i: usize = 0;
            cursor.attribs.fg_white = false;
            cursor.attribs.fg_cyan = true;
            while (i < bar_width) : (i += 1) {
                _ = try cursor.writer().write("▇");
            }
            cursor.attribs.fg_white = true;
            cursor.attribs.fg_cyan = false;
            try parseVal(f32, .distance, entry.value).printUnit(cursor.writer(), " {d:.2}{s}", .miles);
            _ = try cursor.writer().write("\n");
        }

        // try list_view.draw(&output);

        try zbox.push(output);

        switch (e) {
            .escape => return,
            else => list_view.handleInput(e),
        }
    }
}

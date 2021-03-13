const std = @import("std");
const fit = @import("fit/fit.zig");
const ui = @import("ui.zig");
const units = @import("units.zig");
const zbox = @import("zbox");

const PATH = "/home/mjh/fit_files";

fn parseVal(comptime T: type, comptime metric: units.Metric, value: anytype) units.UnittedType(T, metric.standard()) {
    const v = @intToFloat(T, value);
    return units.parseVal(T, metric, v);
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    std.log.debug("path: {s}", .{PATH});

    var walker = try std.fs.walkPath(&gpa.allocator, PATH);
    defer walker.deinit();

    var paths = std.ArrayList([]const u8).init(&gpa.allocator);
    defer {
        for (paths.items) |p| {
            gpa.allocator.free(p);
        }
        paths.deinit();
    }
    var files = std.ArrayList(fit.File).init(&gpa.allocator);
    defer files.deinit();

    while (try walker.next()) |node| {
        const path = try gpa.allocator.alloc(u8, node.path.len);
        std.mem.copy(u8, path, node.path);
        try paths.append(path);

        var f = try std.fs.openFileAbsolute(path, .{});
        defer f.close();
        var reader = std.io.bufferedReader(f.reader()).reader();
        const file = try fit.Parser.parse_reader(&gpa.allocator, reader);
        try files.append(file);
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

    var list = try ui.List.init(&gpa.allocator, paths.items);
    defer list.deinit();

    var rest = try zbox.Buffer.init(&gpa.allocator, size.height, 2 * size.width / 3);
    defer rest.deinit();

    var rest_para = try zbox.Buffer.init(&gpa.allocator, size.height, 2 * size.width / 3);
    defer rest_para.deinit();

    while (try zbox.nextEvent()) |e| {
        output.clear();

        size = try zbox.size();
        const list_width = size.width / 3;

        try output.resize(size.height, size.width);

        try list.resize(size.height, list_width);
        try list.draw();
        output.blit(list.buf, 0, 1);

        rest.clear();
        try rest.resize(size.height, list_width * 2 - 1);
        try ui.drawBox(&rest);

        rest_para.clear();
        try rest_para.resize(size.height - 2, list_width * 2 - 3);
        const file = &files.items[list.selected];
        var cursor = rest_para.wrappedCursorAt(0, 0);
        var writer = cursor.writer();
        try writer.print("{s}\n", .{paths.items[list.selected]});
        try parseVal(f32, .distance, file.session.total_distance).printUnit(writer, "Distance: {d:.2}{s}\n", .miles);
        try parseVal(f32, .time, file.session.total_timer_time).printTime(writer, "Moving time: {s}\n");
        try parseVal(f32, .time, file.session.total_elapsed_time).printTime(writer, "Total time: {s}\n");
        try parseVal(f32, .speed, file.session.avg_speed).printUnit(writer, "Avg speed: {d:.2}{s}\n", .mph);
        try parseVal(f16, .frequency, file.session.avg_heart_rate).printUnit(writer, "Avg heart rate: {d:.0}{s}\n", .bpm);
        try parseVal(f16, .frequency, file.session.min_heart_rate).printUnit(writer, "Min heart rate: {d:.0}{s}\n", .bpm);
        try parseVal(f16, .frequency, file.session.max_heart_rate).printUnit(writer, "Max heart rate: {d:.0}{s}\n", .bpm);
        try parseVal(f16, .temperature, file.session.avg_temperature).printUnit(writer, "Avg temperature: {d:.0}{s}\n", .celcius);
        rest.blit(rest_para, 1, 1);

        output.blit(rest, 0, @intCast(isize, list_width + 1));

        try zbox.push(output);

        switch (e) {
            .escape => return,
            else => list.handleInput(e),
        }
    }
}

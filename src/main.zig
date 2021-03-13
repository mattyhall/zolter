const std = @import("std");
const fit = @import("fit/fit.zig");
const ui = @import("ui.zig");
const zbox = @import("zbox");

const PATH = "/home/mjh/fit_files";

fn drawBox(buf: *zbox.Buffer) !void {
    var cursor = buf.cursorAt(0, 0);
    var writer = cursor.writer();
    try writer.writeAll("┌");
    var i: usize = 0;
    while (i < buf.width - 2) : (i += 1) {
        try writer.writeAll("─");
    }
    try writer.writeAll("┐");

    i = 1;
    while (i < buf.height - 1) : (i += 1) {
        cursor = buf.cursorAt(i, 0);
        writer = cursor.writer();
        try writer.writeAll("│");
        cursor = buf.cursorAt(i, buf.width - 1);
        writer = cursor.writer();
        try writer.writeAll("│");
    }

    cursor = buf.cursorAt(buf.height - 1, 0);
    writer = cursor.writer();
    try writer.writeAll("└");
    i = 0;
    while (i < buf.width - 2) : (i += 1) {
        try writer.writeAll("─");
    }
    try writer.writeAll("┘");
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

    while (try walker.next()) |node| {
        const path = try gpa.allocator.alloc(u8, node.path.len);
        std.mem.copy(u8, path, node.path);
        try paths.append(path);
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

    while (try zbox.nextEvent()) |e| {
        output.clear();

        size = try zbox.size();
        const list_width = size.width / 3;

        try output.resize(size.height, size.width);

        try list.resize(size.height, list_width);
        try list.draw();

        output.blit(list.buf, 0, 1);

        try zbox.push(output);

        switch (e) {
            .escape => return,
            else => list.handleInput(e),
        }
    }
}

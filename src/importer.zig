const std = @import("std");
const db = @import("db.zig");
const fit = @import("fit/fit.zig");

const PATH = "/home/mjh/fit_files";

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    var cache = try db.openDb();

    var walker = try std.fs.walkPath(&gpa.allocator, PATH);
    defer walker.deinit();

    while (try walker.next()) |node| {
        const path = try gpa.allocator.alloc(u8, node.path.len);
        defer gpa.allocator.free(path);
        std.mem.copy(u8, path, node.path);

        var f = try std.fs.openFileAbsolute(path, .{});
        defer f.close();
        var reader = std.io.bufferedReader(f.reader()).reader();
        const file = try fit.Parser.parse_reader(&gpa.allocator, reader);
        const activity = db.activityFromSession(path, &file.session);

        db.insertActivity(&cache, &activity) catch |e| {
            switch (e) {
                error.AlreadyExists => std.log.debug("already have {s}", .{activity.name}),
                else => return e,
            }
        };
    }
}

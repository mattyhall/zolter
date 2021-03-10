const std = @import("std");
const fit = @import("fit/fit.zig");

const PATH = "/home/mjh/fit_files/2020-04-04-094944-ELEMNT BOLT 9516-18-0.fit";

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    var f = try std.fs.openFileAbsolute(PATH, .{});
    defer f.close();

    var reader = std.io.bufferedReader(f.reader()).reader();

    std.log.debug("path: {s}", .{PATH});
    const file = fit.Parser.parse_reader(&gpa.allocator, reader);
}

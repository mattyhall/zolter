const std = @import("std");
const fit = @import("fit/fit.zig");
const Parser = fit.streaming_parser.Parser;
const defs = fit.defs;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
}

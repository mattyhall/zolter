const std = @import("std");
const db = @import("db.zig");

pub fn main() !void {
    _ = try db.openDb();
}

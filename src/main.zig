const std = @import("std");

const path = "/mnt/c/Users/matth/Documents/fit_files/2019-09-22-122706-ELEMNT BOLT 9516-11-0.fit";

const FitFile = struct {
    protocol_version: u8,
    profile_version: u16,
    data_size: u32,
};

const ParseError = error{
    NoMagicInHeader,
    Eof,
    NotNormalHeader,
    InvalidReserveBit,
};

fn Parser(comptime Reader: anytype) type {
    return struct {
        reader: Reader,
        file: FitFile,

        const Self = @This();

        fn init(reader: Reader) Self {
            return .{
                .reader = reader,
                .file = undefined,
            };
        }

        fn parseHeader(self: *Self) !void {
            const size = try self.reader.readInt(u8, .Little);
            std.log.debug("header size: {}", .{size});
            self.file.protocol_version = try self.reader.readInt(u8, .Little);
            std.log.debug("protocol version: {}", .{self.file.protocol_version});
            self.file.profile_version = try self.reader.readInt(u16, .Little);
            std.log.debug("profile version: {}", .{self.file.profile_version});
            self.file.data_size = try self.reader.readInt(u32, .Little);
            std.log.debug("data size: {}", .{self.file.data_size});
            var magic_buffer: [4]u8 = undefined;
            const read = self.reader.read(&magic_buffer) catch |err| {
                return ParseError.Eof;
            };
            if (read != 4 or !std.mem.eql(u8, ".FIT", &magic_buffer)) {
                return ParseError.NoMagicInHeader; // Expected ".FIT" in header
            }

            if (size == 14) {
                // TODO: check this
                const crc = try self.reader.readInt(u16, .Little);
                std.log.debug("crc: {}", .{crc});
            }
        }

        fn parse(self: *Self) !void {
            try self.parseHeader();
        }
    };
}

pub fn main() !void {
    var f = try std.fs.openFileAbsolute(path, .{});
    defer f.close();

    var reader = std.io.bufferedReader(f.reader()).reader();
    var parser = Parser(@TypeOf(reader)).init(reader);
    try parser.parse();
}

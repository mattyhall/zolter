const std = @import("std");
const defs = @import("defs.zig");

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

        fn parseRecordDefinition(self: *Self, dev: bool) !void {
            const reserved = try self.reader.readInt(u8, .Little);
            if (reserved != 0) return ParseError.InvalidReserveBit;
            const endian: std.builtin.Endian = if ((try self.reader.readInt(u8, .Little)) == 0)
                .Little
            else
                .Big;
            std.log.debug("endianess: {}", .{endian});
            const global_msg_num = try self.reader.readInt(u16, endian);
            std.log.debug("global msg num: {}", .{global_msg_num});
            const fields = try self.reader.readInt(u8, endian);
            std.log.debug("num fields: {}", .{fields});
            var i: usize = 0;
            while (i < fields) : (i += 1) {
                const def_num = try self.reader.readInt(u8, endian);
                const size = try self.reader.readInt(u8, endian);
                const base_type = try self.reader.readInt(u8, endian);
                const typ = @intToEnum(defs.Types, base_type);
                std.log.debug("field {s}, size {}, type {}", .{ defs.KnownFileIdFields.to_string(def_num), size, typ });
            }

            if (dev) {
                const dev_fields = try self.reader.readInt(u8, endian);
                std.log.debug("skipping {} dev fields", .{dev_fields});
                i = 0;
                while (i < dev_fields) : (i += 1) {
                    // TODO store dev fields?
                    _ = try self.reader.readInt(u24, endian);
                }
            }
        }

        fn parseRecordHeader(self: *Self) !void {
            const header = try self.reader.readInt(u8, .Little);
            std.log.debug("{x} {b}", .{ header, header });
            const header_type = header & (1 << 7);
            if (header_type != 0) return ParseError.NotNormalHeader; // TODO: handle timestamp headers
            const typ: MsgType = if (header & (1 << 6) != 0) .definition else .data;
            std.log.debug("message type: {}", .{typ});
            const dev = if (header & (1 << 5) != 0) true else false;
            std.log.debug("dev {}", .{dev});
            if (typ == .definition) {
                const reserved = header & (1 << 4);
                if (reserved != 0) return ParseError.InvalidReserveBit;
                const local_typ = header & (0b00000111);
                std.log.debug("local_typ: {}", .{local_typ});
                try self.parseRecordDefinition(dev);
            } else {
                // TODO
                @panic("todo, handle data");
            }
        }

        fn parse(self: *Self) !void {
            try self.parseHeader();
            try self.parseRecordHeader();
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

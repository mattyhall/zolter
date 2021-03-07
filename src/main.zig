const std = @import("std");
const defs = @import("defs.zig");

const path = "/mnt/c/Users/matth/Documents/fit_files/2019-09-22-122706-ELEMNT BOLT 9516-11-0.fit";

const ParseError = error{
    NoMagicInHeader,
    Eof,
    NotNormalHeader,
    InvalidReserveBit,
};

const MsgType = enum {
    definition,
    data,
};

const Field = struct {
    field: u8,
    size: u8,
    typ: defs.Types,
};

const Definition = struct {
    endian: std.builtin.Endian,
    local_msg_type: u4,
    global_msg_type: u16,
    fields: std.ArrayList(Field),

    const Self = @This();

    fn deinit(self: *Self) void {
        self.fields.deinit();
    }
};

const Header = struct {
    protocol_version: u8,
    profile_version: u16,
    data_size: u32,
};

const Event = union(enum) {
    header: Header,
    definition: Definition,
    // TODO data record
};

fn Parser(comptime Reader: anytype) type {
    return struct {
        reader: Reader,
        allocator: *std.mem.Allocator,
        had_header: bool = false,

        const Self = @This();

        fn init(allocator: *std.mem.Allocator, reader: Reader) Self {
            return .{
                .allocator = allocator,
                .reader = reader,
            };
        }

        fn parseHeader(self: *Self) !Event {
            const size = try self.reader.readInt(u8, .Little);
            var header: Header = undefined;
            header.protocol_version = try self.reader.readInt(u8, .Little);
            header.profile_version = try self.reader.readInt(u16, .Little);
            header.data_size = try self.reader.readInt(u32, .Little);
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
            }
            return Event{ .header = header };
        }

        fn parseRecordDefinition(self: *Self, dev: bool) !Definition {
            const reserved = try self.reader.readInt(u8, .Little);
            if (reserved != 0) return ParseError.InvalidReserveBit;

            var def: Definition = undefined;
            def.endian = if ((try self.reader.readInt(u8, .Little)) == 0)
                .Little
            else
                .Big;
            def.global_msg_type = try self.reader.readInt(u16, def.endian);

            const num_fields = try self.reader.readInt(u8, def.endian);
            var fields = std.ArrayList(Field).init(self.allocator);
            try fields.ensureCapacity(num_fields);
            var i: usize = 0;
            while (i < num_fields) : (i += 1) {
                var field: Field = undefined;
                field.field = try self.reader.readInt(u8, def.endian);
                field.size = try self.reader.readInt(u8, def.endian);
                const typ = try self.reader.readInt(u8, def.endian);
                field.typ = @intToEnum(defs.Types, typ);
                fields.appendAssumeCapacity(field);
            }
            def.fields = fields;

            if (dev) {
                const dev_fields = try self.reader.readInt(u8, def.endian);
                std.log.debug("skipping {} dev fields", .{dev_fields});
                i = 0;
                while (i < dev_fields) : (i += 1) {
                    // TODO store dev fields?
                    _ = try self.reader.readInt(u24, def.endian);
                }
            }

            return def;
        }

        fn parseRecord(self: *Self) !Event {
            const header = try self.reader.readInt(u8, .Little);
            const header_type = header & (1 << 7);
            if (header_type != 0) return ParseError.NotNormalHeader; // TODO: handle timestamp headers
            const typ: MsgType = if (header & (1 << 6) != 0) .definition else .data;
            const dev = if (header & (1 << 5) != 0) true else false;

            if (typ == .definition) {
                const reserved = header & (1 << 4);
                if (reserved != 0) return ParseError.InvalidReserveBit;
                const local_typ = header & (0b00000111);
                var def = try self.parseRecordDefinition(dev);
                def.local_msg_type = @intCast(u4, local_typ);
                return Event{ .definition = def };
            } else {
                @panic("todo, handle data"); // TODO
            }
        }

        fn next(self: *Self) !?Event {
            if (!self.had_header) {
                self.had_header = true;
                return try self.parseHeader();
            }
            return try self.parseRecord();
        }
    };
}

pub fn main() !void {
    var f = try std.fs.openFileAbsolute(path, .{});
    defer f.close();

    var reader = std.io.bufferedReader(f.reader()).reader();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    var parser = Parser(@TypeOf(reader)).init(&gpa.allocator, reader);
    while (try parser.next()) |*ev| {
        switch (ev.*) {
            .header => |hdr| {
                std.log.debug("got file header: protocol version {}, profile version {}, size {}", .{ hdr.protocol_version, hdr.profile_version, hdr.data_size });
            },
            .definition => |*def| {
                defer def.deinit();
                std.log.debug("def of type {s}", .{defs.MsgTypes.toString(def.global_msg_type)});
                for (def.fields.items) |field| {
                    if (def.global_msg_type == defs.MsgTypes.file_id) {
                        std.log.debug("  got field {s} of size {} and type {}", .{ defs.FileIdFields.toString(field.field), field.size, field.typ });
                    } else {
                        std.log.debug("  got unknown field", .{});
                    }
                }
            },
        }
    }
}

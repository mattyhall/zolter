const std = @import("std");
const defs = @import("defs.zig");

const path = "/mnt/c/Users/matth/Documents/fit_files/2019-09-22-122706-ELEMNT BOLT 9516-11-0.fit";

const ParseError = error{
    NoMagicInHeader,
    Eof,
    NotNormalHeader,
    InvalidReserveBit,
    UnrecognisedLocalType,
};

const MsgType = enum {
    definition,
    data,
};

const DevField = struct {
    number: u8,
    size: u8,
    developer_data_index: u8,
};

const Field = struct {
    field: u8,
    size: u8,
    typ: u8,
};

const Definition = struct {
    endian: std.builtin.Endian,
    local_msg_type: u4,
    global_msg_type: u16,
    fields: std.ArrayList(Field),
    dev_fields: std.ArrayList(DevField),

    const Self = @This();

    fn deinit(self: *Self) void {
        self.fields.deinit();
        self.dev_fields.deinit();
    }
};

const Header = struct {
    protocol_version: u8,
    profile_version: u16,
    data_size: u32,
};

const Data = struct {
    local_msg_type: u4,
    data: std.ArrayList(u8),

    const Self = @This();

    fn deinit(self: *Self) void {
        self.data.deinit();
    }
};

const Event = union(enum) {
    header: Header,
    definition: Definition,
    data: Data,
    // TODO data record
};

fn Parser(comptime Reader: anytype) type {
    return struct {
        reader: Reader,
        allocator: *std.mem.Allocator,
        definitions: []?Definition,
        had_header: bool = false,

        const Self = @This();

        fn init(allocator: *std.mem.Allocator, reader: Reader) !Self {
            var self = Self{
                .allocator = allocator,
                .reader = reader,
                .definitions = try allocator.alloc(?Definition, std.math.maxInt(u4)),
            };
            var i: usize = 0;
            while (i < self.definitions.len) : (i += 1) {
                self.definitions[i] = null;
            }
            return self;
        }

        fn deinit(self: *Self) void {
            for (self.definitions) |*def| {
                if (def.*) |*d| {
                    d.deinit();
                }
            }
            self.allocator.destroy(self.definitions.ptr);
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
                field.typ = try self.reader.readInt(u8, def.endian);
                fields.appendAssumeCapacity(field);
            }
            def.fields = fields;

            var dev_fields = std.ArrayList(DevField).init(self.allocator);
            if (dev) {
                const num_dev_fields = try self.reader.readInt(u8, def.endian);
                try dev_fields.ensureCapacity(num_dev_fields);
                i = 0;
                while (i < num_dev_fields) : (i += 1) {
                    var field: DevField = undefined;
                    field.number = try self.reader.readInt(u8, def.endian);
                    field.size = try self.reader.readInt(u8, def.endian);
                    field.developer_data_index = try self.reader.readInt(u8, def.endian);
                    dev_fields.appendAssumeCapacity(field);
                }
            }
            def.dev_fields = dev_fields;

            return def;
        }

        fn parseRecord(self: *Self) !Event {
            const header = try self.reader.readInt(u8, .Little);
            const header_type = header & (1 << 7);
            if (header_type != 0) return ParseError.NotNormalHeader; // TODO: handle timestamp headers
            const typ: MsgType = if (header & (1 << 6) != 0) .definition else .data;
            const reserved = header & (1 << 4);
            if (reserved != 0) return ParseError.InvalidReserveBit;
            const local_typ = header & (0b00000111);

            if (typ == .definition) {
                const dev = if (header & (1 << 5) != 0) true else false;
                var def = try self.parseRecordDefinition(dev);
                def.local_msg_type = @intCast(u4, local_typ);
                if (self.definitions[def.local_msg_type]) |*old_def| {
                    old_def.deinit();
                }
                self.definitions[def.local_msg_type] = def;
                return Event{ .definition = def };
            } else {
                const def = &self.definitions[local_typ];
                _ = def.* orelse return ParseError.UnrecognisedLocalType;
                var bytes: usize = 0;
                for (def.*.?.fields.items) |field| {
                    bytes += field.size;
                }
                var data = Data{
                    .local_msg_type = @intCast(u4, local_typ),
                    .data = std.ArrayList(u8).init(self.allocator),
                };
                try data.data.resize(bytes);
                const read = try self.reader.read(data.data.items);
                if (read != bytes) {
                    return ParseError.Eof;
                }
                return Event{ .data = data };
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

    var parser = try Parser(@TypeOf(reader)).init(&gpa.allocator, reader);
    defer parser.deinit();

    while (try parser.next()) |*ev| {
        switch (ev.*) {
            .header => |hdr| {
                std.log.debug("got file header: protocol version {}, profile version {}, size {}", .{ hdr.protocol_version, hdr.profile_version, hdr.data_size });
            },
            .definition => |*def| {
                std.log.debug("def of type {s}", .{defs.MesgNum.toString(def.global_msg_type)});
                for (def.fields.items) |field| {
                    if (def.global_msg_type == defs.MesgNum.file_id) {
                        std.log.debug("  got field {s} of size {} and type {}", .{ defs.FileIdFieldNum.toString(field.field), field.size, field.typ });
                    } else {
                        std.log.debug("  got unknown field", .{});
                    }
                }
            },
            .data => |*data| blk: {
                defer data.deinit();
                const def = parser.definitions[data.local_msg_type] orelse unreachable;
                if (def.global_msg_type != defs.MesgNum.file_id) {
                    std.log.debug("data for local type {}", .{data.local_msg_type});
                    break :blk;
                }
                var file_id_reader = std.io.fixedBufferStream(data.data.items).reader();
                const file_created = try file_id_reader.readInt(u32, def.endian);
                const typ = try file_id_reader.readInt(u8, def.endian);
                const manufacturer = try file_id_reader.readInt(u16, def.endian);
                const product = try file_id_reader.readInt(u16, def.endian);
                const serial_number = try file_id_reader.readInt(u32, def.endian);
                std.log.debug("data for file id: file_created {}, typ: {}, manufacturer: {}, product: {}, serial number: {}", .{ file_created, typ, manufacturer, product, serial_number });
            },
        }
    }
}

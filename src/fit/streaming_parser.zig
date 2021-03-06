const std = @import("std");
const defs = @import("defs.zig");

pub const Error = error{
    NoMagicInHeader,
    Eof,
    InvalidReserveBit,
    UnrecognisedLocalType,
};

const MsgType = enum {
    definition,
    data,
};

pub const DevField = struct {
    number: u8,
    size: u8,
    developer_data_index: u8,
};

pub const Field = struct {
    field: u8,
    size: u8,
    typ: u8,
};

pub const Definition = struct {
    endian: std.builtin.Endian,
    local_msg_type: u4,
    global_msg_type: u16,
    fields: std.ArrayList(Field),
    dev_fields: std.ArrayList(DevField),

    const Self = @This();

    pub fn deinit(self: *Self) void {
        self.fields.deinit();
        self.dev_fields.deinit();
    }
};

pub const Header = struct {
    protocol_version: u8,
    profile_version: u16,
    data_size: u32,
};

pub const Data = struct {
    time_offset: u5,
    local_msg_type: u4,
    data: std.ArrayList(u8),

    const Self = @This();

    pub fn deinit(self: *Self) void {
        self.data.deinit();
    }
};

pub const Event = union(enum) {
    header: Header,
    definition: Definition,
    data: Data,
};

pub fn Parser(comptime Reader: anytype) type {
    return struct {
        reader: Reader,
        allocator: *std.mem.Allocator,
        definitions: []?Definition,
        data_consumed: u32 = 0,
        data_size: u32 = 0,
        had_header: bool = false,

        const Self = @This();

        pub fn init(allocator: *std.mem.Allocator, reader: Reader) !Self {
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

        pub fn deinit(self: *Self) void {
            for (self.definitions) |*def| {
                if (def.*) |*d| {
                    d.deinit();
                }
            }
            self.allocator.free(self.definitions);
        }

        fn readInt(self: *Self, comptime T: anytype, endian: std.builtin.Endian) !T {
            const res = try self.reader.readInt(T, endian);
            self.data_consumed += @sizeOf(T);
            return res;
        }

        fn read(self: *Self, slice: []u8) !usize {
            const num_read = try self.reader.read(slice);
            self.data_consumed += @intCast(u32, num_read);
            return num_read;
        }

        fn parseHeader(self: *Self) !Event {
            const size = try self.readInt(u8, .Little);
            var header: Header = undefined;
            header.protocol_version = try self.readInt(u8, .Little);
            header.profile_version = try self.readInt(u16, .Little);
            header.data_size = try self.readInt(u32, .Little);
            var magic_buffer: [4]u8 = undefined;
            const num_read = self.read(&magic_buffer) catch |err| {
                return Error.Eof;
            };
            if (num_read != 4 or !std.mem.eql(u8, ".FIT", &magic_buffer)) {
                return Error.NoMagicInHeader; // Expected ".FIT" in header
            }

            if (size == 14) {
                // TODO: check this
                const crc = try self.readInt(u16, .Little);
            }
            return Event{ .header = header };
        }

        fn parseRecordDefinition(self: *Self, dev: bool) !Definition {
            const reserved = try self.readInt(u8, .Little);
            // if (reserved != 0) return Error.InvalidReserveBit;

            var def: Definition = undefined;
            def.endian = if ((try self.readInt(u8, .Little)) == 0)
                .Little
            else
                .Big;
            def.global_msg_type = try self.readInt(u16, def.endian);

            const num_fields = try self.readInt(u8, def.endian);
            var fields = std.ArrayList(Field).init(self.allocator);
            try fields.ensureCapacity(num_fields);
            var i: usize = 0;
            while (i < num_fields) : (i += 1) {
                var field: Field = undefined;
                field.field = try self.readInt(u8, def.endian);
                field.size = try self.readInt(u8, def.endian);
                field.typ = try self.readInt(u8, def.endian);
                fields.appendAssumeCapacity(field);
            }
            def.fields = fields;

            var dev_fields = std.ArrayList(DevField).init(self.allocator);
            if (dev) {
                const num_dev_fields = try self.readInt(u8, def.endian);
                try dev_fields.ensureCapacity(num_dev_fields);
                i = 0;
                while (i < num_dev_fields) : (i += 1) {
                    var field: DevField = undefined;
                    field.number = try self.readInt(u8, def.endian);
                    field.size = try self.readInt(u8, def.endian);
                    field.developer_data_index = try self.readInt(u8, def.endian);
                    dev_fields.appendAssumeCapacity(field);
                }
            }
            def.dev_fields = dev_fields;

            return def;
        }

        fn parseRecord(self: *Self) !Event {
            const header = try self.readInt(u8, .Little);
            const header_type = header & (1 << 7);
            const info: struct { typ: MsgType, local_typ: u8, offset: u8 } = if (header_type != 0) blk: { // timestamp
                const local_type = (header & (0b01100000)) >> 5;
                const offset = header & (0b00011111);
                break :blk .{
                    .typ = MsgType.data,
                    .local_typ = local_type,
                    .offset = offset,
                };
            } else blk: {
                const typ: MsgType = if (header & (1 << 6) != 0) .definition else .data;
                const reserved = header & (1 << 4);
                if (reserved != 0) return Error.InvalidReserveBit;
                const local_typ = header & (0b00000111);
                break :blk .{
                    .typ = typ,
                    .local_typ = local_typ,
                    .offset = 0,
                };
            };

            if (info.typ == .definition) {
                const dev = if (header & (1 << 5) != 0) true else false;
                var def = try self.parseRecordDefinition(dev);
                def.local_msg_type = @intCast(u4, info.local_typ);
                if (self.definitions[def.local_msg_type]) |*old_def| {
                    old_def.deinit();
                }
                self.definitions[def.local_msg_type] = def;
                return Event{ .definition = def };
            } else {
                const def = &self.definitions[info.local_typ];
                _ = def.* orelse return Error.UnrecognisedLocalType;
                var bytes: usize = 0;
                for (def.*.?.fields.items) |field| {
                    bytes += field.size;
                }
                for (def.*.?.dev_fields.items) |field| {
                    bytes += field.size;
                }
                var data = Data{
                    .local_msg_type = @intCast(u4, info.local_typ),
                    .time_offset = @intCast(u5, info.offset),
                    .data = std.ArrayList(u8).init(self.allocator),
                };
                try data.data.resize(bytes);
                const num_read = try self.read(data.data.items);
                if (num_read != bytes) {
                    return Error.Eof;
                }
                return Event{ .data = data };
            }
        }

        pub fn next(self: *Self) !?Event {
            if (self.data_size != 0 and self.data_consumed >= self.data_size) {
                return null;
            }
            if (!self.had_header) {
                self.had_header = true;
                const hdr = try self.parseHeader();
                self.data_size = hdr.header.data_size;
                self.data_consumed = 0;
                return hdr;
            }
            return try self.parseRecord();
        }
    };
}

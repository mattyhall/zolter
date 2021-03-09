const std = @import("std");
const defs = @import("defs.zig");

const PATH = "/home/mjh/fit_files";

const ParseError = error{
    NoMagicInHeader,
    Eof,
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
    time_offset: u5,
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
};

fn Parser(comptime Reader: anytype) type {
    return struct {
        reader: Reader,
        allocator: *std.mem.Allocator,
        definitions: []?Definition,
        data_consumed: u32 = 0,
        data_size: u32 = 0,
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
                return ParseError.Eof;
            };
            if (num_read != 4 or !std.mem.eql(u8, ".FIT", &magic_buffer)) {
                return ParseError.NoMagicInHeader; // Expected ".FIT" in header
            }

            if (size == 14) {
                // TODO: check this
                const crc = try self.readInt(u16, .Little);
            }
            return Event{ .header = header };
        }

        fn parseRecordDefinition(self: *Self, dev: bool) !Definition {
            const reserved = try self.readInt(u8, .Little);
            // if (reserved != 0) return ParseError.InvalidReserveBit;

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
                if (reserved != 0) return ParseError.InvalidReserveBit;
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
                _ = def.* orelse return ParseError.UnrecognisedLocalType;
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
                    return ParseError.Eof;
                }
                return Event{ .data = data };
            }
        }

        fn next(self: *Self) !?Event {
            if (self.data_size != 0 and self.data_consumed >= self.data_size) {
                return null;
            }
            if (!self.had_header) {
                self.had_header = true;
                const hdr = try self.parseHeader();
                self.data_size = hdr.header.data_size;
                self.data_consumed = 0;
            }
            return try self.parseRecord();
        }
    };
}

fn readArray(comptime T: type, n: usize, allocator: *std.mem.Allocator, reader: anytype, endian: std.builtin.Endian) ![]T {
    var out: []T = try allocator.alloc(T, n);
    for (out) |*space| {
        space.* = try reader.readInt(T, endian);
    }
    return out;
}

fn printField(comptime T: type, field_name: []const u8, size: usize, allocator: *std.mem.Allocator, reader: anytype, endian: std.builtin.Endian, out_buf: []u8) !usize {
    if (size == @sizeOf(T)) {
        const written = try std.fmt.bufPrint(out_buf, "{s}: {}, ", .{ field_name, try reader.readInt(T, endian) });
        return written.len;
    }
    const array = try readArray(T, size / @sizeOf(T), allocator, reader, endian);
    defer allocator.free(array);
    const written = try std.fmt.bufPrint(out_buf, "{s}: {any}, ", .{ field_name, array });
    return written.len;
}

pub fn parseFile(allocator: *std.mem.Allocator, path: []const u8) !void {
    var f = try std.fs.openFileAbsolute(path, .{});
    defer f.close();

    var reader = std.io.bufferedReader(f.reader()).reader();

    var parser = try Parser(@TypeOf(reader)).init(allocator, reader);
    defer parser.deinit();

    while (try parser.next()) |*ev| {
        switch (ev.*) {
            .header => |hdr| {
                std.log.debug("got file header: protocol version {}, profile version {}, size {}", .{ hdr.protocol_version, hdr.profile_version, hdr.data_size });
            },
            .definition => |*def| {},
            .data => |*data| blk: {
                defer data.deinit();
                const def = parser.definitions[data.local_msg_type] orelse unreachable;
                const func = switch (def.global_msg_type) {
                    defs.MesgNum.file_id => defs.FileIdFieldNum.toString,
                    defs.MesgNum.device_info => defs.DeviceInfoFieldNum.toString,
                    defs.MesgNum.record => defs.RecordFieldNum.toString,
                    defs.MesgNum.sport => defs.SportFieldNum.toString,
                    defs.MesgNum.hr_zone => defs.HrZoneFieldNum.toString,
                    defs.MesgNum.power_zone => defs.PowerZoneFieldNum.toString,
                    defs.MesgNum.event => defs.EventFieldNum.toString,
                    defs.MesgNum.field_description => defs.FieldDescriptionFieldNum.toString,
                    defs.MesgNum.workout => defs.WorkoutFieldNum.toString,
                    defs.MesgNum.capabilities => defs.CapabilitiesFieldNum.toString,
                    defs.MesgNum.session => defs.SessionFieldNum.toString,
                    defs.MesgNum.activity => defs.SessionFieldNum.toString,
                    else => break :blk,
                };
                var data_reader = std.io.fixedBufferStream(data.data.items).reader();
                var tmp_buf: [1024]u8 = undefined;
                var end_of_tmp_buf: usize = 0;
                for (def.fields.items) |field| {
                    switch (field.typ) {
                        defs.FitBaseType.uint8, defs.FitBaseType.uint8z => {
                            end_of_tmp_buf += try printField(u8, func(field.field), field.size, allocator, data_reader, def.endian, tmp_buf[end_of_tmp_buf..]);
                        },
                        defs.FitBaseType.sint8 => {
                            end_of_tmp_buf += try printField(i8, func(field.field), field.size, allocator, data_reader, def.endian, tmp_buf[end_of_tmp_buf..]);
                        },
                        defs.FitBaseType.uint16, defs.FitBaseType.uint16z => {
                            end_of_tmp_buf += try printField(u16, func(field.field), field.size, allocator, data_reader, def.endian, tmp_buf[end_of_tmp_buf..]);
                        },
                        defs.FitBaseType.sint16 => {
                            end_of_tmp_buf += try printField(i16, func(field.field), field.size, allocator, data_reader, def.endian, tmp_buf[end_of_tmp_buf..]);
                        },
                        defs.FitBaseType.uint32, defs.FitBaseType.uint32z => {
                            end_of_tmp_buf += try printField(u32, func(field.field), field.size, allocator, data_reader, def.endian, tmp_buf[end_of_tmp_buf..]);
                        },
                        defs.FitBaseType.sint32 => {
                            end_of_tmp_buf += try printField(i32, func(field.field), field.size, allocator, data_reader, def.endian, tmp_buf[end_of_tmp_buf..]);
                        },
                        defs.FitBaseType.@"enum" => {
                            var data_bytes: [4]u8 = [_]u8{0} ** 4;
                            _ = try data_reader.read(data_bytes[0..field.size]);
                            var out: u32 = 0;
                            for (data_bytes[0..field.size]) |n| {
                                out <<= 8;
                                out |= n;
                            }
                            end_of_tmp_buf += (try std.fmt.bufPrint(tmp_buf[end_of_tmp_buf..], "{s}: {}, ", .{ func(field.field), out })).len;
                        },
                        defs.FitBaseType.string => {
                            var bytes = try allocator.alloc(u8, field.size);
                            defer _ = allocator.free(bytes);
                            _ = try data_reader.read(bytes);
                            const len = std.mem.indexOf(u8, bytes, &[1]u8{0}) orelse field.size;
                            end_of_tmp_buf += (try std.fmt.bufPrint(tmp_buf[end_of_tmp_buf..], "{s}: {s}, ", .{ func(field.field), bytes[0..len] })).len;
                        },
                        else => {
                            std.log.debug("could not show type {}", .{field.typ});
                            @panic("");
                        },
                    }
                }
                if (data.time_offset != 0) {
                    std.log.debug("data: {s} (ts offset {})", .{ tmp_buf[0..end_of_tmp_buf], data.time_offset });
                } else {
                    std.log.debug("data: {s}", .{tmp_buf[0..end_of_tmp_buf]});
                }
            },
        }
    }
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    var walker = try std.fs.walkPath(&gpa.allocator, PATH);
    defer walker.deinit();
    while (try walker.next()) |node| {
        std.debug.print("path: {s}\n", .{node.path});
        try parseFile(&gpa.allocator, node.path);
        return;
    }
}

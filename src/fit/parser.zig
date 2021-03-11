const std = @import("std");
const streaming_parser = @import("streaming_parser.zig");
const defs = @import("defs.zig");

pub const Session = struct {
    start_time: u32 = 0,
    total_elapsed_time: u32 = 0,
    total_timer_time: u32 = 0,
    avg_speed: u16 = 0,
    max_speed: u16 = 0,
    total_distance: u32 = 0,
    avg_cadence: u8 = 0,
    max_cadence: u8 = 0,
    min_heart_rate: u8 = 0,
    max_heart_rate: u8 = 0,
    avg_heart_rate: u8 = 0,
    min_altitude: u16 = 0,
    max_altitude: u16 = 0,
    avg_altitude: u32 = 0,
    max_neg_grade: i16 = 0,
    avg_grade: i16 = 0,
    max_pos_grade: i16 = 0,
    total_calories: u16 = 0,
    avg_temperature: i8 = 0,
    max_temperature: i8 = 0,
    total_ascent: u16 = 0,
    total_descent: u16 = 0,
};

pub const File = struct {
    device: []const u8 = "unknown",
    sport: []const u8 = "unknown",
    session: Session,
};

fn FieldInfo(comptime Struct: type, comptime FieldType: type) type {
    return struct {
        name: []const u8,
        field_num: u16,

        const Self = @This();

        fn get(comptime self: *const Self, parent: *Struct) *FieldType {
            return &@field(parent, self.name);
        }
    };
}

fn FieldMappings(comptime Struct: type) type {
    return struct {
        u8s: ?[]const FieldInfo(Struct, u8) = null,
        i8s: ?[]const FieldInfo(Struct, i8) = null,
        u16s: ?[]const FieldInfo(Struct, u16) = null,
        i16s: ?[]const FieldInfo(Struct, i16) = null,
        u32s: ?[]const FieldInfo(Struct, u32) = null,
        i32s: ?[]const FieldInfo(Struct, i32) = null,
    };
}

fn generateMappingsType(comptime Struct: type, comptime info: *const std.builtin.TypeInfo.Struct, comptime FieldNums: anytype, comptime T: anytype) ?[]const FieldInfo(Struct, T) {
    comptime var n = 0;
    var mappings: [16]FieldInfo(Struct, T) = undefined;
    inline for (info.fields) |field| {
        if (field.field_type == T) {
            mappings[n] = .{ .name = field.name, .field_num = @field(FieldNums, field.name) };
            n += 1;
        }
    }
    if (n == 0) {
        return null;
    }
    return mappings[0..n];
}

fn generateMappings(comptime Struct: anytype, comptime FieldNums: anytype) FieldMappings(Struct) {
    const struct_info = switch (@typeInfo(Struct)) {
        .Struct => |si| si,
        else => @compileError("only works with structs"),
    };
    return .{
        .u8s = generateMappingsType(Struct, &struct_info, FieldNums, u8),
        .i8s = generateMappingsType(Struct, &struct_info, FieldNums, i8),
        .u16s = generateMappingsType(Struct, &struct_info, FieldNums, u16),
        .i16s = generateMappingsType(Struct, &struct_info, FieldNums, i16),
        .u32s = generateMappingsType(Struct, &struct_info, FieldNums, u32),
        .i32s = generateMappingsType(Struct, &struct_info, FieldNums, i32),
    };
}

fn fufillMapping(comptime Struct: type, comptime T: type, comptime mappings: FieldMappings(Struct), s: *Struct, v: T, field_num: u16) void {
    const typ_mappings: []const FieldInfo(Struct, T) = switch (T) {
        u8 => mappings.u8s,
        i8 => mappings.i8s,
        u16 => mappings.u16s,
        i16 => mappings.i16s,
        u32 => mappings.u32s,
        i32 => mappings.i32s,
        else => @panic("unexpected type"),
    } orelse return;
    inline for (typ_mappings) |map| {
        if (map.field_num == field_num) {
            map.get(s).* = v;
        }
    }
}

fn readField(reader: anytype, comptime T: type, size: u8, endian: std.builtin.Endian) ![]T {
    const n = size / @sizeOf(T);
    if (n > 16) return error.ArrayTooLarge;
    var data: [16]T = undefined;
    var i: usize = 0;
    while (i < n) : (i += 1) {
        data[i] = try reader.readInt(T, endian);
    }
    return data[0..n];
}

fn parseFields(comptime Struct: type, reader: anytype, comptime mappings: FieldMappings(Struct), fields: []const streaming_parser.Field, dest: *Struct, endian: std.builtin.Endian) !void {
    for (fields) |*field| {
        switch (field.typ) {
            defs.FitBaseType.uint8, defs.FitBaseType.uint8z => {
                const res = try readField(reader, u8, field.size, endian);
                fufillMapping(Struct, u8, mappings, dest, res[0], field.field);
            },
            defs.FitBaseType.sint8 => {
                const res = try readField(reader, i8, field.size, endian);
                fufillMapping(Struct, i8, mappings, dest, res[0], field.field);
            },
            defs.FitBaseType.uint16, defs.FitBaseType.uint16z => {
                const res = try readField(reader, u16, field.size, endian);
                fufillMapping(Struct, u16, mappings, dest, res[0], field.field);
            },
            defs.FitBaseType.sint16 => {
                const res = try readField(reader, i16, field.size, endian);
                fufillMapping(Struct, i16, mappings, dest, res[0], field.field);
            },
            defs.FitBaseType.uint32, defs.FitBaseType.uint32z => {
                const res = try readField(reader, u32, field.size, endian);
                fufillMapping(Struct, u32, mappings, dest, res[0], field.field);
            },
            defs.FitBaseType.sint32 => {
                const res = try readField(reader, i32, field.size, endian);
                fufillMapping(Struct, i32, mappings, dest, res[0], field.field);
            },
            defs.FitBaseType.@"enum" => {
                var data_bytes: [4]u8 = [_]u8{0} ** 4;
                _ = try reader.read(data_bytes[0..field.size]);
            },
            else => {
                std.log.debug("could not show type {}", .{field.typ});
                @panic("");
            },
        }
    }
}

const FileId = struct { manufacturer: u16 };

pub const Parser = struct {
    pub fn parse_reader(allocator: *std.mem.Allocator, reader: anytype) !File {
        var parser = try streaming_parser.Parser(@TypeOf(reader)).init(allocator, reader);
        defer parser.deinit();

        var file = File{ .session = .{} };

        var file_id: FileId = undefined;
        var session: Session = .{};

        while (try parser.next()) |*ev| {
            switch (ev.*) {
                .header => |hdr| {
                    std.log.debug("got file header: protocol version {}, profile version {}, size {}", .{ hdr.protocol_version, hdr.profile_version, hdr.data_size });
                },
                .definition => |*def| {},
                .data => |*data| blk: {
                    defer data.deinit();
                    const def = parser.definitions[data.local_msg_type] orelse unreachable;
                    var data_reader = std.io.fixedBufferStream(data.data.items).reader();
                    switch (def.global_msg_type) {
                        defs.MesgNum.file_id => {
                            std.log.debug("got file id", .{});
                            comptime const mappings = generateMappings(FileId, defs.FileIdFieldNum);
                            try parseFields(FileId, data_reader, mappings, def.fields.items, &file_id, def.endian);
                        },
                        defs.MesgNum.session => {
                            comptime const mappings = generateMappings(Session, defs.SessionFieldNum);
                            try parseFields(Session, data_reader, mappings, def.fields.items, &session, def.endian);
                        },
                        else => break :blk,
                    }
                },
            }
        }
        std.log.debug("finished", .{});
        std.log.debug("got session: {any}", .{session});
        return file;
    }
};

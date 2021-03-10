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
    sport: []const u8 = "unknown",
};

pub const File = struct {
    device: []const u8 = "unknown",
    sport: []const u8 = "unknown",
    session: Session,
};

fn FieldNumToField(comptime T: type) type {
    return struct {
        field_num: u16,
        field: *T,
    };
}

const FieldMappings = struct {
    u8s: ?[]const FieldNumToField(u8) = null,
    i8s: ?[]const FieldNumToField(i8) = null,
    u16s: ?[]const FieldNumToField(u16) = null,
    i16s: ?[]const FieldNumToField(i16) = null,
    u32s: ?[]const FieldNumToField(u32) = null,
    i32s: ?[]const FieldNumToField(i32) = null,
};

fn fufillMapping(mappings: FieldMappings, comptime T: type, field_num: u16, val: T) void {
    const typ_mappings: []const FieldNumToField(T) = switch (T) {
        u8 => mappings.u8s,
        i8 => mappings.i8s,
        u16 => mappings.u16s,
        i16 => mappings.i16s,
        u32 => mappings.u32s,
        i32 => mappings.i32s,
        else => @panic("unexpected type"),
    } orelse return;
    for (typ_mappings) |map| {
        if (map.field_num == field_num) {
            map.field.* = val;
        }
    }
}

fn parseFields(reader: anytype, endian: std.builtin.Endian, fields: []streaming_parser.Field, mappings: FieldMappings) !void {
    for (fields) |*field| {
        switch (field.typ) {
            defs.FitBaseType.uint8, defs.FitBaseType.uint8z => {
                const res = try reader.readInt(u8, endian);
                fufillMapping(mappings, u8, field.field, res);
            },
            defs.FitBaseType.sint8 => {
                const res = try reader.readInt(i8, endian);
                fufillMapping(mappings, i8, field.field, res);
            },
            defs.FitBaseType.uint16, defs.FitBaseType.uint16z => {
                const res = try reader.readInt(u16, endian);
                fufillMapping(mappings, u16, field.field, res);
            },
            defs.FitBaseType.sint16 => {
                const res = try reader.readInt(i16, endian);
                fufillMapping(mappings, i16, field.field, res);
            },
            defs.FitBaseType.uint32, defs.FitBaseType.uint32z => {
                const res = try reader.readInt(u32, endian);
                fufillMapping(mappings, u32, field.field, res);
            },
            defs.FitBaseType.sint32 => {
                const res = try reader.readInt(i32, endian);
                fufillMapping(mappings, i32, field.field, res);
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

fn f(comptime T: type, comptime FieldNum: type, dest: anytype, comptime name: []const u8) FieldNumToField(T) {
    return FieldNumToField(T){
        .field_num = @field(FieldNum, name),
        .field = &@field(dest, name),
    };
}

pub const Parser = struct {
    pub fn parse_reader(allocator: *std.mem.Allocator, reader: anytype) !File {
        var parser = try streaming_parser.Parser(@TypeOf(reader)).init(allocator, reader);
        defer parser.deinit();

        var file = File{ .session = .{} };

        var file_id: struct { manufacturer: u16 } = undefined;

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
                    const mappings = switch (def.global_msg_type) {
                        defs.MesgNum.file_id => FieldMappings{
                            .u16s = &[_]FieldNumToField(u16){
                                f(u16, defs.FileIdFieldNum, &file_id, "manufacturer"),
                            },
                        },
                        else => break :blk,
                    };

                    try parseFields(data_reader, def.endian, def.fields.items, mappings);

                    std.log.debug("file_id {}", .{
                        file_id.manufacturer,
                    });
                },
            }
        }
        return file;
    }
};

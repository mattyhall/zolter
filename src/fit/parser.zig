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

// Find fields in Struct that are of type T
fn findFieldsOfType(comptime Struct: type, comptime T: type) [][]const u8 {
    comptime var fields: [16][]const u8 = undefined;
    comptime var i = 0;
    switch (@typeInfo(Struct)) {
        .Struct => |si| {
            inline for (si.fields) |field| {
                if (field.field_type == T) {
                    fields[i] = field.name;
                    i += 1;
                    if (i == 16) {
                        @compileError("Too many fields of the same type");
                    }
                }
            }
        },
        else => @compileError("Struct must be a struct"),
    }
    return fields[0..i];
}

fn findFieldNumDecl(comptime FieldNums: type, field_num: u16) ?[]const u8 {
    const field_name = switch (@typeInfo(FieldNums)) {
        .Struct => |si| {
            inline for (si.decls) |decl| {
                switch (decl.data) {
                    .Var => {},
                    else => continue,
                }
                const n = @field(FieldNums, decl.name);
                if (field_num == n) {
                    return decl.name;
                }
            }
        },
        else => @compileError("FieldNums must be a struct of constants"),
    };
    return null;
}

fn assignField(comptime Struct: type, comptime T: type, comptime FieldNums: type, dest: *Struct, val: T, field_num: u16) void {
    comptime const fields = findFieldsOfType(Struct, T);
    const field_name = findFieldNumDecl(FieldNums, field_num) orelse unreachable;
    inline for (fields) |field| {
        if (std.mem.eql(u8, field, field_name)) {
            @field(dest, field) = val;
            return;
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

fn parseFields(comptime Struct: type, reader: anytype, fields: []const streaming_parser.Field, dest: *Struct, endian: std.builtin.Endian, comptime FieldNums: type) !void {
    for (fields) |*field| {
        switch (field.typ) {
            defs.FitBaseType.uint8, defs.FitBaseType.uint8z => {
                const res = try readField(reader, u8, field.size, endian);
                assignField(Struct, u8, FieldNums, dest, res[0], field.field);
            },
            defs.FitBaseType.sint8 => {
                const res = try readField(reader, i8, field.size, endian);
                assignField(Struct, i8, FieldNums, dest, res[0], field.field);
            },
            defs.FitBaseType.uint16, defs.FitBaseType.uint16z => {
                const res = try readField(reader, u16, field.size, endian);
                assignField(Struct, u16, FieldNums, dest, res[0], field.field);
            },
            defs.FitBaseType.sint16 => {
                const res = try readField(reader, i16, field.size, endian);
                assignField(Struct, i16, FieldNums, dest, res[0], field.field);
            },
            defs.FitBaseType.uint32, defs.FitBaseType.uint32z => {
                const res = try readField(reader, u32, field.size, endian);
                assignField(Struct, u32, FieldNums, dest, res[0], field.field);
            },
            defs.FitBaseType.sint32 => {
                const res = try readField(reader, i32, field.size, endian);
                assignField(Struct, i32, FieldNums, dest, res[0], field.field);
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
                .header => |hdr| {},
                .definition => |*def| {},
                .data => |*data| blk: {
                    defer data.deinit();
                    const def = parser.definitions[data.local_msg_type] orelse unreachable;
                    var data_reader = std.io.fixedBufferStream(data.data.items).reader();
                    switch (def.global_msg_type) {
                        defs.MesgNum.file_id => {
                            try parseFields(FileId, data_reader, def.fields.items, &file_id, def.endian, defs.FileIdFieldNum);
                        },
                        defs.MesgNum.session => {
                            try parseFields(Session, data_reader, def.fields.items, &session, def.endian, defs.SessionFieldNum);
                        },
                        else => break :blk,
                    }
                },
            }
        }
        file.session = session;
        return file;
    }
};

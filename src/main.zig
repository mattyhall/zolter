const std = @import("std");
const fit = @import("fit/fit.zig");
const Parser = fit.streaming_parser.Parser;
const defs = fit.defs;

const PATH = "/home/mjh/fit_files";

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

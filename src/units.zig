const std = @import("std");

pub const Metric = enum {
    distance,
    speed,
    time,
    abs_time,
    frequency,
    temperature,

    const Self = @This();

    pub fn standard(self: Self) Unit {
        return switch (self) {
            .distance => .meters,
            .speed => .ms,
            .time => .seconds,
            .abs_time => .seconds_since_unix_epoch,
            .frequency => .bpm,
            .temperature => .celcius,
        };
    }
};

pub const Unit = enum {
    meters,
    kilometers,
    miles,
    feet,
    ms,
    kph,
    mph,
    seconds_since_unix_epoch,
    seconds,
    bpm,
    celcius,
    fahrenheit,

    const Self = @This();

    pub fn toString(self: Self) []const u8 {
        return switch (self) {
            .meters => "m",
            .kilometers => "km",
            .miles => "mi",
            .feet => "ft",
            .ms => "m/s",
            .kph => "kph",
            .mph => "mph",
            .seconds_since_unix_epoch, .seconds => "s",
            .bpm => "bpm",
            .celcius => "°C",
            .fahrenheit => "°F",
        };
    }

    pub fn metric(self: Self) Metric {
        return switch (self) {
            .meters, .kilometers, .miles, .feet => .distance,
            .ms, .kph, .mph => .speed,
            .seconds => .time,
            .seconds_since_unix_epoch => .abs_time,
            .bpm => .frequency,
            .celcius, .fahrenheit => .temperature,
        };
    }
};

pub const System = enum { metric, imperial };

pub fn UnittedType(comptime T: type, comptime unit: Unit) type {
    return struct {
        value: T,

        const Self = @This();

        pub fn toStandard(self: *const Self) UnittedType(T, unit.metric().standard()) {
            return switch (unit) {
                .meters => self.*,
                .kilometers => .{self.value * 1000},
                .miles => .{self.value * 1609.34},
                .feet => .{self.value * 0.3048},
                .ms => self.*,
                .kph => .{self.value * 0.277778},
                .mph => .{self.value * 0.44704},
                .seconds_since_unix_epoch, .seconds => self.*,
                .bpm => self.*,
                .celcius => self.*,
                .fahrenheit => .{(self.value - 32.0) * (5.0 / 9.0)},
            };
        }

        pub fn toUnit(self: *const Self, to: Unit) !T {
            if (unit.metric() != to.metric()) {
                return error.InvalidUnit;
            }
            const standard = self.toStandard();
            return standardTo(T, standard.value, to);
        }

        pub fn printTime(self: *const Self, writer: anytype, comptime fmt: comptime []const u8) !void {
            if (comptime unit.metric() != .time) {
                @compileError("can't call printTime on non-time value");
            }

            var v = @floatToInt(usize, self.value);
            const hrs = v / (60 * 60);
            v -= hrs * 60 * 60;
            const mins = v / 60;
            v -= mins * 60;
            const secs = v;
            var buf: [16]u8 = undefined;
            const res = if (hrs == 0) try std.fmt.bufPrint(&buf, "{d:0>2}:{d:0>2}", .{ mins, secs }) else try std.fmt.bufPrint(&buf, "{}:{d:0>2}:{d:0>2}", .{ hrs, mins, secs });

            try writer.print(fmt, .{res});
        }

        /// Print to writer with fmt string (must include specifier for value and for unit)
        pub fn printUnit(self: *const Self, writer: anytype, comptime fmt: []const u8, to: Unit) !void {
            if (unit.metric() != to.metric()) {
                return error.InvalidUnit;
            }

            const standard = self.toStandard();
            const val = standardTo(T, standard.value, to);
            try writer.print(fmt, .{ val, to.toString() });
        }
    };
}

fn standardTo(comptime T: type, v: T, unit: Unit) T {
    return switch (unit) {
        .meters => v,
        .kilometers => v * 0.001,
        .miles => v * 0.000621371,
        .feet => v * 3.28084,
        .ms => v,
        .kph => v * 3.6,
        .mph => v * 2.23694,
        .seconds_since_unix_epoch, .seconds => v,
        .bpm => v,
        .celcius => v,
        .fahrenheit => v * (9.0 / 5.0) + 32.0,
    };
}

pub fn standardUnittedType(comptime T: type, comptime metric: Metric) type {
    return return switch (metric) {
        .distance => UnittedType(T, .meters),
        .speed => UnittedType(T, .ms),
        .abs_time => UnittedType(T, .seconds_since_unix_epoch),
        .time => UnittedType(T, .seconds),
        .frequency => UnittedType(T, .bpm),
        .temperature => UnittedType(T, .celcius),
    };
}

pub fn parseVal(comptime T: type, comptime metric: Metric, value: T) UnittedType(T, metric.standard()) {
    return switch (metric) {
        .distance => .{ .value = value / @as(T, 100) }, // cm -> meters
        .speed => .{
            .value = value / @as(T, 1000), // cm/s -> ms
        },
        .time => .{ .value = value / @as(T, 1000) }, // ms -> seconds
        .abs_time => .{ .value = value }, // abs time
        .frequency => .{ .value = value }, // bpm
        .temperature => .{ .value = value }, // celcius
    };
}

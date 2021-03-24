const std = @import("std");
const ui = @import("ui.zig");
const db = @import("db.zig");
const fit = @import("fit/fit.zig");
const units = @import("units.zig");
const zbox = @import("zbox");
const sqlite = @import("sqlite");
const clap = @import("clap");

usingnamespace @import("log_handler.zig");

const UserSettings = struct {
    distance_unit: units.Unit,
    speed_unit: units.Unit,
    temperature_unit: units.Unit,
    cache: *sqlite.Db,

    const Self = @This();

    fn save(self: *const Self) !void {
        const settings: [3]db.Setting = .{
            .{ .key = .distance_unit, .value = @enumToInt(self.distance_unit) },
            .{ .key = .speed_unit, .value = @enumToInt(self.speed_unit) },
            .{ .key = .temperature_unit, .value = @enumToInt(self.temperature_unit) },
        };
        try db.setSettings(self.cache, &settings);
    }
};

fn getUserSettings(cache: *sqlite.Db, allocator: *std.mem.Allocator) !UserSettings {
    var user_settings: UserSettings = undefined;
    user_settings.cache = cache;

    var settings = try db.getSettings(cache, allocator);
    defer allocator.free(settings);

    for (settings) |setting| {
        switch (setting.key) {
            .distance_unit => user_settings.distance_unit = try std.meta.intToEnum(units.Unit, setting.value),
            .speed_unit => user_settings.speed_unit = try std.meta.intToEnum(units.Unit, setting.value),
            .temperature_unit => user_settings.temperature_unit = try std.meta.intToEnum(units.Unit, setting.value),
            else => {},
        }
    }
    return user_settings;
}

fn import(allocator: *std.mem.Allocator, cache: *sqlite.Db, base_path: []const u8) !void {
    var last_index = base_path.len;
    if (base_path[last_index - 1] == '/') {
        last_index -= 1;
    }
    std.log.debug("got base path: {s}", .{base_path});
    var walker = try std.fs.walkPath(allocator, base_path[0..last_index]);
    defer walker.deinit();

    while (try walker.next()) |node| {
        var f = try std.fs.openFileAbsolute(node.path, .{});
        defer f.close();
        std.log.debug("got path: {s}", .{node.path});
        var reader = std.io.bufferedReader(f.reader()).reader();
        const file = try fit.Parser.parse_reader(allocator, reader);
        const activity = db.activityFromSession(node.path, &file.session);

        db.insertActivity(cache, &activity) catch |e| {
            switch (e) {
                error.AlreadyExists => {
                    try std.io.getStdOut().writer().print("Skipped {s}\n", .{node.path});
                    continue;
                },
                else => return e,
            }
        };

        try std.io.getStdOut().writer().print("Imported {s}\n", .{node.path});
    }
}

fn parseVal(comptime T: type, comptime metric: units.Metric, value: anytype) units.UnittedType(T, metric.standard()) {
    const v = @intToFloat(T, value);
    return units.parseVal(T, metric, v);
}

fn getDistancesBy(period: []const u8, allocator: *std.mem.Allocator, cache: *sqlite.Db, settings: *const UserSettings) !ui.BarGraph {
    var distances_by_month = try db.getDistanceByTimePeriod(cache, allocator, period);
    defer {
        for (distances_by_month) |dbm| {
            allocator.free(dbm.period);
        }
        allocator.free(distances_by_month);
    }
    var bar_graph = ui.BarGraph.init(allocator);
    for (distances_by_month) |dbm| {
        const dist = try parseVal(f32, .distance, dbm.distance).toUnit(settings.distance_unit);
        try bar_graph.add("{s}", .{dbm.period}, dist, "{d:.2}{s}", .{ dist, settings.distance_unit.toString() });
    }
    return bar_graph;
}

const ListView = struct {
    allocator: *std.mem.Allocator,
    settings: *const UserSettings,
    list: ui.List,
    rest: zbox.Buffer,
    names: [][]const u8,
    activities: []const db.Activity,

    const Self = @This();

    fn init(allocator: *std.mem.Allocator, settings: *const UserSettings, names: [][]const u8, activities: []const db.Activity) !Self {
        const size = try zbox.size();
        var list = try ui.List.init(allocator, names);
        var rest = try zbox.Buffer.init(allocator, size.height, 2 * size.width / 3);

        return Self{
            .allocator = allocator,
            .settings = settings,
            .list = list,
            .rest = rest,
            .names = names,
            .activities = activities,
        };
    }

    fn draw(self: *Self, output: *zbox.Buffer) !void {
        const size = try zbox.size();
        const list_width = size.width / 3;
        try self.list.resize(size.height, list_width);
        try self.list.draw();
        output.blit(self.list.buf, 0, 1);

        self.rest.clear();
        try self.rest.resize(size.height - 2, list_width * 2 - 3);
        if (self.activities.len != 0) {
            const activity = &self.activities[self.list.selected];
            var cursor = self.rest.wrappedCursorAt(0, 0);
            var writer = cursor.writer();
            try writer.print("{s}\n", .{self.names[self.list.selected]});
            try parseVal(f32, .distance, activity.total_distance).printUnit(writer, "Distance: {d:.2}{s}\n", self.settings.distance_unit);
            try parseVal(f32, .time, activity.total_timer_time).printTime(writer, "Moving time: {s}\n");
            try parseVal(f32, .time, activity.total_elapsed_time).printTime(writer, "Total time: {s}\n");
            try parseVal(f32, .speed, activity.avg_speed).printUnit(writer, "Avg speed: {d:.2}{s}\n", self.settings.speed_unit);
            if (activity.avg_heart_rate) |val| {
                try parseVal(f16, .frequency, val).printUnit(writer, "Avg heart rate: {d:.0}{s}\n", .bpm);
            }
            if (activity.min_heart_rate) |val| {
                try parseVal(f16, .frequency, val).printUnit(writer, "Min heart rate: {d:.0}{s}\n", .bpm);
            }
            if (activity.max_heart_rate) |val| {
                try parseVal(f16, .frequency, val).printUnit(writer, "Max heart rate: {d:.0}{s}\n", .bpm);
            }
            if (activity.avg_temperature) |val| {
                try parseVal(f16, .temperature, val).printUnit(writer, "Avg temperature: {d:.0}{s}\n", self.settings.temperature_unit);
            }
            output.blit(self.rest, 1, @intCast(isize, list_width + 2));
        }
        try ui.drawBoxRect(output, 0, list_width + 1, size.height, list_width * 2 - 1);
    }

    fn handleInput(self: *Self, e: zbox.Event) void {
        self.list.handleInput(e);
    }

    fn deinit(self: *Self) void {
        self.rest.deinit();
        self.list.deinit();
    }
};

const SettingsUI = struct {
    radios: [3]ui.Radio,
    selected_radio: usize = 0,
    settings: *UserSettings,

    const Self = @This();

    const DISTANCE_STRINGS: []const []const u8 = &.{ "meters", "kilometers", "miles" };
    const DISTANCE_UNITS: []const units.Unit = &.{ .meters, .kilometers, .miles };
    const SPEED_STRINGS: []const []const u8 = &.{ "ms", "kph", "mph" };
    const SPEED_UNITS: []const units.Unit = &.{ .ms, .kph, .mph };
    const TEMP_STRINGS: []const []const u8 = &.{ "celcius", "fahrenheit" };
    const TEMP_UNITS: []const units.Unit = &.{ .celcius, .fahrenheit };

    fn init(settings: *UserSettings) Self {
        var self = Self{
            .radios = .{
                ui.Radio.init("Distance:", DISTANCE_STRINGS, std.mem.indexOf(units.Unit, DISTANCE_UNITS, &.{settings.distance_unit}).?),
                ui.Radio.init("Speed:", SPEED_STRINGS, std.mem.indexOf(units.Unit, SPEED_UNITS, &.{settings.speed_unit}).?),
                ui.Radio.init("Temperature:", TEMP_STRINGS, std.mem.indexOf(units.Unit, TEMP_UNITS, &.{settings.temperature_unit}).?),
            },
            .settings = settings,
        };
        self.radios[0].focus(true);
        return self;
    }

    fn draw(self: *const Self, output: *zbox.Buffer) !void {
        try ui.drawBoxRect(output, 0, 1, output.height, output.width - 1);

        var cursor = output.cursorAt(1, 2);
        _ = try cursor.writer().write("Settings");

        var i: usize = 0;
        while (i < self.radios.len) : (i += 1) {
            try self.radios[i].draw(output, i + 2, 2);
        }
    }

    pub fn handleInput(self: *Self, e: zbox.Event) !void {
        switch (e) {
            .up => {
                self.radios[self.selected_radio].focus(false);
                if (self.selected_radio == 0) {
                    self.selected_radio = self.radios.len - 1;
                } else {
                    self.selected_radio -= 1;
                }
                return;
            },
            .down => {
                self.radios[self.selected_radio].focus(false);
                if (self.selected_radio == self.radios.len - 1) {
                    self.selected_radio = 0;
                } else {
                    self.selected_radio += 1;
                }
                return;
            },
            else => {},
        }
        self.radios[self.selected_radio].focus(true);
        if (self.radios[self.selected_radio].handleInput(e)) {
            self.settings.distance_unit = DISTANCE_UNITS[self.radios[0].selected];
            self.settings.speed_unit = SPEED_UNITS[self.radios[1].selected];
            self.settings.temperature_unit = TEMP_UNITS[self.radios[2].selected];
            try self.settings.save();
        }
    }
};

const HELP_TEXT: [6][]const u8 = .{
    "Welcome to zolter, a program to track your bike rides",
    "",
    "Views (accessed by given function key):",
    "F1: This help screen",
    "F2: Summary of all rides (bar charts of distance)",
    "F3: Individual files",
};

fn getLinesMaxLen(lines: []const []const u8) usize {
    var max: usize = 0;
    for (lines) |l| {
        if (l.len > max) max = l.len;
    }
    return max;
}

const View = enum {
    help,
    summary,
    activities_list,
    settings,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    var cache = try db.openDb();

    const params = comptime [_]clap.Param(clap.Help){
        clap.parseParam("-h, --help             Display this help and exit.              ") catch unreachable,
        clap.parseParam("-i <PATH>              Imports fit files from PATH") catch unreachable,
    };

    var diag: clap.Diagnostic = undefined;
    var args = clap.parse(clap.Help, &params, &gpa.allocator, &diag) catch |err| {
        // Report useful error and exit
        diag.report(std.io.getStdErr().writer(), err) catch {};
        return err;
    };
    defer args.deinit();

    if (args.option("-i")) |path| {
        try import(&gpa.allocator, &cache, path);
        return;
    }

    var names = std.ArrayList([]const u8).init(&gpa.allocator);
    defer names.deinit();

    var activities = try db.getActivities(&cache, &gpa.allocator);
    defer {
        for (activities) |a| {
            gpa.allocator.free(a.name);
        }
        gpa.allocator.free(activities);
    }

    for (activities) |a| {
        try names.append(a.name);
    }

    try zbox.init(&gpa.allocator);
    defer zbox.deinit();

    try zbox.ignoreSignalInput();
    try zbox.cursorHide();
    defer zbox.cursorShow() catch {};

    var settings = try getUserSettings(&cache, &gpa.allocator);
    std.log.debug("{}", .{settings});

    var size = try zbox.size();
    std.debug.print("size {any} {}", .{ size, size.width / 3 });

    var output = try zbox.Buffer.init(&gpa.allocator, size.height, size.width);
    defer output.deinit();

    var list_view = try ListView.init(&gpa.allocator, &settings, names.items, activities);
    defer list_view.deinit();

    var distances_by_month = try getDistancesBy("%Y-%m", &gpa.allocator, &cache, &settings);
    defer distances_by_month.deinit();
    var distances_by_year = try getDistancesBy("%Y", &gpa.allocator, &cache, &settings);
    defer distances_by_year.deinit();

    var left = try zbox.Buffer.init(&gpa.allocator, size.height, size.width / 2);
    defer left.deinit();
    var right = try zbox.Buffer.init(&gpa.allocator, size.height, size.width / 2);
    defer right.deinit();

    var settings_view = SettingsUI.init(&settings);

    var view = View.help;

    while (try zbox.nextEvent()) |e| {
        output.clear();

        size = try zbox.size();

        try output.resize(size.height, size.width);

        switch (view) {
            .help => {
                const max_line_width = getLinesMaxLen(HELP_TEXT[0..]);
                const left_pos = size.width / 2 - max_line_width / 2;
                const y_center = size.height / 2 - HELP_TEXT.len / 2;
                var cursor = output.cursorAt(y_center, 0);
                for (HELP_TEXT) |line| {
                    cursor.col_num = left_pos;
                    var tmp: [1024]u8 = undefined;
                    try cursor.writer().print("{s}\n", .{line});
                }

                try ui.drawBoxRect(&output, 0, 1, output.height, output.width - 1);
            },
            .activities_list => try list_view.draw(&output),
            .summary => {
                const width = size.width / 2;
                try left.resize(size.height, width);
                try right.resize(size.height, width);
                try distances_by_month.draw(&left, size.height, width);
                try distances_by_year.draw(&right, size.height, width);

                output.blit(left, 0, 0);
                output.blit(right, 0, @intCast(isize, width));
            },
            .settings => try settings_view.draw(&output),
        }

        try zbox.push(output);

        switch (e) {
            .escape => return,
            .other => |s| {
                if (std.mem.eql(u8, "\x1bOP", s)) {
                    view = .help;
                    continue;
                } else if (std.mem.eql(u8, "\x1bOQ", s)) {
                    view = .summary;
                    continue;
                } else if (std.mem.eql(u8, "\x1bOR", s)) {
                    view = .activities_list;
                    continue;
                } else if (std.mem.eql(u8, "\x1bOS", s)) {
                    view = .settings;
                    continue;
                }
            },
            else => {},
        }

        switch (view) {
            .activities_list => list_view.handleInput(e),
            .settings => _ = try settings_view.handleInput(e),
            else => {},
        }
    }
}

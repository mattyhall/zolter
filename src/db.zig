const std = @import("std");
const sqlite = @import("sqlite");
const units = @import("units.zig");
const fit = @import("fit/fit.zig");

const logger = std.log.scoped(.db);

const DB_VERSION = 1;

const SettingKey = enum {
    db_version,
    distance_unit,
    speed_unit,
    temperature_unit,
};

const Setting = struct { key: SettingKey, value: usize };

const SETTING_DEFAULTS: [4]Setting = .{
    .{ .key = .db_version, .value = DB_VERSION },
    .{ .key = .distance_unit, .value = @enumToInt(units.Unit.kilometers) },
    .{ .key = .speed_unit, .value = @enumToInt(units.Unit.kph) },
    .{ .key = .temperature_unit, .value = @enumToInt(units.Unit.celcius) },
};

const TABLES: [2][]const u8 = .{
    \\CREATE TABLE IF NOT EXISTS activity (
    \\  name               TEXT NOT NULL,
    \\  start_time         INTEGER NOT NULL,
    \\  total_elapsed_time INTEGER NOT NULL,
    \\  total_timer_time   INTEGER NOT NULL,
    \\  avg_speed          INTEGER NOT NULL,
    \\  max_speed          INTEGER NOT NULL,
    \\  total_distance     INTEGER NOT NULL,
    \\  avg_cadence        INTEGER,
    \\  max_cadence        INTEGER,
    \\  min_heart_rate     INTEGER,
    \\  max_heart_rate     INTEGER,
    \\  avg_heart_rate     INTEGER,
    \\  min_altitude       INTEGER,
    \\  max_altitude       INTEGER,
    \\  avg_altitude       INTEGER,
    \\  max_neg_grade      INTEGER,
    \\  avg_grade          INTEGER,
    \\  max_pos_grade      INTEGER,
    \\  total_calories     INTEGER,
    \\  avg_temperature    INTEGER,
    \\  max_temperature    INTEGER,
    \\  total_ascent       INTEGER,
    \\  total_descent      INTEGER,
    \\
    \\  PRIMARY KEY(name, start_time)
    \\);
    ,
    \\CREATE TABLE IF NOT EXISTS settings (
    \\  key INTEGER NOT NULL,
    \\  value INTEGER NOT NULL);
};

const SET_SETTING = "INSERT INTO settings (key, value) VALUES (?, ?);";
const GET_SETTING = "SELECT value FROM settings WHERE key=?;";
const GET_SETTINGS = "SELECT key, value FROM settings;";

const INSERT_ACTIVITY =
    \\INSERT INTO activity (name, start_time, total_elapsed_time, total_timer_time, avg_speed, max_speed, 
    \\  total_distance, avg_cadence, max_cadence, min_heart_rate, max_heart_rate, avg_heart_rate, min_altitude, max_altitude,
    \\  avg_altitude, max_neg_grade, avg_grade, max_pos_grade, total_calories, avg_temperature, max_temperature,
    \\  total_ascent, total_descent) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
;

const GET_ACTIVITIES =
    \\SELECT name, start_time, total_elapsed_time, total_timer_time, avg_speed, max_speed,
    \\  total_distance, avg_cadence, max_cadence, min_heart_rate, max_heart_rate, avg_heart_rate, min_altitude, max_altitude,
    \\  avg_altitude, max_neg_grade, avg_grade, max_pos_grade, total_calories, avg_temperature, max_temperature,
    \\  total_ascent, total_descent
    \\FROM activity ORDER BY start_time DESC;
;

const EXISTS_ACTIVITY = "SELECT start_time FROM activity WHERE (name = ? OR total_distance = ?) AND start_time = ? LIMIT 1;";

const GROUPED_BY_TIME_ACTIVITIES =
    \\SELECT strftime(?, datetime(start_time, 'unixepoch')), SUM(total_distance) 
    \\FROM activity
    \\GROUP BY strftime(?, datetime(start_time, 'unixepoch'))
    \\ORDER BY start_time DESC
;

fn create(db: *sqlite.Db) !void {
    @setEvalBranchQuota(5000);

    logger.debug("creating tables", .{});
    inline for (TABLES) |tbl| {
        try db.exec(tbl, .{});
    }

    var set_stmt = try db.prepare(SET_SETTING);
    defer set_stmt.deinit();

    logger.debug("inserting initial settings", .{});
    inline for (SETTING_DEFAULTS) |default| {
        set_stmt.reset();
        try set_stmt.exec(.{ @enumToInt(default.key), default.value });
    }
}

fn createOrMigrate(db: *sqlite.Db) !void {
    const db_version = blk: {
        const row = db.one(usize, GET_SETTING, .{}, .{@enumToInt(SettingKey.db_version)}) catch |_| {
            break :blk null;
        };
        if (row) |r| {
            break :blk r;
        }
        break :blk null;
    };
    if (db_version) |ver| {
        logger.info("db version: {}", .{ver});
        // if (ver != DB_VERSION)
        //     try migrate(db);
    } else {
        logger.info("need to create db", .{});
        try create(db);
    }
}

pub fn openDb() !sqlite.Db {
    const DB_NAME = "/cache.db";
    var buf: [std.fs.MAX_PATH_BYTES]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buf);
    const data_dir = try std.fs.getAppDataDir(&fba.allocator, "zolter");
    std.fs.makeDirAbsolute(data_dir) catch |e| switch (e) {
        error.PathAlreadyExists => {},
        else => return e,
    };
    const db_path = try fba.allocator.alloc(u8, data_dir.len + DB_NAME.len + 1);
    std.mem.copy(u8, db_path, data_dir);
    std.mem.copy(u8, db_path[data_dir.len..], DB_NAME);
    db_path[db_path.len - 1] = 0;
    const zt_db_path = db_path[0 .. db_path.len - 1 :0];

    var db: sqlite.Db = undefined;
    try db.init(.{
        .mode = sqlite.Db.Mode{ .File = zt_db_path },
        .open_flags = .{
            .write = true,
            .create = true,
        },
        .threading_mode = .MultiThread,
    });

    try createOrMigrate(&db);

    return db;
}

pub const Activity = struct {
    name: []const u8,
    start_time: u32 = 0,
    total_elapsed_time: u32 = 0,
    total_timer_time: u32 = 0,
    avg_speed: u16 = 0,
    max_speed: u16 = 0,
    total_distance: u32 = 0,
    avg_cadence: ?u8 = null,
    max_cadence: ?u8 = null,
    min_heart_rate: ?u8 = null,
    max_heart_rate: ?u8 = null,
    avg_heart_rate: ?u8 = null,
    min_altitude: ?u16 = null,
    max_altitude: ?u16 = null,
    avg_altitude: ?u32 = null,
    max_neg_grade: ?i16 = null,
    avg_grade: ?i16 = null,
    max_pos_grade: ?i16 = null,
    total_calories: ?u16 = null,
    avg_temperature: ?i8 = null,
    max_temperature: ?i8 = null,
    total_ascent: ?u16 = null,
    total_descent: ?u16 = null,
};

// This should be in the struct above but it causes the Zig compiler to crash :'(
pub fn activityFromSession(path: []const u8, session: *const fit.Session) Activity {
    const filename = std.fs.path.basename(path);
    return .{
        .name = filename,
        .start_time = session.start_time + fit.GARMIN_EPOCH,
        .total_elapsed_time = session.total_elapsed_time,
        .total_timer_time = session.total_timer_time,
        .avg_speed = session.avg_speed,
        .max_speed = session.max_speed,
        .total_distance = session.total_distance,
        .avg_cadence = session.avg_cadence,
        .max_cadence = session.max_cadence,
        .min_heart_rate = session.min_heart_rate,
        .max_heart_rate = session.max_heart_rate,
        .avg_heart_rate = session.avg_heart_rate,
        .min_altitude = session.min_altitude,
        .max_altitude = session.max_altitude,
        .avg_altitude = session.avg_altitude,
        .max_neg_grade = session.max_neg_grade,
        .avg_grade = session.avg_grade,
        .max_pos_grade = session.max_pos_grade,
        .total_calories = session.total_calories,
        .avg_temperature = session.avg_temperature,
        .max_temperature = session.max_temperature,
        .total_ascent = session.total_ascent,
        .total_descent = session.total_descent,
    };
}

/// Searches the db for a matching activity based on (name, start_time) or
/// (start_time, distance) in case you renamed it.
pub fn activityExists(db: *sqlite.Db, activity: *const Activity) !bool {
    @setEvalBranchQuota(5000);

    var stmt = try db.prepare(EXISTS_ACTIVITY);
    defer stmt.deinit();
    const row = try stmt.one(usize, .{}, .{ activity.name, activity.total_distance, activity.start_time });
    if (row) |a| {
        return true;
    }
    return false;
}

pub fn insertActivity(db: *sqlite.Db, activity: *const Activity) !void {
    @setEvalBranchQuota(5000);

    const exists = try activityExists(db, activity);
    if (exists) return error.AlreadyExists;

    logger.info("inserting activity {s}", .{activity.name});
    var stmt = try db.prepare(INSERT_ACTIVITY);
    defer stmt.deinit();
    try stmt.exec(activity.*);
}

pub fn getActivities(db: *sqlite.Db, allocator: *std.mem.Allocator) ![]Activity {
    @setEvalBranchQuota(5000);

    var stmt = try db.prepare(GET_ACTIVITIES);
    defer stmt.deinit();

    return stmt.all(Activity, allocator, .{}, .{});
}

pub const PeriodAndDistance = struct {
    period: []const u8,
    distance: usize,
};

pub fn getDistanceByTimePeriod(db: *sqlite.Db, allocator: *std.mem.Allocator, period: []const u8) ![]PeriodAndDistance {
    @setEvalBranchQuota(5000);

    var stmt = try db.prepare(GROUPED_BY_TIME_ACTIVITIES);
    defer stmt.deinit();

    return stmt.all(PeriodAndDistance, allocator, .{}, .{ period, period });
}

pub fn getSettings(db: *sqlite.Db, allocator: *std.mem.Allocator) ![]Setting {
    @setEvalBranchQuota(5000);

    const SettingWeak = struct { key: usize, value: usize };

    var settings = std.ArrayList(Setting).init(allocator);

    var stmt = try db.prepare(GET_SETTINGS);
    defer stmt.deinit();

    var iter = try stmt.iterator(SettingWeak, .{});
    while (try iter.next(.{})) |setting| {
        const key = try std.meta.intToEnum(SettingKey, setting.key);
        try settings.append(.{
            .key = key,
            .value = setting.value,
        });
    }

    return settings.toOwnedSlice();
}

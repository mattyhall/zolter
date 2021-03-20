const std = @import("std");
const sqlite = @import("sqlite");
const units = @import("units.zig");

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
    \\  id                 INTEGER PRIMARY KEY NOT NULL,
    \\  name               TEXT NOT NULL,
    \\  start_time         INTEGER NOT NULL,
    \\  total_elapsed_time INTEGER NOT NULL,
    \\  total_timer_time   INTEGER NOT NULL,
    \\  avg_speed          INTEGER NOT NULL,
    \\  max_speed          INTEGER NOT NULL,
    \\  total_distance     INTEGER NOT NULL,
    \\  avg_cadence        INTEGER,
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
    \\  total_descent      INTEGER);
    ,
    \\CREATE TABLE IF NOT EXISTS settings (
    \\  key INTEGER NOT NULL,
    \\  value INTEGER NOT NULL);
};

const SET_SETTING = "INSERT INTO settings (key, value) VALUES (?, ?);";
const GET_SETTING = "SELECT value FROM settings WHERE key=?;";

const ACTIVITY_INSERT =
    \\INSERT INTO activity (name, start_time, total_elapsed_time, total_timer_time, avg_speed, max_speed, 
    \\  total_distance, avg_cadence, min_heart_rate, max_heart_rate, avg_heart_rate, min_altitude, max_altitude,
    \\  avg_altitude, max_neg_grade, avg_grade, max_pos_grade, total_calories, avg_temperature, max_temperature,
    \\  total_ascent, total_descent) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
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

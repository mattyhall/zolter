fn genericToString(comptime T: anytype, comptime V: anytype, i: V) []const u8 {
    const info = @typeInfo(T);
    switch (info) {
        .Struct => |s| {
            inline for (s.decls) |decl| {
                switch (decl.data) {
                    .Var => {},
                    else => continue,
                }
                const v: V = @field(T, decl.name);
                if (i == v) {
                    return decl.name;
                }
            }
        },
        else => @compileError("can only be used on structs"),
    }
    return "unknown";
}

pub const File = struct {
    pub const device = 1;
    pub const settings = 2;
    pub const sport = 3;
    pub const activity = 4;
    pub const workout = 5;
    pub const course = 6;
    pub const schedules = 7;
    pub const weight = 9;
    pub const totals = 10;
    pub const goals = 11;
    pub const blood_pressure = 14;
    pub const monitoring_a = 15;
    pub const activity_summary = 20;
    pub const monitoring_daily = 28;
    pub const monitoring_b = 32;
    pub const segment = 34;
    pub const segment_list = 35;
    pub const exd_configuration = 40;
    pub const mfg_range_min = 7;
    pub const mfg_range_max = 0;
};

pub const MesgNum = struct {
    pub const file_id: u16 = 0;
    pub const capabilities: u16 = 1;
    pub const device_settings: u16 = 2;
    pub const user_profile: u16 = 3;
    pub const hrm_profile: u16 = 4;
    pub const sdm_profile: u16 = 5;
    pub const bike_profile: u16 = 6;
    pub const zones_target: u16 = 7;
    pub const hr_zone: u16 = 8;
    pub const power_zone: u16 = 9;
    pub const met_zone: u16 = 10;
    pub const sport: u16 = 12;
    pub const goal: u16 = 15;
    pub const session: u16 = 18;
    pub const lap: u16 = 19;
    pub const record: u16 = 20;
    pub const event: u16 = 21;
    pub const device_info: u16 = 23;
    pub const workout: u16 = 26;
    pub const workout_step: u16 = 27;
    pub const schedule: u16 = 28;
    pub const weight_scale: u16 = 30;
    pub const course: u16 = 31;
    pub const course_point: u16 = 32;
    pub const totals: u16 = 33;
    pub const activity: u16 = 34;
    pub const software: u16 = 35;
    pub const file_capabilities: u16 = 37;
    pub const mesg_capabilities: u16 = 38;
    pub const field_capabilities: u16 = 39;
    pub const file_creator: u16 = 49;
    pub const blood_pressure: u16 = 51;
    pub const speed_zone: u16 = 53;
    pub const monitoring: u16 = 55;
    pub const training_file: u16 = 72;
    pub const hrv: u16 = 78;
    pub const ant_rx: u16 = 80;
    pub const ant_tx: u16 = 81;
    pub const ant_channel_id: u16 = 82;
    pub const length: u16 = 101;
    pub const monitoring_info: u16 = 103;
    pub const pad: u16 = 105;
    pub const slave_device: u16 = 106;
    pub const connectivity: u16 = 127;
    pub const weather_conditions: u16 = 128;
    pub const weather_alert: u16 = 129;
    pub const cadence_zone: u16 = 131;
    pub const hr: u16 = 132;
    pub const segment_lap: u16 = 142;
    pub const memo_glob: u16 = 145;
    pub const segment_id: u16 = 148;
    pub const segment_leaderboard_entry: u16 = 149;
    pub const segment_point: u16 = 150;
    pub const segment_file: u16 = 151;
    pub const workout_session: u16 = 158;
    pub const watchface_settings: u16 = 159;
    pub const gps_metadata: u16 = 160;
    pub const camera_event: u16 = 161;
    pub const timestamp_correlation: u16 = 162;
    pub const gyroscope_data: u16 = 164;
    pub const accelerometer_data: u16 = 165;
    pub const three_d_sensor_calibration: u16 = 167;
    pub const video_frame: u16 = 169;
    pub const obdii_data: u16 = 174;
    pub const nmea_sentence: u16 = 177;
    pub const aviation_attitude: u16 = 178;
    pub const video: u16 = 184;
    pub const video_title: u16 = 185;
    pub const video_description: u16 = 186;
    pub const video_clip: u16 = 187;
    pub const ohr_settings: u16 = 188;
    pub const exd_screen_configuration: u16 = 200;
    pub const exd_data_field_configuration: u16 = 201;
    pub const exd_data_concept_configuration: u16 = 202;
    pub const field_description: u16 = 206;
    pub const developer_data_id: u16 = 207;
    pub const magnetometer_data: u16 = 208;
    pub const barometer_data: u16 = 209;
    pub const one_d_sensor_calibration: u16 = 210;
    pub const set: u16 = 225;
    pub const stress_level: u16 = 227;
    pub const dive_settings: u16 = 258;
    pub const dive_gas: u16 = 259;
    pub const dive_alarm: u16 = 262;
    pub const exercise_title: u16 = 264;
    pub const dive_summary: u16 = 268;
    pub const jump: u16 = 285;
    pub const climb_pro: u16 = 317;
    pub const mfg_range_min: u16 = 0;
    pub const mfg_range_max: u16 = 0;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const Checksum = struct {
    pub const clear: u8 = 0;
    pub const ok: u8 = 1;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const FileFlags = struct {
    pub const read: u8 = 2;
    pub const write: u8 = 4;
    pub const erase: u8 = 8;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const MesgCount = struct {
    pub const num_per_file = 0;
    pub const max_per_file = 1;
    pub const max_per_file_type = 2;
};

pub const DateTime = struct {
    pub const min: u32 = 10000000;

    const Self = @This();
    pub fn toString(i: u32) []const u8 {
        return genericToString(Self, u32, i);
    }
};

pub const LocalDateTime = struct {
    pub const min: u32 = 10000000;

    const Self = @This();
    pub fn toString(i: u32) []const u8 {
        return genericToString(Self, u32, i);
    }
};

pub const MessageIndex = struct {
    pub const selected: u16 = 8000;
    pub const reserved: u16 = 7000;
    pub const mask: u16 = 0;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const DeviceIndex = struct {
    pub const creator: u8 = 0;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const Gender = struct {
    pub const female = 0;
    pub const male = 1;
};

pub const Language = struct {
    pub const english = 0;
    pub const french = 1;
    pub const italian = 2;
    pub const german = 3;
    pub const spanish = 4;
    pub const croatian = 5;
    pub const czech = 6;
    pub const danish = 7;
    pub const dutch = 8;
    pub const finnish = 9;
    pub const greek = 10;
    pub const hungarian = 11;
    pub const norwegian = 12;
    pub const polish = 13;
    pub const portuguese = 14;
    pub const slovakian = 15;
    pub const slovenian = 16;
    pub const swedish = 17;
    pub const russian = 18;
    pub const turkish = 19;
    pub const latvian = 20;
    pub const ukrainian = 21;
    pub const arabic = 22;
    pub const farsi = 23;
    pub const bulgarian = 24;
    pub const romanian = 25;
    pub const chinese = 26;
    pub const japanese = 27;
    pub const korean = 28;
    pub const taiwanese = 29;
    pub const thai = 30;
    pub const hebrew = 31;
    pub const brazilian_portuguese = 32;
    pub const indonesian = 33;
    pub const malaysian = 34;
    pub const vietnamese = 35;
    pub const burmese = 36;
    pub const mongolian = 37;
    pub const custom = 254;
};

pub const LanguageBits0 = struct {
    pub const english: u8 = 1;
    pub const french: u8 = 2;
    pub const italian: u8 = 4;
    pub const german: u8 = 8;
    pub const spanish: u8 = 10;
    pub const croatian: u8 = 20;
    pub const czech: u8 = 40;
    pub const danish: u8 = 80;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const LanguageBits1 = struct {
    pub const dutch: u8 = 1001;
    pub const finnish: u8 = 1002;
    pub const greek: u8 = 1004;
    pub const hungarian: u8 = 1008;
    pub const norwegian: u8 = 1010;
    pub const polish: u8 = 1020;
    pub const portuguese: u8 = 1040;
    pub const slovakian: u8 = 1080;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const LanguageBits2 = struct {
    pub const slovenian: u8 = 2001;
    pub const swedish: u8 = 2002;
    pub const russian: u8 = 2004;
    pub const turkish: u8 = 2008;
    pub const latvian: u8 = 2010;
    pub const ukrainian: u8 = 2020;
    pub const arabic: u8 = 2040;
    pub const farsi: u8 = 2080;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const LanguageBits3 = struct {
    pub const bulgarian: u8 = 3001;
    pub const romanian: u8 = 3002;
    pub const chinese: u8 = 3004;
    pub const japanese: u8 = 3008;
    pub const korean: u8 = 3010;
    pub const taiwanese: u8 = 3020;
    pub const thai: u8 = 3040;
    pub const hebrew: u8 = 3080;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const LanguageBits4 = struct {
    pub const brazilian_portuguese: u8 = 4001;
    pub const indonesian: u8 = 4002;
    pub const malaysian: u8 = 4004;
    pub const vietnamese: u8 = 4008;
    pub const burmese: u8 = 4010;
    pub const mongolian: u8 = 4020;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const TimeZone = struct {
    pub const almaty = 0;
    pub const bangkok = 1;
    pub const bombay = 2;
    pub const brasilia = 3;
    pub const cairo = 4;
    pub const cape_verde_is = 5;
    pub const darwin = 6;
    pub const eniwetok = 7;
    pub const fiji = 8;
    pub const hong_kong = 9;
    pub const islamabad = 10;
    pub const kabul = 11;
    pub const magadan = 12;
    pub const mid_atlantic = 13;
    pub const moscow = 14;
    pub const muscat = 15;
    pub const newfoundland = 16;
    pub const samoa = 17;
    pub const sydney = 18;
    pub const tehran = 19;
    pub const tokyo = 20;
    pub const us_alaska = 21;
    pub const us_atlantic = 22;
    pub const us_central = 23;
    pub const us_eastern = 24;
    pub const us_hawaii = 25;
    pub const us_mountain = 26;
    pub const us_pacific = 27;
    pub const other = 28;
    pub const auckland = 29;
    pub const kathmandu = 30;
    pub const europe_western_wet = 31;
    pub const europe_central_cet = 32;
    pub const europe_eastern_eet = 33;
    pub const jakarta = 34;
    pub const perth = 35;
    pub const adelaide = 36;
    pub const brisbane = 37;
    pub const tasmania = 38;
    pub const iceland = 39;
    pub const amsterdam = 40;
    pub const athens = 41;
    pub const barcelona = 42;
    pub const berlin = 43;
    pub const brussels = 44;
    pub const budapest = 45;
    pub const copenhagen = 46;
    pub const dublin = 47;
    pub const helsinki = 48;
    pub const lisbon = 49;
    pub const london = 50;
    pub const madrid = 51;
    pub const munich = 52;
    pub const oslo = 53;
    pub const paris = 54;
    pub const prague = 55;
    pub const reykjavik = 56;
    pub const rome = 57;
    pub const stockholm = 58;
    pub const vienna = 59;
    pub const warsaw = 60;
    pub const zurich = 61;
    pub const quebec = 62;
    pub const ontario = 63;
    pub const manitoba = 64;
    pub const saskatchewan = 65;
    pub const alberta = 66;
    pub const british_columbia = 67;
    pub const boise = 68;
    pub const boston = 69;
    pub const chicago = 70;
    pub const dallas = 71;
    pub const denver = 72;
    pub const kansas_city = 73;
    pub const las_vegas = 74;
    pub const los_angeles = 75;
    pub const miami = 76;
    pub const minneapolis = 77;
    pub const new_york = 78;
    pub const new_orleans = 79;
    pub const phoenix = 80;
    pub const santa_fe = 81;
    pub const seattle = 82;
    pub const washington_dc = 83;
    pub const us_arizona = 84;
    pub const chita = 85;
    pub const ekaterinburg = 86;
    pub const irkutsk = 87;
    pub const kaliningrad = 88;
    pub const krasnoyarsk = 89;
    pub const novosibirsk = 90;
    pub const petropavlovsk_kamchatskiy = 91;
    pub const samara = 92;
    pub const vladivostok = 93;
    pub const mexico_central = 94;
    pub const mexico_mountain = 95;
    pub const mexico_pacific = 96;
    pub const cape_town = 97;
    pub const winkhoek = 98;
    pub const lagos = 99;
    pub const riyahd = 100;
    pub const venezuela = 101;
    pub const australia_lh = 102;
    pub const santiago = 103;
    pub const manual = 253;
    pub const automatic = 254;
};

pub const DisplayMeasure = struct {
    pub const metric = 0;
    pub const statute = 1;
    pub const nautical = 2;
};

pub const DisplayHeart = struct {
    pub const bpm = 0;
    pub const max = 1;
    pub const reserve = 2;
};

pub const DisplayPower = struct {
    pub const watts = 0;
    pub const percent_ftp = 1;
};

pub const DisplayPosition = struct {
    pub const degree = 0;
    pub const degree_minute = 1;
    pub const degree_minute_second = 2;
    pub const austrian_grid = 3;
    pub const british_grid = 4;
    pub const dutch_grid = 5;
    pub const hungarian_grid = 6;
    pub const finnish_grid = 7;
    pub const german_grid = 8;
    pub const icelandic_grid = 9;
    pub const indonesian_equatorial = 10;
    pub const indonesian_irian = 11;
    pub const indonesian_southern = 12;
    pub const india_zone_0 = 13;
    pub const india_zone_ia = 14;
    pub const india_zone_ib = 15;
    pub const india_zone_iia = 16;
    pub const india_zone_iib = 17;
    pub const india_zone_iiia = 18;
    pub const india_zone_iiib = 19;
    pub const india_zone_iva = 20;
    pub const india_zone_ivb = 21;
    pub const irish_transverse = 22;
    pub const irish_grid = 23;
    pub const loran = 24;
    pub const maidenhead_grid = 25;
    pub const mgrs_grid = 26;
    pub const new_zealand_grid = 27;
    pub const new_zealand_transverse = 28;
    pub const qatar_grid = 29;
    pub const modified_swedish_grid = 30;
    pub const swedish_grid = 31;
    pub const south_african_grid = 32;
    pub const swiss_grid = 33;
    pub const taiwan_grid = 34;
    pub const united_states_grid = 35;
    pub const utm_ups_grid = 36;
    pub const west_malayan = 37;
    pub const borneo_rso = 38;
    pub const estonian_grid = 39;
    pub const latvian_grid = 40;
    pub const swedish_ref_99_grid = 41;
};

pub const Switch = struct {
    pub const off = 0;
    pub const on = 1;
    pub const auto = 2;
};

pub const Sport = struct {
    pub const generic = 0;
    pub const running = 1;
    pub const cycling = 2;
    pub const transition = 3;
    pub const fitness_equipment = 4;
    pub const swimming = 5;
    pub const basketball = 6;
    pub const soccer = 7;
    pub const tennis = 8;
    pub const american_football = 9;
    pub const training = 10;
    pub const walking = 11;
    pub const cross_country_skiing = 12;
    pub const alpine_skiing = 13;
    pub const snowboarding = 14;
    pub const rowing = 15;
    pub const mountaineering = 16;
    pub const hiking = 17;
    pub const multisport = 18;
    pub const paddling = 19;
    pub const flying = 20;
    pub const e_biking = 21;
    pub const motorcycling = 22;
    pub const boating = 23;
    pub const driving = 24;
    pub const golf = 25;
    pub const hang_gliding = 26;
    pub const horseback_riding = 27;
    pub const hunting = 28;
    pub const fishing = 29;
    pub const inline_skating = 30;
    pub const rock_climbing = 31;
    pub const sailing = 32;
    pub const ice_skating = 33;
    pub const sky_diving = 34;
    pub const snowshoeing = 35;
    pub const snowmobiling = 36;
    pub const stand_up_paddleboarding = 37;
    pub const surfing = 38;
    pub const wakeboarding = 39;
    pub const water_skiing = 40;
    pub const kayaking = 41;
    pub const rafting = 42;
    pub const windsurfing = 43;
    pub const kitesurfing = 44;
    pub const tactical = 45;
    pub const jumpmaster = 46;
    pub const boxing = 47;
    pub const floor_climbing = 48;
    pub const diving = 53;
    pub const all = 254;
};

pub const SportBits0 = struct {
    pub const generic: u8 = 1;
    pub const running: u8 = 2;
    pub const cycling: u8 = 4;
    pub const transition: u8 = 8;
    pub const fitness_equipment: u8 = 10;
    pub const swimming: u8 = 20;
    pub const basketball: u8 = 40;
    pub const soccer: u8 = 80;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const SportBits1 = struct {
    pub const tennis: u8 = 1001;
    pub const american_football: u8 = 1002;
    pub const training: u8 = 1004;
    pub const walking: u8 = 1008;
    pub const cross_country_skiing: u8 = 1010;
    pub const alpine_skiing: u8 = 1020;
    pub const snowboarding: u8 = 1040;
    pub const rowing: u8 = 1080;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const SportBits2 = struct {
    pub const mountaineering: u8 = 2001;
    pub const hiking: u8 = 2002;
    pub const multisport: u8 = 2004;
    pub const paddling: u8 = 2008;
    pub const flying: u8 = 2010;
    pub const e_biking: u8 = 2020;
    pub const motorcycling: u8 = 2040;
    pub const boating: u8 = 2080;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const SportBits3 = struct {
    pub const driving: u8 = 3001;
    pub const golf: u8 = 3002;
    pub const hang_gliding: u8 = 3004;
    pub const horseback_riding: u8 = 3008;
    pub const hunting: u8 = 3010;
    pub const fishing: u8 = 3020;
    pub const inline_skating: u8 = 3040;
    pub const rock_climbing: u8 = 3080;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const SportBits4 = struct {
    pub const sailing: u8 = 4001;
    pub const ice_skating: u8 = 4002;
    pub const sky_diving: u8 = 4004;
    pub const snowshoeing: u8 = 4008;
    pub const snowmobiling: u8 = 4010;
    pub const stand_up_paddleboarding: u8 = 4020;
    pub const surfing: u8 = 4040;
    pub const wakeboarding: u8 = 4080;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const SportBits5 = struct {
    pub const water_skiing: u8 = 5001;
    pub const kayaking: u8 = 5002;
    pub const rafting: u8 = 5004;
    pub const windsurfing: u8 = 5008;
    pub const kitesurfing: u8 = 5010;
    pub const tactical: u8 = 5020;
    pub const jumpmaster: u8 = 5040;
    pub const boxing: u8 = 5080;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const SportBits6 = struct {
    pub const floor_climbing: u8 = 6001;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const SubSport = struct {
    pub const generic = 0;
    pub const treadmill = 1;
    pub const street = 2;
    pub const trail = 3;
    pub const track = 4;
    pub const spin = 5;
    pub const indoor_cycling = 6;
    pub const road = 7;
    pub const mountain = 8;
    pub const downhill = 9;
    pub const recumbent = 10;
    pub const cyclocross = 11;
    pub const hand_cycling = 12;
    pub const track_cycling = 13;
    pub const indoor_rowing = 14;
    pub const elliptical = 15;
    pub const stair_climbing = 16;
    pub const lap_swimming = 17;
    pub const open_water = 18;
    pub const flexibility_training = 19;
    pub const strength_training = 20;
    pub const warm_up = 21;
    pub const match = 22;
    pub const exercise = 23;
    pub const challenge = 24;
    pub const indoor_skiing = 25;
    pub const cardio_training = 26;
    pub const indoor_walking = 27;
    pub const e_bike_fitness = 28;
    pub const bmx = 29;
    pub const casual_walking = 30;
    pub const speed_walking = 31;
    pub const bike_to_run_transition = 32;
    pub const run_to_bike_transition = 33;
    pub const swim_to_bike_transition = 34;
    pub const atv = 35;
    pub const motocross = 36;
    pub const backcountry = 37;
    pub const resort = 38;
    pub const rc_drone = 39;
    pub const wingsuit = 40;
    pub const whitewater = 41;
    pub const skate_skiing = 42;
    pub const yoga = 43;
    pub const pilates = 44;
    pub const indoor_running = 45;
    pub const gravel_cycling = 46;
    pub const e_bike_mountain = 47;
    pub const commuting = 48;
    pub const mixed_surface = 49;
    pub const navigate = 50;
    pub const track_me = 51;
    pub const map = 52;
    pub const single_gas_diving = 53;
    pub const multi_gas_diving = 54;
    pub const gauge_diving = 55;
    pub const apnea_diving = 56;
    pub const apnea_hunting = 57;
    pub const virtual_activity = 58;
    pub const obstacle = 59;
    pub const all = 254;
};

pub const SportEvent = struct {
    pub const uncategorized = 0;
    pub const geocaching = 1;
    pub const fitness = 2;
    pub const recreation = 3;
    pub const race = 4;
    pub const special_event = 5;
    pub const training = 6;
    pub const transportation = 7;
    pub const touring = 8;
};

pub const Activity = struct {
    pub const manual = 0;
    pub const auto_multi_sport = 1;
};

pub const Intensity = struct {
    pub const active = 0;
    pub const rest = 1;
    pub const warmup = 2;
    pub const cooldown = 3;
    pub const recovery = 4;
    pub const interval = 5;
    pub const other = 6;
};

pub const SessionTrigger = struct {
    pub const activity_end = 0;
    pub const manual = 1;
    pub const auto_multi_sport = 2;
    pub const fitness_equipment = 3;
};

pub const AutolapTrigger = struct {
    pub const time = 0;
    pub const distance = 1;
    pub const position_start = 2;
    pub const position_lap = 3;
    pub const position_waypoint = 4;
    pub const position_marked = 5;
    pub const off = 6;
};

pub const LapTrigger = struct {
    pub const manual = 0;
    pub const time = 1;
    pub const distance = 2;
    pub const position_start = 3;
    pub const position_lap = 4;
    pub const position_waypoint = 5;
    pub const position_marked = 6;
    pub const session_end = 7;
    pub const fitness_equipment = 8;
};

pub const TimeMode = struct {
    pub const hour12 = 0;
    pub const hour24 = 1;
    pub const military = 2;
    pub const hour_12_with_seconds = 3;
    pub const hour_24_with_seconds = 4;
    pub const utc = 5;
};

pub const BacklightMode = struct {
    pub const off = 0;
    pub const manual = 1;
    pub const key_and_messages = 2;
    pub const auto_brightness = 3;
    pub const smart_notifications = 4;
    pub const key_and_messages_night = 5;
    pub const key_and_messages_and_smart_notifications = 6;
};

pub const DateMode = struct {
    pub const day_month = 0;
    pub const month_day = 1;
};

pub const BacklightTimeout = struct {
    pub const infinite: u8 = 0;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const Event = struct {
    pub const timer = 0;
    pub const workout = 3;
    pub const workout_step = 4;
    pub const power_down = 5;
    pub const power_up = 6;
    pub const off_course = 7;
    pub const session = 8;
    pub const lap = 9;
    pub const course_point = 10;
    pub const battery = 11;
    pub const virtual_partner_pace = 12;
    pub const hr_high_alert = 13;
    pub const hr_low_alert = 14;
    pub const speed_high_alert = 15;
    pub const speed_low_alert = 16;
    pub const cad_high_alert = 17;
    pub const cad_low_alert = 18;
    pub const power_high_alert = 19;
    pub const power_low_alert = 20;
    pub const recovery_hr = 21;
    pub const battery_low = 22;
    pub const time_duration_alert = 23;
    pub const distance_duration_alert = 24;
    pub const calorie_duration_alert = 25;
    pub const activity = 26;
    pub const fitness_equipment = 27;
    pub const length = 28;
    pub const user_marker = 32;
    pub const sport_point = 33;
    pub const calibration = 36;
    pub const front_gear_change = 42;
    pub const rear_gear_change = 43;
    pub const rider_position_change = 44;
    pub const elev_high_alert = 45;
    pub const elev_low_alert = 46;
    pub const comm_timeout = 47;
    pub const radar_threat_alert = 75;
};

pub const EventType = struct {
    pub const start = 0;
    pub const stop = 1;
    pub const consecutive_depreciated = 2;
    pub const marker = 3;
    pub const stop_all = 4;
    pub const begin_depreciated = 5;
    pub const end_depreciated = 6;
    pub const end_all_depreciated = 7;
    pub const stop_disable = 8;
    pub const stop_disable_all = 9;
};

pub const TimerTrigger = struct {
    pub const manual = 0;
    pub const auto = 1;
    pub const fitness_equipment = 2;
};

pub const FitnessEquipmentState = struct {
    pub const ready = 0;
    pub const in_use = 1;
    pub const paused = 2;
    pub const unknown = 3;
};

pub const Tone = struct {
    pub const off = 0;
    pub const tone = 1;
    pub const vibrate = 2;
    pub const tone_and_vibrate = 3;
};

pub const Autoscroll = struct {
    pub const none = 0;
    pub const slow = 1;
    pub const medium = 2;
    pub const fast = 3;
};

pub const ActivityClass = struct {
    pub const level = 7;
    pub const level_max = 100;
    pub const athlete = 80;
};

pub const HrZoneCalc = struct {
    pub const custom = 0;
    pub const percent_max_hr = 1;
    pub const percent_hrr = 2;
};

pub const PwrZoneCalc = struct {
    pub const custom = 0;
    pub const percent_ftp = 1;
};

pub const WktStepDuration = struct {
    pub const time = 0;
    pub const distance = 1;
    pub const hr_less_than = 2;
    pub const hr_greater_than = 3;
    pub const calories = 4;
    pub const open = 5;
    pub const repeat_until_steps_cmplt = 6;
    pub const repeat_until_time = 7;
    pub const repeat_until_distance = 8;
    pub const repeat_until_calories = 9;
    pub const repeat_until_hr_less_than = 10;
    pub const repeat_until_hr_greater_than = 11;
    pub const repeat_until_power_less_than = 12;
    pub const repeat_until_power_greater_than = 13;
    pub const power_less_than = 14;
    pub const power_greater_than = 15;
    pub const training_peaks_tss = 16;
    pub const repeat_until_power_last_lap_less_than = 17;
    pub const repeat_until_max_power_last_lap_less_than = 18;
    pub const power_3s_less_than = 19;
    pub const power_10s_less_than = 20;
    pub const power_30s_less_than = 21;
    pub const power_3s_greater_than = 22;
    pub const power_10s_greater_than = 23;
    pub const power_30s_greater_than = 24;
    pub const power_lap_less_than = 25;
    pub const power_lap_greater_than = 26;
    pub const repeat_until_training_peaks_tss = 27;
    pub const repetition_time = 28;
    pub const reps = 29;
    pub const time_only = 31;
};

pub const WktStepTarget = struct {
    pub const speed = 0;
    pub const heart_rate = 1;
    pub const open = 2;
    pub const cadence = 3;
    pub const power = 4;
    pub const grade = 5;
    pub const resistance = 6;
    pub const power_3s = 7;
    pub const power_10s = 8;
    pub const power_30s = 9;
    pub const power_lap = 10;
    pub const swim_stroke = 11;
    pub const speed_lap = 12;
    pub const heart_rate_lap = 13;
};

pub const Goal = struct {
    pub const time = 0;
    pub const distance = 1;
    pub const calories = 2;
    pub const frequency = 3;
    pub const steps = 4;
    pub const ascent = 5;
    pub const active_minutes = 6;
};

pub const GoalRecurrence = struct {
    pub const off = 0;
    pub const daily = 1;
    pub const weekly = 2;
    pub const monthly = 3;
    pub const yearly = 4;
    pub const custom = 5;
};

pub const GoalSource = struct {
    pub const auto = 0;
    pub const community = 1;
    pub const user = 2;
};

pub const Schedule = struct {
    pub const workout = 0;
    pub const course = 1;
};

pub const CoursePoint = struct {
    pub const generic = 0;
    pub const summit = 1;
    pub const valley = 2;
    pub const water = 3;
    pub const food = 4;
    pub const danger = 5;
    pub const left = 6;
    pub const right = 7;
    pub const straight = 8;
    pub const first_aid = 9;
    pub const fourth_category = 10;
    pub const third_category = 11;
    pub const second_category = 12;
    pub const first_category = 13;
    pub const hors_category = 14;
    pub const sprint = 15;
    pub const left_fork = 16;
    pub const right_fork = 17;
    pub const middle_fork = 18;
    pub const slight_left = 19;
    pub const sharp_left = 20;
    pub const slight_right = 21;
    pub const sharp_right = 22;
    pub const u_turn = 23;
    pub const segment_start = 24;
    pub const segment_end = 25;
};

pub const Manufacturer = struct {
    pub const garmin: u16 = 1;
    pub const garmin_fr405_antfs: u16 = 2;
    pub const zephyr: u16 = 3;
    pub const dayton: u16 = 4;
    pub const idt: u16 = 5;
    pub const srm: u16 = 6;
    pub const quarq: u16 = 7;
    pub const ibike: u16 = 8;
    pub const saris: u16 = 9;
    pub const spark_hk: u16 = 10;
    pub const tanita: u16 = 11;
    pub const echowell: u16 = 12;
    pub const dynastream_oem: u16 = 13;
    pub const nautilus: u16 = 14;
    pub const dynastream: u16 = 15;
    pub const timex: u16 = 16;
    pub const metrigear: u16 = 17;
    pub const xelic: u16 = 18;
    pub const beurer: u16 = 19;
    pub const cardiosport: u16 = 20;
    pub const a_and_d: u16 = 21;
    pub const hmm: u16 = 22;
    pub const suunto: u16 = 23;
    pub const thita_elektronik: u16 = 24;
    pub const gpulse: u16 = 25;
    pub const clean_mobile: u16 = 26;
    pub const pedal_brain: u16 = 27;
    pub const peaksware: u16 = 28;
    pub const saxonar: u16 = 29;
    pub const lemond_fitness: u16 = 30;
    pub const dexcom: u16 = 31;
    pub const wahoo_fitness: u16 = 32;
    pub const octane_fitness: u16 = 33;
    pub const archinoetics: u16 = 34;
    pub const the_hurt_box: u16 = 35;
    pub const citizen_systems: u16 = 36;
    pub const magellan: u16 = 37;
    pub const osynce: u16 = 38;
    pub const holux: u16 = 39;
    pub const concept2: u16 = 40;
    pub const one_giant_leap: u16 = 42;
    pub const ace_sensor: u16 = 43;
    pub const brim_brothers: u16 = 44;
    pub const xplova: u16 = 45;
    pub const perception_digital: u16 = 46;
    pub const bf1systems: u16 = 47;
    pub const pioneer: u16 = 48;
    pub const spantec: u16 = 49;
    pub const metalogics: u16 = 50;
    pub const _4iiiis: u16 = 51;
    pub const seiko_epson: u16 = 52;
    pub const seiko_epson_oem: u16 = 53;
    pub const ifor_powell: u16 = 54;
    pub const maxwell_guider: u16 = 55;
    pub const star_trac: u16 = 56;
    pub const breakaway: u16 = 57;
    pub const alatech_technology_ltd: u16 = 58;
    pub const mio_technology_europe: u16 = 59;
    pub const rotor: u16 = 60;
    pub const geonaute: u16 = 61;
    pub const id_bike: u16 = 62;
    pub const specialized: u16 = 63;
    pub const wtek: u16 = 64;
    pub const physical_enterprises: u16 = 65;
    pub const north_pole_engineering: u16 = 66;
    pub const bkool: u16 = 67;
    pub const cateye: u16 = 68;
    pub const stages_cycling: u16 = 69;
    pub const sigmasport: u16 = 70;
    pub const tomtom: u16 = 71;
    pub const peripedal: u16 = 72;
    pub const wattbike: u16 = 73;
    pub const moxy: u16 = 76;
    pub const ciclosport: u16 = 77;
    pub const powerbahn: u16 = 78;
    pub const acorn_projects_aps: u16 = 79;
    pub const lifebeam: u16 = 80;
    pub const bontrager: u16 = 81;
    pub const wellgo: u16 = 82;
    pub const scosche: u16 = 83;
    pub const magura: u16 = 84;
    pub const woodway: u16 = 85;
    pub const elite: u16 = 86;
    pub const nielsen_kellerman: u16 = 87;
    pub const dk_city: u16 = 88;
    pub const tacx: u16 = 89;
    pub const direction_technology: u16 = 90;
    pub const magtonic: u16 = 91;
    pub const _1partcarbon: u16 = 92;
    pub const inside_ride_technologies: u16 = 93;
    pub const sound_of_motion: u16 = 94;
    pub const stryd: u16 = 95;
    pub const icg: u16 = 96;
    pub const mipulse: u16 = 97;
    pub const bsx_athletics: u16 = 98;
    pub const look: u16 = 99;
    pub const campagnolo_srl: u16 = 100;
    pub const body_bike_smart: u16 = 101;
    pub const praxisworks: u16 = 102;
    pub const limits_technology: u16 = 103;
    pub const topaction_technology: u16 = 104;
    pub const cosinuss: u16 = 105;
    pub const fitcare: u16 = 106;
    pub const magene: u16 = 107;
    pub const giant_manufacturing_co: u16 = 108;
    pub const tigrasport: u16 = 109;
    pub const salutron: u16 = 110;
    pub const technogym: u16 = 111;
    pub const bryton_sensors: u16 = 112;
    pub const latitude_limited: u16 = 113;
    pub const soaring_technology: u16 = 114;
    pub const igpsport: u16 = 115;
    pub const thinkrider: u16 = 116;
    pub const gopher_sport: u16 = 117;
    pub const waterrower: u16 = 118;
    pub const orangetheory: u16 = 119;
    pub const inpeak: u16 = 120;
    pub const kinetic: u16 = 121;
    pub const johnson_health_tech: u16 = 122;
    pub const polar_electro: u16 = 123;
    pub const seesense: u16 = 124;
    pub const nci_technology: u16 = 125;
    pub const iqsquare: u16 = 126;
    pub const leomo: u16 = 127;
    pub const ifit_com: u16 = 128;
    pub const coros_byte: u16 = 129;
    pub const versa_design: u16 = 130;
    pub const chileaf: u16 = 131;
    pub const cycplus: u16 = 132;
    pub const gravaa_byte: u16 = 133;
    pub const sigeyi: u16 = 134;
    pub const development: u16 = 255;
    pub const healthandlife: u16 = 257;
    pub const lezyne: u16 = 258;
    pub const scribe_labs: u16 = 259;
    pub const zwift: u16 = 260;
    pub const watteam: u16 = 261;
    pub const recon: u16 = 262;
    pub const favero_electronics: u16 = 263;
    pub const dynovelo: u16 = 264;
    pub const strava: u16 = 265;
    pub const precor: u16 = 266;
    pub const bryton: u16 = 267;
    pub const sram: u16 = 268;
    pub const navman: u16 = 269;
    pub const cobi: u16 = 270;
    pub const spivi: u16 = 271;
    pub const mio_magellan: u16 = 272;
    pub const evesports: u16 = 273;
    pub const sensitivus_gauge: u16 = 274;
    pub const podoon: u16 = 275;
    pub const life_time_fitness: u16 = 276;
    pub const falco_e_motors: u16 = 277;
    pub const minoura: u16 = 278;
    pub const cycliq: u16 = 279;
    pub const luxottica: u16 = 280;
    pub const trainer_road: u16 = 281;
    pub const the_sufferfest: u16 = 282;
    pub const fullspeedahead: u16 = 283;
    pub const virtualtraining: u16 = 284;
    pub const feedbacksports: u16 = 285;
    pub const omata: u16 = 286;
    pub const vdo: u16 = 287;
    pub const magneticdays: u16 = 288;
    pub const hammerhead: u16 = 289;
    pub const kinetic_by_kurt: u16 = 290;
    pub const shapelog: u16 = 291;
    pub const dabuziduo: u16 = 292;
    pub const jetblack: u16 = 293;
    pub const coros: u16 = 294;
    pub const virtugo: u16 = 295;
    pub const velosense: u16 = 296;
    pub const cycligentinc: u16 = 297;
    pub const trailforks: u16 = 298;
    pub const mahle_ebikemotion: u16 = 299;
    pub const nurvv: u16 = 300;
    pub const microprogram: u16 = 301;
    pub const zone5cloud: u16 = 302;
    pub const greenteg: u16 = 303;
    pub const yamaha_motors: u16 = 304;
    pub const whoop: u16 = 305;
    pub const gravaa: u16 = 306;
    pub const onelap: u16 = 307;
    pub const monark_exercise: u16 = 308;
    pub const form: u16 = 309;
    pub const decathlon: u16 = 310;
    pub const actigraphcorp: u16 = 5759;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const GarminProduct = struct {
    pub const hrm1: u16 = 1;
    pub const axh01: u16 = 2;
    pub const axb01: u16 = 3;
    pub const axb02: u16 = 4;
    pub const hrm2ss: u16 = 5;
    pub const dsi_alf02: u16 = 6;
    pub const hrm3ss: u16 = 7;
    pub const hrm_run_single_byte_product_id: u16 = 8;
    pub const bsm: u16 = 9;
    pub const bcm: u16 = 10;
    pub const axs01: u16 = 11;
    pub const hrm_tri_single_byte_product_id: u16 = 12;
    pub const hrm4_run_single_byte_product_id: u16 = 13;
    pub const fr225_single_byte_product_id: u16 = 14;
    pub const gen3_bsm_single_byte_product_id: u16 = 15;
    pub const gen3_bcm_single_byte_product_id: u16 = 16;
    pub const fr301_china: u16 = 473;
    pub const fr301_japan: u16 = 474;
    pub const fr301_korea: u16 = 475;
    pub const fr301_taiwan: u16 = 494;
    pub const fr405: u16 = 717;
    pub const fr50: u16 = 782;
    pub const fr405_japan: u16 = 987;
    pub const fr60: u16 = 988;
    pub const dsi_alf01: u16 = 1011;
    pub const fr310xt: u16 = 1018;
    pub const edge500: u16 = 1036;
    pub const fr110: u16 = 1124;
    pub const edge800: u16 = 1169;
    pub const edge500_taiwan: u16 = 1199;
    pub const edge500_japan: u16 = 1213;
    pub const chirp: u16 = 1253;
    pub const fr110_japan: u16 = 1274;
    pub const edge200: u16 = 1325;
    pub const fr910xt: u16 = 1328;
    pub const edge800_taiwan: u16 = 1333;
    pub const edge800_japan: u16 = 1334;
    pub const alf04: u16 = 1341;
    pub const fr610: u16 = 1345;
    pub const fr210_japan: u16 = 1360;
    pub const vector_ss: u16 = 1380;
    pub const vector_cp: u16 = 1381;
    pub const edge800_china: u16 = 1386;
    pub const edge500_china: u16 = 1387;
    pub const approach_g10: u16 = 1405;
    pub const fr610_japan: u16 = 1410;
    pub const edge500_korea: u16 = 1422;
    pub const fr70: u16 = 1436;
    pub const fr310xt_4t: u16 = 1446;
    pub const amx: u16 = 1461;
    pub const fr10: u16 = 1482;
    pub const edge800_korea: u16 = 1497;
    pub const swim: u16 = 1499;
    pub const fr910xt_china: u16 = 1537;
    pub const fenix: u16 = 1551;
    pub const edge200_taiwan: u16 = 1555;
    pub const edge510: u16 = 1561;
    pub const edge810: u16 = 1567;
    pub const tempe: u16 = 1570;
    pub const fr910xt_japan: u16 = 1600;
    pub const fr620: u16 = 1623;
    pub const fr220: u16 = 1632;
    pub const fr910xt_korea: u16 = 1664;
    pub const fr10_japan: u16 = 1688;
    pub const edge810_japan: u16 = 1721;
    pub const virb_elite: u16 = 1735;
    pub const edge_touring: u16 = 1736;
    pub const edge510_japan: u16 = 1742;
    pub const hrm_tri: u16 = 1743;
    pub const hrm_run: u16 = 1752;
    pub const fr920xt: u16 = 1765;
    pub const edge510_asia: u16 = 1821;
    pub const edge810_china: u16 = 1822;
    pub const edge810_taiwan: u16 = 1823;
    pub const edge1000: u16 = 1836;
    pub const vivo_fit: u16 = 1837;
    pub const virb_remote: u16 = 1853;
    pub const vivo_ki: u16 = 1885;
    pub const fr15: u16 = 1903;
    pub const vivo_active: u16 = 1907;
    pub const edge510_korea: u16 = 1918;
    pub const fr620_japan: u16 = 1928;
    pub const fr620_china: u16 = 1929;
    pub const fr220_japan: u16 = 1930;
    pub const fr220_china: u16 = 1931;
    pub const approach_s6: u16 = 1936;
    pub const vivo_smart: u16 = 1956;
    pub const fenix2: u16 = 1967;
    pub const epix: u16 = 1988;
    pub const fenix3: u16 = 2050;
    pub const edge1000_taiwan: u16 = 2052;
    pub const edge1000_japan: u16 = 2053;
    pub const fr15_japan: u16 = 2061;
    pub const edge520: u16 = 2067;
    pub const edge1000_china: u16 = 2070;
    pub const fr620_russia: u16 = 2072;
    pub const fr220_russia: u16 = 2073;
    pub const vector_s: u16 = 2079;
    pub const edge1000_korea: u16 = 2100;
    pub const fr920xt_taiwan: u16 = 2130;
    pub const fr920xt_china: u16 = 2131;
    pub const fr920xt_japan: u16 = 2132;
    pub const virbx: u16 = 2134;
    pub const vivo_smart_apac: u16 = 2135;
    pub const etrex_touch: u16 = 2140;
    pub const edge25: u16 = 2147;
    pub const fr25: u16 = 2148;
    pub const vivo_fit2: u16 = 2150;
    pub const fr225: u16 = 2153;
    pub const fr630: u16 = 2156;
    pub const fr230: u16 = 2157;
    pub const fr735xt: u16 = 2158;
    pub const vivo_active_apac: u16 = 2160;
    pub const vector_2: u16 = 2161;
    pub const vector_2s: u16 = 2162;
    pub const virbxe: u16 = 2172;
    pub const fr620_taiwan: u16 = 2173;
    pub const fr220_taiwan: u16 = 2174;
    pub const truswing: u16 = 2175;
    pub const d2airvenu: u16 = 2187;
    pub const fenix3_china: u16 = 2188;
    pub const fenix3_twn: u16 = 2189;
    pub const varia_headlight: u16 = 2192;
    pub const varia_taillight_old: u16 = 2193;
    pub const edge_explore_1000: u16 = 2204;
    pub const fr225_asia: u16 = 2219;
    pub const varia_radar_taillight: u16 = 2225;
    pub const varia_radar_display: u16 = 2226;
    pub const edge20: u16 = 2238;
    pub const edge520_asia: u16 = 2260;
    pub const edge520_japan: u16 = 2261;
    pub const d2_bravo: u16 = 2262;
    pub const approach_s20: u16 = 2266;
    pub const vivo_smart2: u16 = 2271;
    pub const edge1000_thai: u16 = 2274;
    pub const varia_remote: u16 = 2276;
    pub const edge25_asia: u16 = 2288;
    pub const edge25_jpn: u16 = 2289;
    pub const edge20_asia: u16 = 2290;
    pub const approach_x40: u16 = 2292;
    pub const fenix3_japan: u16 = 2293;
    pub const vivo_smart_emea: u16 = 2294;
    pub const fr630_asia: u16 = 2310;
    pub const fr630_jpn: u16 = 2311;
    pub const fr230_jpn: u16 = 2313;
    pub const hrm4_run: u16 = 2327;
    pub const epix_japan: u16 = 2332;
    pub const vivo_active_hr: u16 = 2337;
    pub const vivo_smart_gps_hr: u16 = 2347;
    pub const vivo_smart_hr: u16 = 2348;
    pub const vivo_smart_hr_asia: u16 = 2361;
    pub const vivo_smart_gps_hr_asia: u16 = 2362;
    pub const vivo_move: u16 = 2368;
    pub const varia_taillight: u16 = 2379;
    pub const fr235_japan: u16 = 2397;
    pub const varia_vision: u16 = 2398;
    pub const vivo_fit3: u16 = 2406;
    pub const fenix3_korea: u16 = 2407;
    pub const fenix3_sea: u16 = 2408;
    pub const fenix3_hr: u16 = 2413;
    pub const virb_ultra_30: u16 = 2417;
    pub const index_smart_scale: u16 = 2429;
    pub const fr235: u16 = 2431;
    pub const fenix3_chronos: u16 = 2432;
    pub const oregon7xx: u16 = 2441;
    pub const rino7xx: u16 = 2444;
    pub const epix_korea: u16 = 2457;
    pub const fenix3_hr_chn: u16 = 2473;
    pub const fenix3_hr_twn: u16 = 2474;
    pub const fenix3_hr_jpn: u16 = 2475;
    pub const fenix3_hr_sea: u16 = 2476;
    pub const fenix3_hr_kor: u16 = 2477;
    pub const nautix: u16 = 2496;
    pub const vivo_active_hr_apac: u16 = 2497;
    pub const oregon7xx_ww: u16 = 2512;
    pub const edge_820: u16 = 2530;
    pub const edge_explore_820: u16 = 2531;
    pub const fr735xt_apac: u16 = 2533;
    pub const fr735xt_japan: u16 = 2534;
    pub const fenix5s: u16 = 2544;
    pub const d2_bravo_titanium: u16 = 2547;
    pub const varia_ut800: u16 = 2567;
    pub const running_dynamics_pod: u16 = 2593;
    pub const edge_820_china: u16 = 2599;
    pub const edge_820_japan: u16 = 2600;
    pub const fenix5x: u16 = 2604;
    pub const vivo_fit_jr: u16 = 2606;
    pub const vivo_smart3: u16 = 2622;
    pub const vivo_sport: u16 = 2623;
    pub const edge_820_taiwan: u16 = 2628;
    pub const edge_820_korea: u16 = 2629;
    pub const edge_820_sea: u16 = 2630;
    pub const fr35_hebrew: u16 = 2650;
    pub const approach_s60: u16 = 2656;
    pub const fr35_apac: u16 = 2667;
    pub const fr35_japan: u16 = 2668;
    pub const fenix3_chronos_asia: u16 = 2675;
    pub const virb_360: u16 = 2687;
    pub const fr935: u16 = 2691;
    pub const fenix5: u16 = 2697;
    pub const vivoactive3: u16 = 2700;
    pub const fr235_china_nfc: u16 = 2733;
    pub const foretrex_601_701: u16 = 2769;
    pub const vivo_move_hr: u16 = 2772;
    pub const edge_1030: u16 = 2713;
    pub const fenix5_asia: u16 = 2796;
    pub const fenix5s_asia: u16 = 2797;
    pub const fenix5x_asia: u16 = 2798;
    pub const approach_z80: u16 = 2806;
    pub const fr35_korea: u16 = 2814;
    pub const d2charlie: u16 = 2819;
    pub const vivo_smart3_apac: u16 = 2831;
    pub const vivo_sport_apac: u16 = 2832;
    pub const fr935_asia: u16 = 2833;
    pub const descent: u16 = 2859;
    pub const fr645: u16 = 2886;
    pub const fr645m: u16 = 2888;
    pub const fr30: u16 = 2891;
    pub const fenix5s_plus: u16 = 2900;
    pub const edge_130: u16 = 2909;
    pub const edge_1030_asia: u16 = 2924;
    pub const vivosmart_4: u16 = 2927;
    pub const vivo_move_hr_asia: u16 = 2945;
    pub const approach_x10: u16 = 2962;
    pub const fr30_asia: u16 = 2977;
    pub const vivoactive3m_w: u16 = 2988;
    pub const fr645_asia: u16 = 3003;
    pub const fr645m_asia: u16 = 3004;
    pub const edge_explore: u16 = 3011;
    pub const gpsmap66: u16 = 3028;
    pub const approach_s10: u16 = 3049;
    pub const vivoactive3m_l: u16 = 3066;
    pub const approach_g80: u16 = 3085;
    pub const edge_130_asia: u16 = 3092;
    pub const edge_1030_bontrager: u16 = 3095;
    pub const fenix5_plus: u16 = 3110;
    pub const fenix5x_plus: u16 = 3111;
    pub const edge_520_plus: u16 = 3112;
    pub const fr945: u16 = 3113;
    pub const edge_530: u16 = 3121;
    pub const edge_830: u16 = 3122;
    pub const instinct_esports: u16 = 3126;
    pub const fenix5s_plus_apac: u16 = 3134;
    pub const fenix5x_plus_apac: u16 = 3135;
    pub const edge_520_plus_apac: u16 = 3142;
    pub const fr235l_asia: u16 = 3144;
    pub const fr245_asia: u16 = 3145;
    pub const vivo_active3m_apac: u16 = 3163;
    pub const gen3_bsm: u16 = 3192;
    pub const gen3_bcm: u16 = 3193;
    pub const vivo_smart4_asia: u16 = 3218;
    pub const vivoactive4_small: u16 = 3224;
    pub const vivoactive4_large: u16 = 3225;
    pub const venu: u16 = 3226;
    pub const marq_driver: u16 = 3246;
    pub const marq_aviator: u16 = 3247;
    pub const marq_captain: u16 = 3248;
    pub const marq_commander: u16 = 3249;
    pub const marq_expedition: u16 = 3250;
    pub const marq_athlete: u16 = 3251;
    pub const descent_mk2: u16 = 3258;
    pub const fenix6s_sport: u16 = 3287;
    pub const fenix6s: u16 = 3288;
    pub const fenix6_sport: u16 = 3289;
    pub const fenix6: u16 = 3290;
    pub const fenix6x: u16 = 3291;
    pub const hrm_dual: u16 = 3299;
    pub const vivo_move3_premium: u16 = 3308;
    pub const approach_s40: u16 = 3314;
    pub const fr245m_asia: u16 = 3321;
    pub const edge_530_apac: u16 = 3349;
    pub const edge_830_apac: u16 = 3350;
    pub const vivo_move3: u16 = 3378;
    pub const vivo_active4_small_asia: u16 = 3387;
    pub const vivo_active4_large_asia: u16 = 3388;
    pub const vivo_active4_oled_asia: u16 = 3389;
    pub const swim2: u16 = 3405;
    pub const marq_driver_asia: u16 = 3420;
    pub const marq_aviator_asia: u16 = 3421;
    pub const vivo_move3_asia: u16 = 3422;
    pub const fr945_asia: u16 = 3441;
    pub const vivo_active3t_chn: u16 = 3446;
    pub const marq_captain_asia: u16 = 3448;
    pub const marq_commander_asia: u16 = 3449;
    pub const marq_expedition_asia: u16 = 3450;
    pub const marq_athlete_asia: u16 = 3451;
    pub const fr45_asia: u16 = 3469;
    pub const vivoactive3_daimler: u16 = 3473;
    pub const fenix6s_sport_asia: u16 = 3512;
    pub const fenix6s_asia: u16 = 3513;
    pub const fenix6_sport_asia: u16 = 3514;
    pub const fenix6_asia: u16 = 3515;
    pub const fenix6x_asia: u16 = 3516;
    pub const edge_130_plus: u16 = 3558;
    pub const edge_1030_plus: u16 = 3570;
    pub const fr745: u16 = 3589;
    pub const venusq: u16 = 3600;
    pub const marq_adventurer: u16 = 3624;
    pub const marq_adventurer_asia: u16 = 3648;
    pub const swim2_apac: u16 = 3639;
    pub const descent_mk2_asia: u16 = 3702;
    pub const venu_daimler_asia: u16 = 3737;
    pub const marq_golfer: u16 = 3739;
    pub const venu_daimler: u16 = 3740;
    pub const fr745_asia: u16 = 3794;
    pub const edge_1030_plus_asia: u16 = 3812;
    pub const edge_130_plus_asia: u16 = 3813;
    pub const venusq_asia: u16 = 3837;
    pub const marq_golfer_asia: u16 = 3850;
    pub const venu2plus: u16 = 3851;
    pub const sdm4: u16 = 10007;
    pub const edge_remote: u16 = 10014;
    pub const tacx_training_app_win: u16 = 20533;
    pub const tacx_training_app_mac: u16 = 20534;
    pub const training_center: u16 = 20119;
    pub const tacx_training_app_android: u16 = 30045;
    pub const tacx_training_app_ios: u16 = 30046;
    pub const tacx_training_app_legacy: u16 = 30047;
    pub const connectiq_simulator: u16 = 65531;
    pub const android_antplus_plugin: u16 = 65532;
    pub const connect: u16 = 65534;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const AntplusDeviceType = struct {
    pub const antfs: u8 = 1;
    pub const bike_power: u8 = 11;
    pub const environment_sensor_legacy: u8 = 12;
    pub const multi_sport_speed_distance: u8 = 15;
    pub const control: u8 = 16;
    pub const fitness_equipment: u8 = 17;
    pub const blood_pressure: u8 = 18;
    pub const geocache_node: u8 = 19;
    pub const light_electric_vehicle: u8 = 20;
    pub const env_sensor: u8 = 25;
    pub const racquet: u8 = 26;
    pub const control_hub: u8 = 27;
    pub const muscle_oxygen: u8 = 31;
    pub const bike_light_main: u8 = 35;
    pub const bike_light_shared: u8 = 36;
    pub const exd: u8 = 38;
    pub const bike_radar: u8 = 40;
    pub const bike_aero: u8 = 46;
    pub const weight_scale: u8 = 119;
    pub const heart_rate: u8 = 120;
    pub const bike_speed_cadence: u8 = 121;
    pub const bike_cadence: u8 = 122;
    pub const bike_speed: u8 = 123;
    pub const stride_speed_distance: u8 = 124;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const AntNetwork = struct {
    pub const public = 0;
    pub const antplus = 1;
    pub const antfs = 2;
    pub const private = 3;
};

pub const WorkoutCapabilities = struct {
    pub const interval: u32 = 1;
    pub const custom: u32 = 2;
    pub const fitness_equipment: u32 = 4;
    pub const firstbeat: u32 = 8;
    pub const new_leaf: u32 = 10;
    pub const tcx: u32 = 20;
    pub const speed: u32 = 80;
    pub const heart_rate: u32 = 100;
    pub const distance: u32 = 200;
    pub const cadence: u32 = 400;
    pub const power: u32 = 800;
    pub const grade: u32 = 1000;
    pub const resistance: u32 = 2000;
    pub const protected: u32 = 4000;

    const Self = @This();
    pub fn toString(i: u32) []const u8 {
        return genericToString(Self, u32, i);
    }
};

pub const BatteryStatus = struct {
    pub const new: u8 = 1;
    pub const good: u8 = 2;
    pub const ok: u8 = 3;
    pub const low: u8 = 4;
    pub const critical: u8 = 5;
    pub const charging: u8 = 6;
    pub const unknown: u8 = 7;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const HrType = struct {
    pub const normal = 0;
    pub const irregular = 1;
};

pub const CourseCapabilities = struct {
    pub const processed: u32 = 1;
    pub const valid: u32 = 2;
    pub const time: u32 = 4;
    pub const distance: u32 = 8;
    pub const position: u32 = 10;
    pub const heart_rate: u32 = 20;
    pub const power: u32 = 40;
    pub const cadence: u32 = 80;
    pub const training: u32 = 100;
    pub const navigation: u32 = 200;
    pub const bikeway: u32 = 400;

    const Self = @This();
    pub fn toString(i: u32) []const u8 {
        return genericToString(Self, u32, i);
    }
};

pub const Weight = struct {
    pub const calculating: u16 = 0;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const WorkoutHr = struct {
    pub const bpm_offset: u32 = 100;

    const Self = @This();
    pub fn toString(i: u32) []const u8 {
        return genericToString(Self, u32, i);
    }
};

pub const WorkoutPower = struct {
    pub const watts_offset: u32 = 1000;

    const Self = @This();
    pub fn toString(i: u32) []const u8 {
        return genericToString(Self, u32, i);
    }
};

pub const BpStatus = struct {
    pub const no_error = 0;
    pub const error_incomplete_data = 1;
    pub const error_no_measurement = 2;
    pub const error_data_out_of_range = 3;
    pub const error_irregular_heart_rate = 4;
};

pub const UserLocalId = struct {
    pub const local_min: u16 = 0;
    pub const local_max: u16 = 0;
    pub const stationary_min: u16 = 10;
    pub const stationary_max: u16 = 0;
    pub const portable_min: u16 = 100;
    pub const portable_max: u16 = 0;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const SwimStroke = struct {
    pub const freestyle = 0;
    pub const backstroke = 1;
    pub const breaststroke = 2;
    pub const butterfly = 3;
    pub const drill = 4;
    pub const mixed = 5;
    pub const im = 6;
};

pub const ActivityType = struct {
    pub const generic = 0;
    pub const running = 1;
    pub const cycling = 2;
    pub const transition = 3;
    pub const fitness_equipment = 4;
    pub const swimming = 5;
    pub const walking = 6;
    pub const sedentary = 8;
    pub const all = 254;
};

pub const ActivitySubtype = struct {
    pub const generic = 0;
    pub const treadmill = 1;
    pub const street = 2;
    pub const trail = 3;
    pub const track = 4;
    pub const spin = 5;
    pub const indoor_cycling = 6;
    pub const road = 7;
    pub const mountain = 8;
    pub const downhill = 9;
    pub const recumbent = 10;
    pub const cyclocross = 11;
    pub const hand_cycling = 12;
    pub const track_cycling = 13;
    pub const indoor_rowing = 14;
    pub const elliptical = 15;
    pub const stair_climbing = 16;
    pub const lap_swimming = 17;
    pub const open_water = 18;
    pub const all = 254;
};

pub const ActivityLevel = struct {
    pub const low = 0;
    pub const medium = 1;
    pub const high = 2;
};

pub const Side = struct {
    pub const right = 0;
    pub const left = 1;
};

pub const LeftRightBalance = struct {
    pub const mask: u8 = 7;
    pub const right: u8 = 80;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const LeftRightBalance100 = struct {
    pub const mask: u16 = 10003;
    pub const right: u16 = 10008000;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const LengthType = struct {
    pub const idle = 0;
    pub const active = 1;
};

pub const DayOfWeek = struct {
    pub const sunday = 0;
    pub const monday = 1;
    pub const tuesday = 2;
    pub const wednesday = 3;
    pub const thursday = 4;
    pub const friday = 5;
    pub const saturday = 6;
};

pub const ConnectivityCapabilities = struct {
    pub const bluetooth: u32 = 1;
    pub const bluetooth_le: u32 = 2;
    pub const ant: u32 = 4;
    pub const activity_upload: u32 = 8;
    pub const course_download: u32 = 10;
    pub const workout_download: u32 = 20;
    pub const live_track: u32 = 40;
    pub const weather_conditions: u32 = 80;
    pub const weather_alerts: u32 = 100;
    pub const gps_ephemeris_download: u32 = 200;
    pub const explicit_archive: u32 = 400;
    pub const setup_incomplete: u32 = 800;
    pub const continue_sync_after_software_update: u32 = 1000;
    pub const connect_iq_app_download: u32 = 2000;
    pub const golf_course_download: u32 = 4000;
    pub const device_initiates_sync: u32 = 8000;
    pub const connect_iq_watch_app_download: u32 = 10000;
    pub const connect_iq_widget_download: u32 = 20000;
    pub const connect_iq_watch_face_download: u32 = 40000;
    pub const connect_iq_data_field_download: u32 = 80000;
    pub const connect_iq_app_managment: u32 = 100000;
    pub const swing_sensor: u32 = 200000;
    pub const swing_sensor_remote: u32 = 400000;
    pub const incident_detection: u32 = 800000;
    pub const audio_prompts: u32 = 1000000;
    pub const wifi_verification: u32 = 2000000;
    pub const true_up: u32 = 4000000;
    pub const find_my_watch: u32 = 8000000;
    pub const remote_manual_sync: u32 = 10000000;
    pub const live_track_auto_start: u32 = 20000000;
    pub const live_track_messaging: u32 = 40000000;
    pub const instant_input: u32 = 80000000;

    const Self = @This();
    pub fn toString(i: u32) []const u8 {
        return genericToString(Self, u32, i);
    }
};

pub const WeatherReport = struct {
    pub const current = 0;
    pub const forecast = 1;
    pub const hourly_forecast = 1;
    pub const daily_forecast = 2;
};

pub const WeatherStatus = struct {
    pub const clear = 0;
    pub const partly_cloudy = 1;
    pub const mostly_cloudy = 2;
    pub const rain = 3;
    pub const snow = 4;
    pub const windy = 5;
    pub const thunderstorms = 6;
    pub const wintry_mix = 7;
    pub const fog = 8;
    pub const hazy = 11;
    pub const hail = 12;
    pub const scattered_showers = 13;
    pub const scattered_thunderstorms = 14;
    pub const unknown_precipitation = 15;
    pub const light_rain = 16;
    pub const heavy_rain = 17;
    pub const light_snow = 18;
    pub const heavy_snow = 19;
    pub const light_rain_snow = 20;
    pub const heavy_rain_snow = 21;
    pub const cloudy = 22;
};

pub const WeatherSeverity = struct {
    pub const unknown = 0;
    pub const warning = 1;
    pub const watch = 2;
    pub const advisory = 3;
    pub const statement = 4;
};

pub const WeatherSevereType = struct {
    pub const unspecified = 0;
    pub const tornado = 1;
    pub const tsunami = 2;
    pub const hurricane = 3;
    pub const extreme_wind = 4;
    pub const typhoon = 5;
    pub const inland_hurricane = 6;
    pub const hurricane_force_wind = 7;
    pub const waterspout = 8;
    pub const severe_thunderstorm = 9;
    pub const wreckhouse_winds = 10;
    pub const les_suetes_wind = 11;
    pub const avalanche = 12;
    pub const flash_flood = 13;
    pub const tropical_storm = 14;
    pub const inland_tropical_storm = 15;
    pub const blizzard = 16;
    pub const ice_storm = 17;
    pub const freezing_rain = 18;
    pub const debris_flow = 19;
    pub const flash_freeze = 20;
    pub const dust_storm = 21;
    pub const high_wind = 22;
    pub const winter_storm = 23;
    pub const heavy_freezing_spray = 24;
    pub const extreme_cold = 25;
    pub const wind_chill = 26;
    pub const cold_wave = 27;
    pub const heavy_snow_alert = 28;
    pub const lake_effect_blowing_snow = 29;
    pub const snow_squall = 30;
    pub const lake_effect_snow = 31;
    pub const winter_weather = 32;
    pub const sleet = 33;
    pub const snowfall = 34;
    pub const snow_and_blowing_snow = 35;
    pub const blowing_snow = 36;
    pub const snow_alert = 37;
    pub const arctic_outflow = 38;
    pub const freezing_drizzle = 39;
    pub const storm = 40;
    pub const storm_surge = 41;
    pub const rainfall = 42;
    pub const areal_flood = 43;
    pub const coastal_flood = 44;
    pub const lakeshore_flood = 45;
    pub const excessive_heat = 46;
    pub const heat = 47;
    pub const weather = 48;
    pub const high_heat_and_humidity = 49;
    pub const humidex_and_health = 50;
    pub const humidex = 51;
    pub const gale = 52;
    pub const freezing_spray = 53;
    pub const special_marine = 54;
    pub const squall = 55;
    pub const strong_wind = 56;
    pub const lake_wind = 57;
    pub const marine_weather = 58;
    pub const wind = 59;
    pub const small_craft_hazardous_seas = 60;
    pub const hazardous_seas = 61;
    pub const small_craft = 62;
    pub const small_craft_winds = 63;
    pub const small_craft_rough_bar = 64;
    pub const high_water_level = 65;
    pub const ashfall = 66;
    pub const freezing_fog = 67;
    pub const dense_fog = 68;
    pub const dense_smoke = 69;
    pub const blowing_dust = 70;
    pub const hard_freeze = 71;
    pub const freeze = 72;
    pub const frost = 73;
    pub const fire_weather = 74;
    pub const flood = 75;
    pub const rip_tide = 76;
    pub const high_surf = 77;
    pub const smog = 78;
    pub const air_quality = 79;
    pub const brisk_wind = 80;
    pub const air_stagnation = 81;
    pub const low_water = 82;
    pub const hydrological = 83;
    pub const special_weather = 84;
};

pub const TimeIntoDay = struct {
    const Self = @This();
    pub fn toString(i: u32) []const u8 {
        return genericToString(Self, u32, i);
    }
};

pub const LocaltimeIntoDay = struct {
    const Self = @This();
    pub fn toString(i: u32) []const u8 {
        return genericToString(Self, u32, i);
    }
};

pub const StrokeType = struct {
    pub const no_event = 0;
    pub const other = 1;
    pub const serve = 2;
    pub const forehand = 3;
    pub const backhand = 4;
    pub const smash = 5;
};

pub const BodyLocation = struct {
    pub const left_leg = 0;
    pub const left_calf = 1;
    pub const left_shin = 2;
    pub const left_hamstring = 3;
    pub const left_quad = 4;
    pub const left_glute = 5;
    pub const right_leg = 6;
    pub const right_calf = 7;
    pub const right_shin = 8;
    pub const right_hamstring = 9;
    pub const right_quad = 10;
    pub const right_glute = 11;
    pub const torso_back = 12;
    pub const left_lower_back = 13;
    pub const left_upper_back = 14;
    pub const right_lower_back = 15;
    pub const right_upper_back = 16;
    pub const torso_front = 17;
    pub const left_abdomen = 18;
    pub const left_chest = 19;
    pub const right_abdomen = 20;
    pub const right_chest = 21;
    pub const left_arm = 22;
    pub const left_shoulder = 23;
    pub const left_bicep = 24;
    pub const left_tricep = 25;
    pub const left_brachioradialis = 26;
    pub const left_forearm_extensors = 27;
    pub const right_arm = 28;
    pub const right_shoulder = 29;
    pub const right_bicep = 30;
    pub const right_tricep = 31;
    pub const right_brachioradialis = 32;
    pub const right_forearm_extensors = 33;
    pub const neck = 34;
    pub const throat = 35;
    pub const waist_mid_back = 36;
    pub const waist_front = 37;
    pub const waist_left = 38;
    pub const waist_right = 39;
};

pub const SegmentLapStatus = struct {
    pub const end = 0;
    pub const fail = 1;
};

pub const SegmentLeaderboardType = struct {
    pub const overall = 0;
    pub const personal_best = 1;
    pub const connections = 2;
    pub const group = 3;
    pub const challenger = 4;
    pub const kom = 5;
    pub const qom = 6;
    pub const pr = 7;
    pub const goal = 8;
    pub const rival = 9;
    pub const club_leader = 10;
};

pub const SegmentDeleteStatus = struct {
    pub const do_not_delete = 0;
    pub const delete_one = 1;
    pub const delete_all = 2;
};

pub const SegmentSelectionType = struct {
    pub const starred = 0;
    pub const suggested = 1;
};

pub const SourceType = struct {
    pub const ant = 0;
    pub const antplus = 1;
    pub const bluetooth = 2;
    pub const bluetooth_low_energy = 3;
    pub const wifi = 4;
    pub const local = 5;
};

pub const LocalDeviceType = struct {
    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const DisplayOrientation = struct {
    pub const auto = 0;
    pub const portrait = 1;
    pub const landscape = 2;
    pub const portrait_flipped = 3;
    pub const landscape_flipped = 4;
};

pub const WorkoutEquipment = struct {
    pub const none = 0;
    pub const swim_fins = 1;
    pub const swim_kickboard = 2;
    pub const swim_paddles = 3;
    pub const swim_pull_buoy = 4;
    pub const swim_snorkel = 5;
};

pub const WatchfaceMode = struct {
    pub const digital = 0;
    pub const analog = 1;
    pub const connect_iq = 2;
    pub const disabled = 3;
};

pub const DigitalWatchfaceLayout = struct {
    pub const traditional = 0;
    pub const modern = 1;
    pub const bold = 2;
};

pub const AnalogWatchfaceLayout = struct {
    pub const minimal = 0;
    pub const traditional = 1;
    pub const modern = 2;
};

pub const RiderPositionType = struct {
    pub const seated = 0;
    pub const standing = 1;
    pub const transition_to_seated = 2;
    pub const transition_to_standing = 3;
};

pub const PowerPhaseType = struct {
    pub const power_phase_start_angle = 0;
    pub const power_phase_end_angle = 1;
    pub const power_phase_arc_length = 2;
    pub const power_phase_center = 3;
};

pub const CameraEventType = struct {
    pub const video_start = 0;
    pub const video_split = 1;
    pub const video_end = 2;
    pub const photo_taken = 3;
    pub const video_second_stream_start = 4;
    pub const video_second_stream_split = 5;
    pub const video_second_stream_end = 6;
    pub const video_split_start = 7;
    pub const video_second_stream_split_start = 8;
    pub const video_pause = 11;
    pub const video_second_stream_pause = 12;
    pub const video_resume = 13;
    pub const video_second_stream_resume = 14;
};

pub const SensorType = struct {
    pub const accelerometer = 0;
    pub const gyroscope = 1;
    pub const compass = 2;
    pub const barometer = 3;
};

pub const BikeLightNetworkConfigType = struct {
    pub const auto = 0;
    pub const individual = 4;
    pub const high_visibility = 5;
    pub const trail = 6;
};

pub const CommTimeoutType = struct {
    pub const wildcard_pairing_timeout: u16 = 0;
    pub const pairing_timeout: u16 = 1;
    pub const connection_lost: u16 = 2;
    pub const connection_timeout: u16 = 3;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const CameraOrientationType = struct {
    pub const camera_orientation_0 = 0;
    pub const camera_orientation_90 = 1;
    pub const camera_orientation_180 = 2;
    pub const camera_orientation_270 = 3;
};

pub const AttitudeStage = struct {
    pub const failed = 0;
    pub const aligning = 1;
    pub const degraded = 2;
    pub const valid = 3;
};

pub const AttitudeValidity = struct {
    pub const track_angle_heading_valid: u16 = 1;
    pub const pitch_valid: u16 = 2;
    pub const roll_valid: u16 = 4;
    pub const lateral_body_accel_valid: u16 = 8;
    pub const normal_body_accel_valid: u16 = 10;
    pub const turn_rate_valid: u16 = 20;
    pub const hw_fail: u16 = 40;
    pub const mag_invalid: u16 = 80;
    pub const no_gps: u16 = 100;
    pub const gps_invalid: u16 = 200;
    pub const solution_coasting: u16 = 400;
    pub const true_track_angle: u16 = 800;
    pub const magnetic_heading: u16 = 1000;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const AutoSyncFrequency = struct {
    pub const never = 0;
    pub const occasionally = 1;
    pub const frequent = 2;
    pub const once_a_day = 3;
    pub const remote = 4;
};

pub const ExdLayout = struct {
    pub const full_screen = 0;
    pub const half_vertical = 1;
    pub const half_horizontal = 2;
    pub const half_vertical_right_split = 3;
    pub const half_horizontal_bottom_split = 4;
    pub const full_quarter_split = 5;
    pub const half_vertical_left_split = 6;
    pub const half_horizontal_top_split = 7;
    pub const dynamic = 8;
};

pub const ExdDisplayType = struct {
    pub const numerical = 0;
    pub const simple = 1;
    pub const graph = 2;
    pub const bar = 3;
    pub const circle_graph = 4;
    pub const virtual_partner = 5;
    pub const balance = 6;
    pub const string_list = 7;
    pub const string = 8;
    pub const simple_dynamic_icon = 9;
    pub const gauge = 10;
};

pub const ExdDataUnits = struct {
    pub const no_units = 0;
    pub const laps = 1;
    pub const miles_per_hour = 2;
    pub const kilometers_per_hour = 3;
    pub const feet_per_hour = 4;
    pub const meters_per_hour = 5;
    pub const degrees_celsius = 6;
    pub const degrees_farenheit = 7;
    pub const zone = 8;
    pub const gear = 9;
    pub const rpm = 10;
    pub const bpm = 11;
    pub const degrees = 12;
    pub const millimeters = 13;
    pub const meters = 14;
    pub const kilometers = 15;
    pub const feet = 16;
    pub const yards = 17;
    pub const kilofeet = 18;
    pub const miles = 19;
    pub const time = 20;
    pub const enum_turn_type = 21;
    pub const percent = 22;
    pub const watts = 23;
    pub const watts_per_kilogram = 24;
    pub const enum_battery_status = 25;
    pub const enum_bike_light_beam_angle_mode = 26;
    pub const enum_bike_light_battery_status = 27;
    pub const enum_bike_light_network_config_type = 28;
    pub const lights = 29;
    pub const seconds = 30;
    pub const minutes = 31;
    pub const hours = 32;
    pub const calories = 33;
    pub const kilojoules = 34;
    pub const milliseconds = 35;
    pub const second_per_mile = 36;
    pub const second_per_kilometer = 37;
    pub const centimeter = 38;
    pub const enum_course_point = 39;
    pub const bradians = 40;
    pub const enum_sport = 41;
    pub const inches_hg = 42;
    pub const mm_hg = 43;
    pub const mbars = 44;
    pub const hecto_pascals = 45;
    pub const feet_per_min = 46;
    pub const meters_per_min = 47;
    pub const meters_per_sec = 48;
    pub const eight_cardinal = 49;
};

pub const ExdQualifiers = struct {
    pub const no_qualifier = 0;
    pub const instantaneous = 1;
    pub const average = 2;
    pub const lap = 3;
    pub const maximum = 4;
    pub const maximum_average = 5;
    pub const maximum_lap = 6;
    pub const last_lap = 7;
    pub const average_lap = 8;
    pub const to_destination = 9;
    pub const to_go = 10;
    pub const to_next = 11;
    pub const next_course_point = 12;
    pub const total = 13;
    pub const three_second_average = 14;
    pub const ten_second_average = 15;
    pub const thirty_second_average = 16;
    pub const percent_maximum = 17;
    pub const percent_maximum_average = 18;
    pub const lap_percent_maximum = 19;
    pub const elapsed = 20;
    pub const sunrise = 21;
    pub const sunset = 22;
    pub const compared_to_virtual_partner = 23;
    pub const maximum_24h = 24;
    pub const minimum_24h = 25;
    pub const minimum = 26;
    pub const first = 27;
    pub const second = 28;
    pub const third = 29;
    pub const shifter = 30;
    pub const last_sport = 31;
    pub const moving = 32;
    pub const stopped = 33;
    pub const estimated_total = 34;
    pub const zone_9 = 242;
    pub const zone_8 = 243;
    pub const zone_7 = 244;
    pub const zone_6 = 245;
    pub const zone_5 = 246;
    pub const zone_4 = 247;
    pub const zone_3 = 248;
    pub const zone_2 = 249;
    pub const zone_1 = 250;
};

pub const ExdDescriptors = struct {
    pub const bike_light_battery_status = 0;
    pub const beam_angle_status = 1;
    pub const batery_level = 2;
    pub const light_network_mode = 3;
    pub const number_lights_connected = 4;
    pub const cadence = 5;
    pub const distance = 6;
    pub const estimated_time_of_arrival = 7;
    pub const heading = 8;
    pub const time = 9;
    pub const battery_level = 10;
    pub const trainer_resistance = 11;
    pub const trainer_target_power = 12;
    pub const time_seated = 13;
    pub const time_standing = 14;
    pub const elevation = 15;
    pub const grade = 16;
    pub const ascent = 17;
    pub const descent = 18;
    pub const vertical_speed = 19;
    pub const di2_battery_level = 20;
    pub const front_gear = 21;
    pub const rear_gear = 22;
    pub const gear_ratio = 23;
    pub const heart_rate = 24;
    pub const heart_rate_zone = 25;
    pub const time_in_heart_rate_zone = 26;
    pub const heart_rate_reserve = 27;
    pub const calories = 28;
    pub const gps_accuracy = 29;
    pub const gps_signal_strength = 30;
    pub const temperature = 31;
    pub const time_of_day = 32;
    pub const balance = 33;
    pub const pedal_smoothness = 34;
    pub const power = 35;
    pub const functional_threshold_power = 36;
    pub const intensity_factor = 37;
    pub const work = 38;
    pub const power_ratio = 39;
    pub const normalized_power = 40;
    pub const training_stress_score = 41;
    pub const time_on_zone = 42;
    pub const speed = 43;
    pub const laps = 44;
    pub const reps = 45;
    pub const workout_step = 46;
    pub const course_distance = 47;
    pub const navigation_distance = 48;
    pub const course_estimated_time_of_arrival = 49;
    pub const navigation_estimated_time_of_arrival = 50;
    pub const course_time = 51;
    pub const navigation_time = 52;
    pub const course_heading = 53;
    pub const navigation_heading = 54;
    pub const power_zone = 55;
    pub const torque_effectiveness = 56;
    pub const timer_time = 57;
    pub const power_weight_ratio = 58;
    pub const left_platform_center_offset = 59;
    pub const right_platform_center_offset = 60;
    pub const left_power_phase_start_angle = 61;
    pub const right_power_phase_start_angle = 62;
    pub const left_power_phase_finish_angle = 63;
    pub const right_power_phase_finish_angle = 64;
    pub const gears = 65;
    pub const pace = 66;
    pub const training_effect = 67;
    pub const vertical_oscillation = 68;
    pub const vertical_ratio = 69;
    pub const ground_contact_time = 70;
    pub const left_ground_contact_time_balance = 71;
    pub const right_ground_contact_time_balance = 72;
    pub const stride_length = 73;
    pub const running_cadence = 74;
    pub const performance_condition = 75;
    pub const course_type = 76;
    pub const time_in_power_zone = 77;
    pub const navigation_turn = 78;
    pub const course_location = 79;
    pub const navigation_location = 80;
    pub const compass = 81;
    pub const gear_combo = 82;
    pub const muscle_oxygen = 83;
    pub const icon = 84;
    pub const compass_heading = 85;
    pub const gps_heading = 86;
    pub const gps_elevation = 87;
    pub const anaerobic_training_effect = 88;
    pub const course = 89;
    pub const off_course = 90;
    pub const glide_ratio = 91;
    pub const vertical_distance = 92;
    pub const vmg = 93;
    pub const ambient_pressure = 94;
    pub const pressure = 95;
    pub const vam = 96;
};

pub const AutoActivityDetect = struct {
    pub const none: u32 = 0;
    pub const running: u32 = 1;
    pub const cycling: u32 = 2;
    pub const swimming: u32 = 4;
    pub const walking: u32 = 8;
    pub const elliptical: u32 = 20;
    pub const sedentary: u32 = 400;

    const Self = @This();
    pub fn toString(i: u32) []const u8 {
        return genericToString(Self, u32, i);
    }
};

pub const SupportedExdScreenLayouts = struct {
    pub const full_screen: u32 = 1;
    pub const half_vertical: u32 = 2;
    pub const half_horizontal: u32 = 4;
    pub const half_vertical_right_split: u32 = 8;
    pub const half_horizontal_bottom_split: u32 = 10;
    pub const full_quarter_split: u32 = 20;
    pub const half_vertical_left_split: u32 = 40;
    pub const half_horizontal_top_split: u32 = 80;

    const Self = @This();
    pub fn toString(i: u32) []const u8 {
        return genericToString(Self, u32, i);
    }
};

pub const FitBaseType = struct {
    pub const @"enum": u8 = 0;
    pub const sint8: u8 = 1;
    pub const uint8: u8 = 2;
    pub const sint16: u8 = 131;
    pub const uint16: u8 = 132;
    pub const sint32: u8 = 133;
    pub const uint32: u8 = 134;
    pub const string: u8 = 7;
    pub const float32: u8 = 136;
    pub const float64: u8 = 137;
    pub const uint8z: u8 = 10;
    pub const uint16z: u8 = 139;
    pub const uint32z: u8 = 140;
    pub const byte: u8 = 13;
    pub const sint64: u8 = 142;
    pub const uint64: u8 = 143;
    pub const uint64z: u8 = 144;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const TurnType = struct {
    pub const arriving_idx = 0;
    pub const arriving_left_idx = 1;
    pub const arriving_right_idx = 2;
    pub const arriving_via_idx = 3;
    pub const arriving_via_left_idx = 4;
    pub const arriving_via_right_idx = 5;
    pub const bear_keep_left_idx = 6;
    pub const bear_keep_right_idx = 7;
    pub const continue_idx = 8;
    pub const exit_left_idx = 9;
    pub const exit_right_idx = 10;
    pub const ferry_idx = 11;
    pub const roundabout_45_idx = 12;
    pub const roundabout_90_idx = 13;
    pub const roundabout_135_idx = 14;
    pub const roundabout_180_idx = 15;
    pub const roundabout_225_idx = 16;
    pub const roundabout_270_idx = 17;
    pub const roundabout_315_idx = 18;
    pub const roundabout_360_idx = 19;
    pub const roundabout_neg_45_idx = 20;
    pub const roundabout_neg_90_idx = 21;
    pub const roundabout_neg_135_idx = 22;
    pub const roundabout_neg_180_idx = 23;
    pub const roundabout_neg_225_idx = 24;
    pub const roundabout_neg_270_idx = 25;
    pub const roundabout_neg_315_idx = 26;
    pub const roundabout_neg_360_idx = 27;
    pub const roundabout_generic_idx = 28;
    pub const roundabout_neg_generic_idx = 29;
    pub const sharp_turn_left_idx = 30;
    pub const sharp_turn_right_idx = 31;
    pub const turn_left_idx = 32;
    pub const turn_right_idx = 33;
    pub const uturn_left_idx = 34;
    pub const uturn_right_idx = 35;
    pub const icon_inv_idx = 36;
    pub const icon_idx_cnt = 37;
};

pub const BikeLightBeamAngleMode = struct {
    pub const manual: u8 = 0;
    pub const auto: u8 = 1;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const FitBaseUnit = struct {
    pub const other: u16 = 0;
    pub const kilogram: u16 = 1;
    pub const pound: u16 = 2;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const SetType = struct {
    pub const rest: u8 = 0;
    pub const active: u8 = 1;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const ExerciseCategory = struct {
    pub const bench_press: u16 = 0;
    pub const calf_raise: u16 = 1;
    pub const cardio: u16 = 2;
    pub const carry: u16 = 3;
    pub const chop: u16 = 4;
    pub const core: u16 = 5;
    pub const crunch: u16 = 6;
    pub const curl: u16 = 7;
    pub const deadlift: u16 = 8;
    pub const flye: u16 = 9;
    pub const hip_raise: u16 = 10;
    pub const hip_stability: u16 = 11;
    pub const hip_swing: u16 = 12;
    pub const hyperextension: u16 = 13;
    pub const lateral_raise: u16 = 14;
    pub const leg_curl: u16 = 15;
    pub const leg_raise: u16 = 16;
    pub const lunge: u16 = 17;
    pub const olympic_lift: u16 = 18;
    pub const plank: u16 = 19;
    pub const plyo: u16 = 20;
    pub const pull_up: u16 = 21;
    pub const push_up: u16 = 22;
    pub const row: u16 = 23;
    pub const shoulder_press: u16 = 24;
    pub const shoulder_stability: u16 = 25;
    pub const shrug: u16 = 26;
    pub const sit_up: u16 = 27;
    pub const squat: u16 = 28;
    pub const total_body: u16 = 29;
    pub const triceps_extension: u16 = 30;
    pub const warm_up: u16 = 31;
    pub const run: u16 = 32;
    pub const unknown: u16 = 65534;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const BenchPressExerciseName = struct {
    pub const alternating_dumbbell_chest_press_on_swiss_ball: u16 = 0;
    pub const barbell_bench_press: u16 = 1;
    pub const barbell_board_bench_press: u16 = 2;
    pub const barbell_floor_press: u16 = 3;
    pub const close_grip_barbell_bench_press: u16 = 4;
    pub const decline_dumbbell_bench_press: u16 = 5;
    pub const dumbbell_bench_press: u16 = 6;
    pub const dumbbell_floor_press: u16 = 7;
    pub const incline_barbell_bench_press: u16 = 8;
    pub const incline_dumbbell_bench_press: u16 = 9;
    pub const incline_smith_machine_bench_press: u16 = 10;
    pub const isometric_barbell_bench_press: u16 = 11;
    pub const kettlebell_chest_press: u16 = 12;
    pub const neutral_grip_dumbbell_bench_press: u16 = 13;
    pub const neutral_grip_dumbbell_incline_bench_press: u16 = 14;
    pub const one_arm_floor_press: u16 = 15;
    pub const weighted_one_arm_floor_press: u16 = 16;
    pub const partial_lockout: u16 = 17;
    pub const reverse_grip_barbell_bench_press: u16 = 18;
    pub const reverse_grip_incline_bench_press: u16 = 19;
    pub const single_arm_cable_chest_press: u16 = 20;
    pub const single_arm_dumbbell_bench_press: u16 = 21;
    pub const smith_machine_bench_press: u16 = 22;
    pub const swiss_ball_dumbbell_chest_press: u16 = 23;
    pub const triple_stop_barbell_bench_press: u16 = 24;
    pub const wide_grip_barbell_bench_press: u16 = 25;
    pub const alternating_dumbbell_chest_press: u16 = 26;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const CalfRaiseExerciseName = struct {
    pub const _3_way_calf_raise: u16 = 0;
    pub const _3_way_weighted_calf_raise: u16 = 1;
    pub const _3_way_single_leg_calf_raise: u16 = 2;
    pub const _3_way_weighted_single_leg_calf_raise: u16 = 3;
    pub const donkey_calf_raise: u16 = 4;
    pub const weighted_donkey_calf_raise: u16 = 5;
    pub const seated_calf_raise: u16 = 6;
    pub const weighted_seated_calf_raise: u16 = 7;
    pub const seated_dumbbell_toe_raise: u16 = 8;
    pub const single_leg_bent_knee_calf_raise: u16 = 9;
    pub const weighted_single_leg_bent_knee_calf_raise: u16 = 10;
    pub const single_leg_decline_push_up: u16 = 11;
    pub const single_leg_donkey_calf_raise: u16 = 12;
    pub const weighted_single_leg_donkey_calf_raise: u16 = 13;
    pub const single_leg_hip_raise_with_knee_hold: u16 = 14;
    pub const single_leg_standing_calf_raise: u16 = 15;
    pub const single_leg_standing_dumbbell_calf_raise: u16 = 16;
    pub const standing_barbell_calf_raise: u16 = 17;
    pub const standing_calf_raise: u16 = 18;
    pub const weighted_standing_calf_raise: u16 = 19;
    pub const standing_dumbbell_calf_raise: u16 = 20;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const CardioExerciseName = struct {
    pub const bob_and_weave_circle: u16 = 0;
    pub const weighted_bob_and_weave_circle: u16 = 1;
    pub const cardio_core_crawl: u16 = 2;
    pub const weighted_cardio_core_crawl: u16 = 3;
    pub const double_under: u16 = 4;
    pub const weighted_double_under: u16 = 5;
    pub const jump_rope: u16 = 6;
    pub const weighted_jump_rope: u16 = 7;
    pub const jump_rope_crossover: u16 = 8;
    pub const weighted_jump_rope_crossover: u16 = 9;
    pub const jump_rope_jog: u16 = 10;
    pub const weighted_jump_rope_jog: u16 = 11;
    pub const jumping_jacks: u16 = 12;
    pub const weighted_jumping_jacks: u16 = 13;
    pub const ski_moguls: u16 = 14;
    pub const weighted_ski_moguls: u16 = 15;
    pub const split_jacks: u16 = 16;
    pub const weighted_split_jacks: u16 = 17;
    pub const squat_jacks: u16 = 18;
    pub const weighted_squat_jacks: u16 = 19;
    pub const triple_under: u16 = 20;
    pub const weighted_triple_under: u16 = 21;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const CarryExerciseName = struct {
    pub const bar_holds: u16 = 0;
    pub const farmers_walk: u16 = 1;
    pub const farmers_walk_on_toes: u16 = 2;
    pub const hex_dumbbell_hold: u16 = 3;
    pub const overhead_carry: u16 = 4;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const ChopExerciseName = struct {
    pub const cable_pull_through: u16 = 0;
    pub const cable_rotational_lift: u16 = 1;
    pub const cable_woodchop: u16 = 2;
    pub const cross_chop_to_knee: u16 = 3;
    pub const weighted_cross_chop_to_knee: u16 = 4;
    pub const dumbbell_chop: u16 = 5;
    pub const half_kneeling_rotation: u16 = 6;
    pub const weighted_half_kneeling_rotation: u16 = 7;
    pub const half_kneeling_rotational_chop: u16 = 8;
    pub const half_kneeling_rotational_reverse_chop: u16 = 9;
    pub const half_kneeling_stability_chop: u16 = 10;
    pub const half_kneeling_stability_reverse_chop: u16 = 11;
    pub const kneeling_rotational_chop: u16 = 12;
    pub const kneeling_rotational_reverse_chop: u16 = 13;
    pub const kneeling_stability_chop: u16 = 14;
    pub const kneeling_woodchopper: u16 = 15;
    pub const medicine_ball_wood_chops: u16 = 16;
    pub const power_squat_chops: u16 = 17;
    pub const weighted_power_squat_chops: u16 = 18;
    pub const standing_rotational_chop: u16 = 19;
    pub const standing_split_rotational_chop: u16 = 20;
    pub const standing_split_rotational_reverse_chop: u16 = 21;
    pub const standing_stability_reverse_chop: u16 = 22;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const CoreExerciseName = struct {
    pub const abs_jabs: u16 = 0;
    pub const weighted_abs_jabs: u16 = 1;
    pub const alternating_plate_reach: u16 = 2;
    pub const barbell_rollout: u16 = 3;
    pub const weighted_barbell_rollout: u16 = 4;
    pub const body_bar_oblique_twist: u16 = 5;
    pub const cable_core_press: u16 = 6;
    pub const cable_side_bend: u16 = 7;
    pub const side_bend: u16 = 8;
    pub const weighted_side_bend: u16 = 9;
    pub const crescent_circle: u16 = 10;
    pub const weighted_crescent_circle: u16 = 11;
    pub const cycling_russian_twist: u16 = 12;
    pub const weighted_cycling_russian_twist: u16 = 13;
    pub const elevated_feet_russian_twist: u16 = 14;
    pub const weighted_elevated_feet_russian_twist: u16 = 15;
    pub const half_turkish_get_up: u16 = 16;
    pub const kettlebell_windmill: u16 = 17;
    pub const kneeling_ab_wheel: u16 = 18;
    pub const weighted_kneeling_ab_wheel: u16 = 19;
    pub const modified_front_lever: u16 = 20;
    pub const open_knee_tucks: u16 = 21;
    pub const weighted_open_knee_tucks: u16 = 22;
    pub const side_abs_leg_lift: u16 = 23;
    pub const weighted_side_abs_leg_lift: u16 = 24;
    pub const swiss_ball_jackknife: u16 = 25;
    pub const weighted_swiss_ball_jackknife: u16 = 26;
    pub const swiss_ball_pike: u16 = 27;
    pub const weighted_swiss_ball_pike: u16 = 28;
    pub const swiss_ball_rollout: u16 = 29;
    pub const weighted_swiss_ball_rollout: u16 = 30;
    pub const triangle_hip_press: u16 = 31;
    pub const weighted_triangle_hip_press: u16 = 32;
    pub const trx_suspended_jackknife: u16 = 33;
    pub const weighted_trx_suspended_jackknife: u16 = 34;
    pub const u_boat: u16 = 35;
    pub const weighted_u_boat: u16 = 36;
    pub const windmill_switches: u16 = 37;
    pub const weighted_windmill_switches: u16 = 38;
    pub const alternating_slide_out: u16 = 39;
    pub const weighted_alternating_slide_out: u16 = 40;
    pub const ghd_back_extensions: u16 = 41;
    pub const weighted_ghd_back_extensions: u16 = 42;
    pub const overhead_walk: u16 = 43;
    pub const inchworm: u16 = 44;
    pub const weighted_modified_front_lever: u16 = 45;
    pub const russian_twist: u16 = 46;
    pub const abdominal_leg_rotations: u16 = 47;
    pub const arm_and_leg_extension_on_knees: u16 = 48;
    pub const bicycle: u16 = 49;
    pub const bicep_curl_with_leg_extension: u16 = 50;
    pub const cat_cow: u16 = 51;
    pub const corkscrew: u16 = 52;
    pub const criss_cross: u16 = 53;
    pub const criss_cross_with_ball: u16 = 54;
    pub const double_leg_stretch: u16 = 55;
    pub const knee_folds: u16 = 56;
    pub const lower_lift: u16 = 57;
    pub const neck_pull: u16 = 58;
    pub const pelvic_clocks: u16 = 59;
    pub const roll_over: u16 = 60;
    pub const roll_up: u16 = 61;
    pub const rolling: u16 = 62;
    pub const rowing_1: u16 = 63;
    pub const rowing_2: u16 = 64;
    pub const scissors: u16 = 65;
    pub const single_leg_circles: u16 = 66;
    pub const single_leg_stretch: u16 = 67;
    pub const snake_twist_1_and_2: u16 = 68;
    pub const swan: u16 = 69;
    pub const swimming: u16 = 70;
    pub const teaser: u16 = 71;
    pub const the_hundred: u16 = 72;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const CrunchExerciseName = struct {
    pub const bicycle_crunch: u16 = 0;
    pub const cable_crunch: u16 = 1;
    pub const circular_arm_crunch: u16 = 2;
    pub const crossed_arms_crunch: u16 = 3;
    pub const weighted_crossed_arms_crunch: u16 = 4;
    pub const cross_leg_reverse_crunch: u16 = 5;
    pub const weighted_cross_leg_reverse_crunch: u16 = 6;
    pub const crunch_chop: u16 = 7;
    pub const weighted_crunch_chop: u16 = 8;
    pub const double_crunch: u16 = 9;
    pub const weighted_double_crunch: u16 = 10;
    pub const elbow_to_knee_crunch: u16 = 11;
    pub const weighted_elbow_to_knee_crunch: u16 = 12;
    pub const flutter_kicks: u16 = 13;
    pub const weighted_flutter_kicks: u16 = 14;
    pub const foam_roller_reverse_crunch_on_bench: u16 = 15;
    pub const weighted_foam_roller_reverse_crunch_on_bench: u16 = 16;
    pub const foam_roller_reverse_crunch_with_dumbbell: u16 = 17;
    pub const foam_roller_reverse_crunch_with_medicine_ball: u16 = 18;
    pub const frog_press: u16 = 19;
    pub const hanging_knee_raise_oblique_crunch: u16 = 20;
    pub const weighted_hanging_knee_raise_oblique_crunch: u16 = 21;
    pub const hip_crossover: u16 = 22;
    pub const weighted_hip_crossover: u16 = 23;
    pub const hollow_rock: u16 = 24;
    pub const weighted_hollow_rock: u16 = 25;
    pub const incline_reverse_crunch: u16 = 26;
    pub const weighted_incline_reverse_crunch: u16 = 27;
    pub const kneeling_cable_crunch: u16 = 28;
    pub const kneeling_cross_crunch: u16 = 29;
    pub const weighted_kneeling_cross_crunch: u16 = 30;
    pub const kneeling_oblique_cable_crunch: u16 = 31;
    pub const knees_to_elbow: u16 = 32;
    pub const leg_extensions: u16 = 33;
    pub const weighted_leg_extensions: u16 = 34;
    pub const leg_levers: u16 = 35;
    pub const mcgill_curl_up: u16 = 36;
    pub const weighted_mcgill_curl_up: u16 = 37;
    pub const modified_pilates_roll_up_with_ball: u16 = 38;
    pub const weighted_modified_pilates_roll_up_with_ball: u16 = 39;
    pub const pilates_crunch: u16 = 40;
    pub const weighted_pilates_crunch: u16 = 41;
    pub const pilates_roll_up_with_ball: u16 = 42;
    pub const weighted_pilates_roll_up_with_ball: u16 = 43;
    pub const raised_legs_crunch: u16 = 44;
    pub const weighted_raised_legs_crunch: u16 = 45;
    pub const reverse_crunch: u16 = 46;
    pub const weighted_reverse_crunch: u16 = 47;
    pub const reverse_crunch_on_a_bench: u16 = 48;
    pub const weighted_reverse_crunch_on_a_bench: u16 = 49;
    pub const reverse_curl_and_lift: u16 = 50;
    pub const weighted_reverse_curl_and_lift: u16 = 51;
    pub const rotational_lift: u16 = 52;
    pub const weighted_rotational_lift: u16 = 53;
    pub const seated_alternating_reverse_crunch: u16 = 54;
    pub const weighted_seated_alternating_reverse_crunch: u16 = 55;
    pub const seated_leg_u: u16 = 56;
    pub const weighted_seated_leg_u: u16 = 57;
    pub const side_to_side_crunch_and_weave: u16 = 58;
    pub const weighted_side_to_side_crunch_and_weave: u16 = 59;
    pub const single_leg_reverse_crunch: u16 = 60;
    pub const weighted_single_leg_reverse_crunch: u16 = 61;
    pub const skater_crunch_cross: u16 = 62;
    pub const weighted_skater_crunch_cross: u16 = 63;
    pub const standing_cable_crunch: u16 = 64;
    pub const standing_side_crunch: u16 = 65;
    pub const step_climb: u16 = 66;
    pub const weighted_step_climb: u16 = 67;
    pub const swiss_ball_crunch: u16 = 68;
    pub const swiss_ball_reverse_crunch: u16 = 69;
    pub const weighted_swiss_ball_reverse_crunch: u16 = 70;
    pub const swiss_ball_russian_twist: u16 = 71;
    pub const weighted_swiss_ball_russian_twist: u16 = 72;
    pub const swiss_ball_side_crunch: u16 = 73;
    pub const weighted_swiss_ball_side_crunch: u16 = 74;
    pub const thoracic_crunches_on_foam_roller: u16 = 75;
    pub const weighted_thoracic_crunches_on_foam_roller: u16 = 76;
    pub const triceps_crunch: u16 = 77;
    pub const weighted_bicycle_crunch: u16 = 78;
    pub const weighted_crunch: u16 = 79;
    pub const weighted_swiss_ball_crunch: u16 = 80;
    pub const toes_to_bar: u16 = 81;
    pub const weighted_toes_to_bar: u16 = 82;
    pub const crunch: u16 = 83;
    pub const straight_leg_crunch_with_ball: u16 = 84;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const CurlExerciseName = struct {
    pub const alternating_dumbbell_biceps_curl: u16 = 0;
    pub const alternating_dumbbell_biceps_curl_on_swiss_ball: u16 = 1;
    pub const alternating_incline_dumbbell_biceps_curl: u16 = 2;
    pub const barbell_biceps_curl: u16 = 3;
    pub const barbell_reverse_wrist_curl: u16 = 4;
    pub const barbell_wrist_curl: u16 = 5;
    pub const behind_the_back_barbell_reverse_wrist_curl: u16 = 6;
    pub const behind_the_back_one_arm_cable_curl: u16 = 7;
    pub const cable_biceps_curl: u16 = 8;
    pub const cable_hammer_curl: u16 = 9;
    pub const cheating_barbell_biceps_curl: u16 = 10;
    pub const close_grip_ez_bar_biceps_curl: u16 = 11;
    pub const cross_body_dumbbell_hammer_curl: u16 = 12;
    pub const dead_hang_biceps_curl: u16 = 13;
    pub const decline_hammer_curl: u16 = 14;
    pub const dumbbell_biceps_curl_with_static_hold: u16 = 15;
    pub const dumbbell_hammer_curl: u16 = 16;
    pub const dumbbell_reverse_wrist_curl: u16 = 17;
    pub const dumbbell_wrist_curl: u16 = 18;
    pub const ez_bar_preacher_curl: u16 = 19;
    pub const forward_bend_biceps_curl: u16 = 20;
    pub const hammer_curl_to_press: u16 = 21;
    pub const incline_dumbbell_biceps_curl: u16 = 22;
    pub const incline_offset_thumb_dumbbell_curl: u16 = 23;
    pub const kettlebell_biceps_curl: u16 = 24;
    pub const lying_concentration_cable_curl: u16 = 25;
    pub const one_arm_preacher_curl: u16 = 26;
    pub const plate_pinch_curl: u16 = 27;
    pub const preacher_curl_with_cable: u16 = 28;
    pub const reverse_ez_bar_curl: u16 = 29;
    pub const reverse_grip_wrist_curl: u16 = 30;
    pub const reverse_grip_barbell_biceps_curl: u16 = 31;
    pub const seated_alternating_dumbbell_biceps_curl: u16 = 32;
    pub const seated_dumbbell_biceps_curl: u16 = 33;
    pub const seated_reverse_dumbbell_curl: u16 = 34;
    pub const split_stance_offset_pinky_dumbbell_curl: u16 = 35;
    pub const standing_alternating_dumbbell_curls: u16 = 36;
    pub const standing_dumbbell_biceps_curl: u16 = 37;
    pub const standing_ez_bar_biceps_curl: u16 = 38;
    pub const static_curl: u16 = 39;
    pub const swiss_ball_dumbbell_overhead_triceps_extension: u16 = 40;
    pub const swiss_ball_ez_bar_preacher_curl: u16 = 41;
    pub const twisting_standing_dumbbell_biceps_curl: u16 = 42;
    pub const wide_grip_ez_bar_biceps_curl: u16 = 43;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const DeadliftExerciseName = struct {
    pub const barbell_deadlift: u16 = 0;
    pub const barbell_straight_leg_deadlift: u16 = 1;
    pub const dumbbell_deadlift: u16 = 2;
    pub const dumbbell_single_leg_deadlift_to_row: u16 = 3;
    pub const dumbbell_straight_leg_deadlift: u16 = 4;
    pub const kettlebell_floor_to_shelf: u16 = 5;
    pub const one_arm_one_leg_deadlift: u16 = 6;
    pub const rack_pull: u16 = 7;
    pub const rotational_dumbbell_straight_leg_deadlift: u16 = 8;
    pub const single_arm_deadlift: u16 = 9;
    pub const single_leg_barbell_deadlift: u16 = 10;
    pub const single_leg_barbell_straight_leg_deadlift: u16 = 11;
    pub const single_leg_deadlift_with_barbell: u16 = 12;
    pub const single_leg_rdl_circuit: u16 = 13;
    pub const single_leg_romanian_deadlift_with_dumbbell: u16 = 14;
    pub const sumo_deadlift: u16 = 15;
    pub const sumo_deadlift_high_pull: u16 = 16;
    pub const trap_bar_deadlift: u16 = 17;
    pub const wide_grip_barbell_deadlift: u16 = 18;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const FlyeExerciseName = struct {
    pub const cable_crossover: u16 = 0;
    pub const decline_dumbbell_flye: u16 = 1;
    pub const dumbbell_flye: u16 = 2;
    pub const incline_dumbbell_flye: u16 = 3;
    pub const kettlebell_flye: u16 = 4;
    pub const kneeling_rear_flye: u16 = 5;
    pub const single_arm_standing_cable_reverse_flye: u16 = 6;
    pub const swiss_ball_dumbbell_flye: u16 = 7;
    pub const arm_rotations: u16 = 8;
    pub const hug_a_tree: u16 = 9;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const HipRaiseExerciseName = struct {
    pub const barbell_hip_thrust_on_floor: u16 = 0;
    pub const barbell_hip_thrust_with_bench: u16 = 1;
    pub const bent_knee_swiss_ball_reverse_hip_raise: u16 = 2;
    pub const weighted_bent_knee_swiss_ball_reverse_hip_raise: u16 = 3;
    pub const bridge_with_leg_extension: u16 = 4;
    pub const weighted_bridge_with_leg_extension: u16 = 5;
    pub const clam_bridge: u16 = 6;
    pub const front_kick_tabletop: u16 = 7;
    pub const weighted_front_kick_tabletop: u16 = 8;
    pub const hip_extension_and_cross: u16 = 9;
    pub const weighted_hip_extension_and_cross: u16 = 10;
    pub const hip_raise: u16 = 11;
    pub const weighted_hip_raise: u16 = 12;
    pub const hip_raise_with_feet_on_swiss_ball: u16 = 13;
    pub const weighted_hip_raise_with_feet_on_swiss_ball: u16 = 14;
    pub const hip_raise_with_head_on_bosu_ball: u16 = 15;
    pub const weighted_hip_raise_with_head_on_bosu_ball: u16 = 16;
    pub const hip_raise_with_head_on_swiss_ball: u16 = 17;
    pub const weighted_hip_raise_with_head_on_swiss_ball: u16 = 18;
    pub const hip_raise_with_knee_squeeze: u16 = 19;
    pub const weighted_hip_raise_with_knee_squeeze: u16 = 20;
    pub const incline_rear_leg_extension: u16 = 21;
    pub const weighted_incline_rear_leg_extension: u16 = 22;
    pub const kettlebell_swing: u16 = 23;
    pub const marching_hip_raise: u16 = 24;
    pub const weighted_marching_hip_raise: u16 = 25;
    pub const marching_hip_raise_with_feet_on_a_swiss_ball: u16 = 26;
    pub const weighted_marching_hip_raise_with_feet_on_a_swiss_ball: u16 = 27;
    pub const reverse_hip_raise: u16 = 28;
    pub const weighted_reverse_hip_raise: u16 = 29;
    pub const single_leg_hip_raise: u16 = 30;
    pub const weighted_single_leg_hip_raise: u16 = 31;
    pub const single_leg_hip_raise_with_foot_on_bench: u16 = 32;
    pub const weighted_single_leg_hip_raise_with_foot_on_bench: u16 = 33;
    pub const single_leg_hip_raise_with_foot_on_bosu_ball: u16 = 34;
    pub const weighted_single_leg_hip_raise_with_foot_on_bosu_ball: u16 = 35;
    pub const single_leg_hip_raise_with_foot_on_foam_roller: u16 = 36;
    pub const weighted_single_leg_hip_raise_with_foot_on_foam_roller: u16 = 37;
    pub const single_leg_hip_raise_with_foot_on_medicine_ball: u16 = 38;
    pub const weighted_single_leg_hip_raise_with_foot_on_medicine_ball: u16 = 39;
    pub const single_leg_hip_raise_with_head_on_bosu_ball: u16 = 40;
    pub const weighted_single_leg_hip_raise_with_head_on_bosu_ball: u16 = 41;
    pub const weighted_clam_bridge: u16 = 42;
    pub const single_leg_swiss_ball_hip_raise_and_leg_curl: u16 = 43;
    pub const clams: u16 = 44;
    pub const inner_thigh_circles: u16 = 45;
    pub const inner_thigh_side_lift: u16 = 46;
    pub const leg_circles: u16 = 47;
    pub const leg_lift: u16 = 48;
    pub const leg_lift_in_external_rotation: u16 = 49;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const HipStabilityExerciseName = struct {
    pub const band_side_lying_leg_raise: u16 = 0;
    pub const dead_bug: u16 = 1;
    pub const weighted_dead_bug: u16 = 2;
    pub const external_hip_raise: u16 = 3;
    pub const weighted_external_hip_raise: u16 = 4;
    pub const fire_hydrant_kicks: u16 = 5;
    pub const weighted_fire_hydrant_kicks: u16 = 6;
    pub const hip_circles: u16 = 7;
    pub const weighted_hip_circles: u16 = 8;
    pub const inner_thigh_lift: u16 = 9;
    pub const weighted_inner_thigh_lift: u16 = 10;
    pub const lateral_walks_with_band_at_ankles: u16 = 11;
    pub const pretzel_side_kick: u16 = 12;
    pub const weighted_pretzel_side_kick: u16 = 13;
    pub const prone_hip_internal_rotation: u16 = 14;
    pub const weighted_prone_hip_internal_rotation: u16 = 15;
    pub const quadruped: u16 = 16;
    pub const quadruped_hip_extension: u16 = 17;
    pub const weighted_quadruped_hip_extension: u16 = 18;
    pub const quadruped_with_leg_lift: u16 = 19;
    pub const weighted_quadruped_with_leg_lift: u16 = 20;
    pub const side_lying_leg_raise: u16 = 21;
    pub const weighted_side_lying_leg_raise: u16 = 22;
    pub const sliding_hip_adduction: u16 = 23;
    pub const weighted_sliding_hip_adduction: u16 = 24;
    pub const standing_adduction: u16 = 25;
    pub const weighted_standing_adduction: u16 = 26;
    pub const standing_cable_hip_abduction: u16 = 27;
    pub const standing_hip_abduction: u16 = 28;
    pub const weighted_standing_hip_abduction: u16 = 29;
    pub const standing_rear_leg_raise: u16 = 30;
    pub const weighted_standing_rear_leg_raise: u16 = 31;
    pub const supine_hip_internal_rotation: u16 = 32;
    pub const weighted_supine_hip_internal_rotation: u16 = 33;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const HipSwingExerciseName = struct {
    pub const single_arm_kettlebell_swing: u16 = 0;
    pub const single_arm_dumbbell_swing: u16 = 1;
    pub const step_out_swing: u16 = 2;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const HyperextensionExerciseName = struct {
    pub const back_extension_with_opposite_arm_and_leg_reach: u16 = 0;
    pub const weighted_back_extension_with_opposite_arm_and_leg_reach: u16 = 1;
    pub const base_rotations: u16 = 2;
    pub const weighted_base_rotations: u16 = 3;
    pub const bent_knee_reverse_hyperextension: u16 = 4;
    pub const weighted_bent_knee_reverse_hyperextension: u16 = 5;
    pub const hollow_hold_and_roll: u16 = 6;
    pub const weighted_hollow_hold_and_roll: u16 = 7;
    pub const kicks: u16 = 8;
    pub const weighted_kicks: u16 = 9;
    pub const knee_raises: u16 = 10;
    pub const weighted_knee_raises: u16 = 11;
    pub const kneeling_superman: u16 = 12;
    pub const weighted_kneeling_superman: u16 = 13;
    pub const lat_pull_down_with_row: u16 = 14;
    pub const medicine_ball_deadlift_to_reach: u16 = 15;
    pub const one_arm_one_leg_row: u16 = 16;
    pub const one_arm_row_with_band: u16 = 17;
    pub const overhead_lunge_with_medicine_ball: u16 = 18;
    pub const plank_knee_tucks: u16 = 19;
    pub const weighted_plank_knee_tucks: u16 = 20;
    pub const side_step: u16 = 21;
    pub const weighted_side_step: u16 = 22;
    pub const single_leg_back_extension: u16 = 23;
    pub const weighted_single_leg_back_extension: u16 = 24;
    pub const spine_extension: u16 = 25;
    pub const weighted_spine_extension: u16 = 26;
    pub const static_back_extension: u16 = 27;
    pub const weighted_static_back_extension: u16 = 28;
    pub const superman_from_floor: u16 = 29;
    pub const weighted_superman_from_floor: u16 = 30;
    pub const swiss_ball_back_extension: u16 = 31;
    pub const weighted_swiss_ball_back_extension: u16 = 32;
    pub const swiss_ball_hyperextension: u16 = 33;
    pub const weighted_swiss_ball_hyperextension: u16 = 34;
    pub const swiss_ball_opposite_arm_and_leg_lift: u16 = 35;
    pub const weighted_swiss_ball_opposite_arm_and_leg_lift: u16 = 36;
    pub const superman_on_swiss_ball: u16 = 37;
    pub const cobra: u16 = 38;
    pub const supine_floor_barre: u16 = 39;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const LateralRaiseExerciseName = struct {
    pub const _45_degree_cable_external_rotation: u16 = 0;
    pub const alternating_lateral_raise_with_static_hold: u16 = 1;
    pub const bar_muscle_up: u16 = 2;
    pub const bent_over_lateral_raise: u16 = 3;
    pub const cable_diagonal_raise: u16 = 4;
    pub const cable_front_raise: u16 = 5;
    pub const calorie_row: u16 = 6;
    pub const combo_shoulder_raise: u16 = 7;
    pub const dumbbell_diagonal_raise: u16 = 8;
    pub const dumbbell_v_raise: u16 = 9;
    pub const front_raise: u16 = 10;
    pub const leaning_dumbbell_lateral_raise: u16 = 11;
    pub const lying_dumbbell_raise: u16 = 12;
    pub const muscle_up: u16 = 13;
    pub const one_arm_cable_lateral_raise: u16 = 14;
    pub const overhand_grip_rear_lateral_raise: u16 = 15;
    pub const plate_raises: u16 = 16;
    pub const ring_dip: u16 = 17;
    pub const weighted_ring_dip: u16 = 18;
    pub const ring_muscle_up: u16 = 19;
    pub const weighted_ring_muscle_up: u16 = 20;
    pub const rope_climb: u16 = 21;
    pub const weighted_rope_climb: u16 = 22;
    pub const scaption: u16 = 23;
    pub const seated_lateral_raise: u16 = 24;
    pub const seated_rear_lateral_raise: u16 = 25;
    pub const side_lying_lateral_raise: u16 = 26;
    pub const standing_lift: u16 = 27;
    pub const suspended_row: u16 = 28;
    pub const underhand_grip_rear_lateral_raise: u16 = 29;
    pub const wall_slide: u16 = 30;
    pub const weighted_wall_slide: u16 = 31;
    pub const arm_circles: u16 = 32;
    pub const shaving_the_head: u16 = 33;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const LegCurlExerciseName = struct {
    pub const leg_curl: u16 = 0;
    pub const weighted_leg_curl: u16 = 1;
    pub const good_morning: u16 = 2;
    pub const seated_barbell_good_morning: u16 = 3;
    pub const single_leg_barbell_good_morning: u16 = 4;
    pub const single_leg_sliding_leg_curl: u16 = 5;
    pub const sliding_leg_curl: u16 = 6;
    pub const split_barbell_good_morning: u16 = 7;
    pub const split_stance_extension: u16 = 8;
    pub const staggered_stance_good_morning: u16 = 9;
    pub const swiss_ball_hip_raise_and_leg_curl: u16 = 10;
    pub const zercher_good_morning: u16 = 11;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const LegRaiseExerciseName = struct {
    pub const hanging_knee_raise: u16 = 0;
    pub const hanging_leg_raise: u16 = 1;
    pub const weighted_hanging_leg_raise: u16 = 2;
    pub const hanging_single_leg_raise: u16 = 3;
    pub const weighted_hanging_single_leg_raise: u16 = 4;
    pub const kettlebell_leg_raises: u16 = 5;
    pub const leg_lowering_drill: u16 = 6;
    pub const weighted_leg_lowering_drill: u16 = 7;
    pub const lying_straight_leg_raise: u16 = 8;
    pub const weighted_lying_straight_leg_raise: u16 = 9;
    pub const medicine_ball_leg_drops: u16 = 10;
    pub const quadruped_leg_raise: u16 = 11;
    pub const weighted_quadruped_leg_raise: u16 = 12;
    pub const reverse_leg_raise: u16 = 13;
    pub const weighted_reverse_leg_raise: u16 = 14;
    pub const reverse_leg_raise_on_swiss_ball: u16 = 15;
    pub const weighted_reverse_leg_raise_on_swiss_ball: u16 = 16;
    pub const single_leg_lowering_drill: u16 = 17;
    pub const weighted_single_leg_lowering_drill: u16 = 18;
    pub const weighted_hanging_knee_raise: u16 = 19;
    pub const lateral_stepover: u16 = 20;
    pub const weighted_lateral_stepover: u16 = 21;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const LungeExerciseName = struct {
    pub const overhead_lunge: u16 = 0;
    pub const lunge_matrix: u16 = 1;
    pub const weighted_lunge_matrix: u16 = 2;
    pub const alternating_barbell_forward_lunge: u16 = 3;
    pub const alternating_dumbbell_lunge_with_reach: u16 = 4;
    pub const back_foot_elevated_dumbbell_split_squat: u16 = 5;
    pub const barbell_box_lunge: u16 = 6;
    pub const barbell_bulgarian_split_squat: u16 = 7;
    pub const barbell_crossover_lunge: u16 = 8;
    pub const barbell_front_split_squat: u16 = 9;
    pub const barbell_lunge: u16 = 10;
    pub const barbell_reverse_lunge: u16 = 11;
    pub const barbell_side_lunge: u16 = 12;
    pub const barbell_split_squat: u16 = 13;
    pub const core_control_rear_lunge: u16 = 14;
    pub const diagonal_lunge: u16 = 15;
    pub const drop_lunge: u16 = 16;
    pub const dumbbell_box_lunge: u16 = 17;
    pub const dumbbell_bulgarian_split_squat: u16 = 18;
    pub const dumbbell_crossover_lunge: u16 = 19;
    pub const dumbbell_diagonal_lunge: u16 = 20;
    pub const dumbbell_lunge: u16 = 21;
    pub const dumbbell_lunge_and_rotation: u16 = 22;
    pub const dumbbell_overhead_bulgarian_split_squat: u16 = 23;
    pub const dumbbell_reverse_lunge_to_high_knee_and_press: u16 = 24;
    pub const dumbbell_side_lunge: u16 = 25;
    pub const elevated_front_foot_barbell_split_squat: u16 = 26;
    pub const front_foot_elevated_dumbbell_split_squat: u16 = 27;
    pub const gunslinger_lunge: u16 = 28;
    pub const lawnmower_lunge: u16 = 29;
    pub const low_lunge_with_isometric_adduction: u16 = 30;
    pub const low_side_to_side_lunge: u16 = 31;
    pub const lunge: u16 = 32;
    pub const weighted_lunge: u16 = 33;
    pub const lunge_with_arm_reach: u16 = 34;
    pub const lunge_with_diagonal_reach: u16 = 35;
    pub const lunge_with_side_bend: u16 = 36;
    pub const offset_dumbbell_lunge: u16 = 37;
    pub const offset_dumbbell_reverse_lunge: u16 = 38;
    pub const overhead_bulgarian_split_squat: u16 = 39;
    pub const overhead_dumbbell_reverse_lunge: u16 = 40;
    pub const overhead_dumbbell_split_squat: u16 = 41;
    pub const overhead_lunge_with_rotation: u16 = 42;
    pub const reverse_barbell_box_lunge: u16 = 43;
    pub const reverse_box_lunge: u16 = 44;
    pub const reverse_dumbbell_box_lunge: u16 = 45;
    pub const reverse_dumbbell_crossover_lunge: u16 = 46;
    pub const reverse_dumbbell_diagonal_lunge: u16 = 47;
    pub const reverse_lunge_with_reach_back: u16 = 48;
    pub const weighted_reverse_lunge_with_reach_back: u16 = 49;
    pub const reverse_lunge_with_twist_and_overhead_reach: u16 = 50;
    pub const weighted_reverse_lunge_with_twist_and_overhead_reach: u16 = 51;
    pub const reverse_sliding_box_lunge: u16 = 52;
    pub const weighted_reverse_sliding_box_lunge: u16 = 53;
    pub const reverse_sliding_lunge: u16 = 54;
    pub const weighted_reverse_sliding_lunge: u16 = 55;
    pub const runners_lunge_to_balance: u16 = 56;
    pub const weighted_runners_lunge_to_balance: u16 = 57;
    pub const shifting_side_lunge: u16 = 58;
    pub const side_and_crossover_lunge: u16 = 59;
    pub const weighted_side_and_crossover_lunge: u16 = 60;
    pub const side_lunge: u16 = 61;
    pub const weighted_side_lunge: u16 = 62;
    pub const side_lunge_and_press: u16 = 63;
    pub const side_lunge_jump_off: u16 = 64;
    pub const side_lunge_sweep: u16 = 65;
    pub const weighted_side_lunge_sweep: u16 = 66;
    pub const side_lunge_to_crossover_tap: u16 = 67;
    pub const weighted_side_lunge_to_crossover_tap: u16 = 68;
    pub const side_to_side_lunge_chops: u16 = 69;
    pub const weighted_side_to_side_lunge_chops: u16 = 70;
    pub const siff_jump_lunge: u16 = 71;
    pub const weighted_siff_jump_lunge: u16 = 72;
    pub const single_arm_reverse_lunge_and_press: u16 = 73;
    pub const sliding_lateral_lunge: u16 = 74;
    pub const weighted_sliding_lateral_lunge: u16 = 75;
    pub const walking_barbell_lunge: u16 = 76;
    pub const walking_dumbbell_lunge: u16 = 77;
    pub const walking_lunge: u16 = 78;
    pub const weighted_walking_lunge: u16 = 79;
    pub const wide_grip_overhead_barbell_split_squat: u16 = 80;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const OlympicLiftExerciseName = struct {
    pub const barbell_hang_power_clean: u16 = 0;
    pub const barbell_hang_squat_clean: u16 = 1;
    pub const barbell_power_clean: u16 = 2;
    pub const barbell_power_snatch: u16 = 3;
    pub const barbell_squat_clean: u16 = 4;
    pub const clean_and_jerk: u16 = 5;
    pub const barbell_hang_power_snatch: u16 = 6;
    pub const barbell_hang_pull: u16 = 7;
    pub const barbell_high_pull: u16 = 8;
    pub const barbell_snatch: u16 = 9;
    pub const barbell_split_jerk: u16 = 10;
    pub const clean: u16 = 11;
    pub const dumbbell_clean: u16 = 12;
    pub const dumbbell_hang_pull: u16 = 13;
    pub const one_hand_dumbbell_split_snatch: u16 = 14;
    pub const push_jerk: u16 = 15;
    pub const single_arm_dumbbell_snatch: u16 = 16;
    pub const single_arm_hang_snatch: u16 = 17;
    pub const single_arm_kettlebell_snatch: u16 = 18;
    pub const split_jerk: u16 = 19;
    pub const squat_clean_and_jerk: u16 = 20;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const PlankExerciseName = struct {
    pub const _45_degree_plank: u16 = 0;
    pub const weighted_45_degree_plank: u16 = 1;
    pub const _90_degree_static_hold: u16 = 2;
    pub const weighted_90_degree_static_hold: u16 = 3;
    pub const bear_crawl: u16 = 4;
    pub const weighted_bear_crawl: u16 = 5;
    pub const cross_body_mountain_climber: u16 = 6;
    pub const weighted_cross_body_mountain_climber: u16 = 7;
    pub const elbow_plank_pike_jacks: u16 = 8;
    pub const weighted_elbow_plank_pike_jacks: u16 = 9;
    pub const elevated_feet_plank: u16 = 10;
    pub const weighted_elevated_feet_plank: u16 = 11;
    pub const elevator_abs: u16 = 12;
    pub const weighted_elevator_abs: u16 = 13;
    pub const extended_plank: u16 = 14;
    pub const weighted_extended_plank: u16 = 15;
    pub const full_plank_passe_twist: u16 = 16;
    pub const weighted_full_plank_passe_twist: u16 = 17;
    pub const inching_elbow_plank: u16 = 18;
    pub const weighted_inching_elbow_plank: u16 = 19;
    pub const inchworm_to_side_plank: u16 = 20;
    pub const weighted_inchworm_to_side_plank: u16 = 21;
    pub const kneeling_plank: u16 = 22;
    pub const weighted_kneeling_plank: u16 = 23;
    pub const kneeling_side_plank_with_leg_lift: u16 = 24;
    pub const weighted_kneeling_side_plank_with_leg_lift: u16 = 25;
    pub const lateral_roll: u16 = 26;
    pub const weighted_lateral_roll: u16 = 27;
    pub const lying_reverse_plank: u16 = 28;
    pub const weighted_lying_reverse_plank: u16 = 29;
    pub const medicine_ball_mountain_climber: u16 = 30;
    pub const weighted_medicine_ball_mountain_climber: u16 = 31;
    pub const modified_mountain_climber_and_extension: u16 = 32;
    pub const weighted_modified_mountain_climber_and_extension: u16 = 33;
    pub const mountain_climber: u16 = 34;
    pub const weighted_mountain_climber: u16 = 35;
    pub const mountain_climber_on_sliding_discs: u16 = 36;
    pub const weighted_mountain_climber_on_sliding_discs: u16 = 37;
    pub const mountain_climber_with_feet_on_bosu_ball: u16 = 38;
    pub const weighted_mountain_climber_with_feet_on_bosu_ball: u16 = 39;
    pub const mountain_climber_with_hands_on_bench: u16 = 40;
    pub const mountain_climber_with_hands_on_swiss_ball: u16 = 41;
    pub const weighted_mountain_climber_with_hands_on_swiss_ball: u16 = 42;
    pub const plank: u16 = 43;
    pub const plank_jacks_with_feet_on_sliding_discs: u16 = 44;
    pub const weighted_plank_jacks_with_feet_on_sliding_discs: u16 = 45;
    pub const plank_knee_twist: u16 = 46;
    pub const weighted_plank_knee_twist: u16 = 47;
    pub const plank_pike_jumps: u16 = 48;
    pub const weighted_plank_pike_jumps: u16 = 49;
    pub const plank_pikes: u16 = 50;
    pub const weighted_plank_pikes: u16 = 51;
    pub const plank_to_stand_up: u16 = 52;
    pub const weighted_plank_to_stand_up: u16 = 53;
    pub const plank_with_arm_raise: u16 = 54;
    pub const weighted_plank_with_arm_raise: u16 = 55;
    pub const plank_with_knee_to_elbow: u16 = 56;
    pub const weighted_plank_with_knee_to_elbow: u16 = 57;
    pub const plank_with_oblique_crunch: u16 = 58;
    pub const weighted_plank_with_oblique_crunch: u16 = 59;
    pub const plyometric_side_plank: u16 = 60;
    pub const weighted_plyometric_side_plank: u16 = 61;
    pub const rolling_side_plank: u16 = 62;
    pub const weighted_rolling_side_plank: u16 = 63;
    pub const side_kick_plank: u16 = 64;
    pub const weighted_side_kick_plank: u16 = 65;
    pub const side_plank: u16 = 66;
    pub const weighted_side_plank: u16 = 67;
    pub const side_plank_and_row: u16 = 68;
    pub const weighted_side_plank_and_row: u16 = 69;
    pub const side_plank_lift: u16 = 70;
    pub const weighted_side_plank_lift: u16 = 71;
    pub const side_plank_with_elbow_on_bosu_ball: u16 = 72;
    pub const weighted_side_plank_with_elbow_on_bosu_ball: u16 = 73;
    pub const side_plank_with_feet_on_bench: u16 = 74;
    pub const weighted_side_plank_with_feet_on_bench: u16 = 75;
    pub const side_plank_with_knee_circle: u16 = 76;
    pub const weighted_side_plank_with_knee_circle: u16 = 77;
    pub const side_plank_with_knee_tuck: u16 = 78;
    pub const weighted_side_plank_with_knee_tuck: u16 = 79;
    pub const side_plank_with_leg_lift: u16 = 80;
    pub const weighted_side_plank_with_leg_lift: u16 = 81;
    pub const side_plank_with_reach_under: u16 = 82;
    pub const weighted_side_plank_with_reach_under: u16 = 83;
    pub const single_leg_elevated_feet_plank: u16 = 84;
    pub const weighted_single_leg_elevated_feet_plank: u16 = 85;
    pub const single_leg_flex_and_extend: u16 = 86;
    pub const weighted_single_leg_flex_and_extend: u16 = 87;
    pub const single_leg_side_plank: u16 = 88;
    pub const weighted_single_leg_side_plank: u16 = 89;
    pub const spiderman_plank: u16 = 90;
    pub const weighted_spiderman_plank: u16 = 91;
    pub const straight_arm_plank: u16 = 92;
    pub const weighted_straight_arm_plank: u16 = 93;
    pub const straight_arm_plank_with_shoulder_touch: u16 = 94;
    pub const weighted_straight_arm_plank_with_shoulder_touch: u16 = 95;
    pub const swiss_ball_plank: u16 = 96;
    pub const weighted_swiss_ball_plank: u16 = 97;
    pub const swiss_ball_plank_leg_lift: u16 = 98;
    pub const weighted_swiss_ball_plank_leg_lift: u16 = 99;
    pub const swiss_ball_plank_leg_lift_and_hold: u16 = 100;
    pub const swiss_ball_plank_with_feet_on_bench: u16 = 101;
    pub const weighted_swiss_ball_plank_with_feet_on_bench: u16 = 102;
    pub const swiss_ball_prone_jackknife: u16 = 103;
    pub const weighted_swiss_ball_prone_jackknife: u16 = 104;
    pub const swiss_ball_side_plank: u16 = 105;
    pub const weighted_swiss_ball_side_plank: u16 = 106;
    pub const three_way_plank: u16 = 107;
    pub const weighted_three_way_plank: u16 = 108;
    pub const towel_plank_and_knee_in: u16 = 109;
    pub const weighted_towel_plank_and_knee_in: u16 = 110;
    pub const t_stabilization: u16 = 111;
    pub const weighted_t_stabilization: u16 = 112;
    pub const turkish_get_up_to_side_plank: u16 = 113;
    pub const weighted_turkish_get_up_to_side_plank: u16 = 114;
    pub const two_point_plank: u16 = 115;
    pub const weighted_two_point_plank: u16 = 116;
    pub const weighted_plank: u16 = 117;
    pub const wide_stance_plank_with_diagonal_arm_lift: u16 = 118;
    pub const weighted_wide_stance_plank_with_diagonal_arm_lift: u16 = 119;
    pub const wide_stance_plank_with_diagonal_leg_lift: u16 = 120;
    pub const weighted_wide_stance_plank_with_diagonal_leg_lift: u16 = 121;
    pub const wide_stance_plank_with_leg_lift: u16 = 122;
    pub const weighted_wide_stance_plank_with_leg_lift: u16 = 123;
    pub const wide_stance_plank_with_opposite_arm_and_leg_lift: u16 = 124;
    pub const weighted_mountain_climber_with_hands_on_bench: u16 = 125;
    pub const weighted_swiss_ball_plank_leg_lift_and_hold: u16 = 126;
    pub const weighted_wide_stance_plank_with_opposite_arm_and_leg_lift: u16 = 127;
    pub const plank_with_feet_on_swiss_ball: u16 = 128;
    pub const side_plank_to_plank_with_reach_under: u16 = 129;
    pub const bridge_with_glute_lower_lift: u16 = 130;
    pub const bridge_one_leg_bridge: u16 = 131;
    pub const plank_with_arm_variations: u16 = 132;
    pub const plank_with_leg_lift: u16 = 133;
    pub const reverse_plank_with_leg_pull: u16 = 134;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const PlyoExerciseName = struct {
    pub const alternating_jump_lunge: u16 = 0;
    pub const weighted_alternating_jump_lunge: u16 = 1;
    pub const barbell_jump_squat: u16 = 2;
    pub const body_weight_jump_squat: u16 = 3;
    pub const weighted_jump_squat: u16 = 4;
    pub const cross_knee_strike: u16 = 5;
    pub const weighted_cross_knee_strike: u16 = 6;
    pub const depth_jump: u16 = 7;
    pub const weighted_depth_jump: u16 = 8;
    pub const dumbbell_jump_squat: u16 = 9;
    pub const dumbbell_split_jump: u16 = 10;
    pub const front_knee_strike: u16 = 11;
    pub const weighted_front_knee_strike: u16 = 12;
    pub const high_box_jump: u16 = 13;
    pub const weighted_high_box_jump: u16 = 14;
    pub const isometric_explosive_body_weight_jump_squat: u16 = 15;
    pub const weighted_isometric_explosive_jump_squat: u16 = 16;
    pub const lateral_leap_and_hop: u16 = 17;
    pub const weighted_lateral_leap_and_hop: u16 = 18;
    pub const lateral_plyo_squats: u16 = 19;
    pub const weighted_lateral_plyo_squats: u16 = 20;
    pub const lateral_slide: u16 = 21;
    pub const weighted_lateral_slide: u16 = 22;
    pub const medicine_ball_overhead_throws: u16 = 23;
    pub const medicine_ball_side_throw: u16 = 24;
    pub const medicine_ball_slam: u16 = 25;
    pub const side_to_side_medicine_ball_throws: u16 = 26;
    pub const side_to_side_shuffle_jump: u16 = 27;
    pub const weighted_side_to_side_shuffle_jump: u16 = 28;
    pub const squat_jump_onto_box: u16 = 29;
    pub const weighted_squat_jump_onto_box: u16 = 30;
    pub const squat_jumps_in_and_out: u16 = 31;
    pub const weighted_squat_jumps_in_and_out: u16 = 32;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const PullUpExerciseName = struct {
    pub const banded_pull_ups: u16 = 0;
    pub const _30_degree_lat_pulldown: u16 = 1;
    pub const band_assisted_chin_up: u16 = 2;
    pub const close_grip_chin_up: u16 = 3;
    pub const weighted_close_grip_chin_up: u16 = 4;
    pub const close_grip_lat_pulldown: u16 = 5;
    pub const crossover_chin_up: u16 = 6;
    pub const weighted_crossover_chin_up: u16 = 7;
    pub const ez_bar_pullover: u16 = 8;
    pub const hanging_hurdle: u16 = 9;
    pub const weighted_hanging_hurdle: u16 = 10;
    pub const kneeling_lat_pulldown: u16 = 11;
    pub const kneeling_underhand_grip_lat_pulldown: u16 = 12;
    pub const lat_pulldown: u16 = 13;
    pub const mixed_grip_chin_up: u16 = 14;
    pub const weighted_mixed_grip_chin_up: u16 = 15;
    pub const mixed_grip_pull_up: u16 = 16;
    pub const weighted_mixed_grip_pull_up: u16 = 17;
    pub const reverse_grip_pulldown: u16 = 18;
    pub const standing_cable_pullover: u16 = 19;
    pub const straight_arm_pulldown: u16 = 20;
    pub const swiss_ball_ez_bar_pullover: u16 = 21;
    pub const towel_pull_up: u16 = 22;
    pub const weighted_towel_pull_up: u16 = 23;
    pub const weighted_pull_up: u16 = 24;
    pub const wide_grip_lat_pulldown: u16 = 25;
    pub const wide_grip_pull_up: u16 = 26;
    pub const weighted_wide_grip_pull_up: u16 = 27;
    pub const burpee_pull_up: u16 = 28;
    pub const weighted_burpee_pull_up: u16 = 29;
    pub const jumping_pull_ups: u16 = 30;
    pub const weighted_jumping_pull_ups: u16 = 31;
    pub const kipping_pull_up: u16 = 32;
    pub const weighted_kipping_pull_up: u16 = 33;
    pub const l_pull_up: u16 = 34;
    pub const weighted_l_pull_up: u16 = 35;
    pub const suspended_chin_up: u16 = 36;
    pub const weighted_suspended_chin_up: u16 = 37;
    pub const pull_up: u16 = 38;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const PushUpExerciseName = struct {
    pub const chest_press_with_band: u16 = 0;
    pub const alternating_staggered_push_up: u16 = 1;
    pub const weighted_alternating_staggered_push_up: u16 = 2;
    pub const alternating_hands_medicine_ball_push_up: u16 = 3;
    pub const weighted_alternating_hands_medicine_ball_push_up: u16 = 4;
    pub const bosu_ball_push_up: u16 = 5;
    pub const weighted_bosu_ball_push_up: u16 = 6;
    pub const clapping_push_up: u16 = 7;
    pub const weighted_clapping_push_up: u16 = 8;
    pub const close_grip_medicine_ball_push_up: u16 = 9;
    pub const weighted_close_grip_medicine_ball_push_up: u16 = 10;
    pub const close_hands_push_up: u16 = 11;
    pub const weighted_close_hands_push_up: u16 = 12;
    pub const decline_push_up: u16 = 13;
    pub const weighted_decline_push_up: u16 = 14;
    pub const diamond_push_up: u16 = 15;
    pub const weighted_diamond_push_up: u16 = 16;
    pub const explosive_crossover_push_up: u16 = 17;
    pub const weighted_explosive_crossover_push_up: u16 = 18;
    pub const explosive_push_up: u16 = 19;
    pub const weighted_explosive_push_up: u16 = 20;
    pub const feet_elevated_side_to_side_push_up: u16 = 21;
    pub const weighted_feet_elevated_side_to_side_push_up: u16 = 22;
    pub const hand_release_push_up: u16 = 23;
    pub const weighted_hand_release_push_up: u16 = 24;
    pub const handstand_push_up: u16 = 25;
    pub const weighted_handstand_push_up: u16 = 26;
    pub const incline_push_up: u16 = 27;
    pub const weighted_incline_push_up: u16 = 28;
    pub const isometric_explosive_push_up: u16 = 29;
    pub const weighted_isometric_explosive_push_up: u16 = 30;
    pub const judo_push_up: u16 = 31;
    pub const weighted_judo_push_up: u16 = 32;
    pub const kneeling_push_up: u16 = 33;
    pub const weighted_kneeling_push_up: u16 = 34;
    pub const medicine_ball_chest_pass: u16 = 35;
    pub const medicine_ball_push_up: u16 = 36;
    pub const weighted_medicine_ball_push_up: u16 = 37;
    pub const one_arm_push_up: u16 = 38;
    pub const weighted_one_arm_push_up: u16 = 39;
    pub const weighted_push_up: u16 = 40;
    pub const push_up_and_row: u16 = 41;
    pub const weighted_push_up_and_row: u16 = 42;
    pub const push_up_plus: u16 = 43;
    pub const weighted_push_up_plus: u16 = 44;
    pub const push_up_with_feet_on_swiss_ball: u16 = 45;
    pub const weighted_push_up_with_feet_on_swiss_ball: u16 = 46;
    pub const push_up_with_one_hand_on_medicine_ball: u16 = 47;
    pub const weighted_push_up_with_one_hand_on_medicine_ball: u16 = 48;
    pub const shoulder_push_up: u16 = 49;
    pub const weighted_shoulder_push_up: u16 = 50;
    pub const single_arm_medicine_ball_push_up: u16 = 51;
    pub const weighted_single_arm_medicine_ball_push_up: u16 = 52;
    pub const spiderman_push_up: u16 = 53;
    pub const weighted_spiderman_push_up: u16 = 54;
    pub const stacked_feet_push_up: u16 = 55;
    pub const weighted_stacked_feet_push_up: u16 = 56;
    pub const staggered_hands_push_up: u16 = 57;
    pub const weighted_staggered_hands_push_up: u16 = 58;
    pub const suspended_push_up: u16 = 59;
    pub const weighted_suspended_push_up: u16 = 60;
    pub const swiss_ball_push_up: u16 = 61;
    pub const weighted_swiss_ball_push_up: u16 = 62;
    pub const swiss_ball_push_up_plus: u16 = 63;
    pub const weighted_swiss_ball_push_up_plus: u16 = 64;
    pub const t_push_up: u16 = 65;
    pub const weighted_t_push_up: u16 = 66;
    pub const triple_stop_push_up: u16 = 67;
    pub const weighted_triple_stop_push_up: u16 = 68;
    pub const wide_hands_push_up: u16 = 69;
    pub const weighted_wide_hands_push_up: u16 = 70;
    pub const parallette_handstand_push_up: u16 = 71;
    pub const weighted_parallette_handstand_push_up: u16 = 72;
    pub const ring_handstand_push_up: u16 = 73;
    pub const weighted_ring_handstand_push_up: u16 = 74;
    pub const ring_push_up: u16 = 75;
    pub const weighted_ring_push_up: u16 = 76;
    pub const push_up: u16 = 77;
    pub const pilates_pushup: u16 = 78;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const RowExerciseName = struct {
    pub const barbell_straight_leg_deadlift_to_row: u16 = 0;
    pub const cable_row_standing: u16 = 1;
    pub const dumbbell_row: u16 = 2;
    pub const elevated_feet_inverted_row: u16 = 3;
    pub const weighted_elevated_feet_inverted_row: u16 = 4;
    pub const face_pull: u16 = 5;
    pub const face_pull_with_external_rotation: u16 = 6;
    pub const inverted_row_with_feet_on_swiss_ball: u16 = 7;
    pub const weighted_inverted_row_with_feet_on_swiss_ball: u16 = 8;
    pub const kettlebell_row: u16 = 9;
    pub const modified_inverted_row: u16 = 10;
    pub const weighted_modified_inverted_row: u16 = 11;
    pub const neutral_grip_alternating_dumbbell_row: u16 = 12;
    pub const one_arm_bent_over_row: u16 = 13;
    pub const one_legged_dumbbell_row: u16 = 14;
    pub const renegade_row: u16 = 15;
    pub const reverse_grip_barbell_row: u16 = 16;
    pub const rope_handle_cable_row: u16 = 17;
    pub const seated_cable_row: u16 = 18;
    pub const seated_dumbbell_row: u16 = 19;
    pub const single_arm_cable_row: u16 = 20;
    pub const single_arm_cable_row_and_rotation: u16 = 21;
    pub const single_arm_inverted_row: u16 = 22;
    pub const weighted_single_arm_inverted_row: u16 = 23;
    pub const single_arm_neutral_grip_dumbbell_row: u16 = 24;
    pub const single_arm_neutral_grip_dumbbell_row_and_rotation: u16 = 25;
    pub const suspended_inverted_row: u16 = 26;
    pub const weighted_suspended_inverted_row: u16 = 27;
    pub const t_bar_row: u16 = 28;
    pub const towel_grip_inverted_row: u16 = 29;
    pub const weighted_towel_grip_inverted_row: u16 = 30;
    pub const underhand_grip_cable_row: u16 = 31;
    pub const v_grip_cable_row: u16 = 32;
    pub const wide_grip_seated_cable_row: u16 = 33;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const ShoulderPressExerciseName = struct {
    pub const alternating_dumbbell_shoulder_press: u16 = 0;
    pub const arnold_press: u16 = 1;
    pub const barbell_front_squat_to_push_press: u16 = 2;
    pub const barbell_push_press: u16 = 3;
    pub const barbell_shoulder_press: u16 = 4;
    pub const dead_curl_press: u16 = 5;
    pub const dumbbell_alternating_shoulder_press_and_twist: u16 = 6;
    pub const dumbbell_hammer_curl_to_lunge_to_press: u16 = 7;
    pub const dumbbell_push_press: u16 = 8;
    pub const floor_inverted_shoulder_press: u16 = 9;
    pub const weighted_floor_inverted_shoulder_press: u16 = 10;
    pub const inverted_shoulder_press: u16 = 11;
    pub const weighted_inverted_shoulder_press: u16 = 12;
    pub const one_arm_push_press: u16 = 13;
    pub const overhead_barbell_press: u16 = 14;
    pub const overhead_dumbbell_press: u16 = 15;
    pub const seated_barbell_shoulder_press: u16 = 16;
    pub const seated_dumbbell_shoulder_press: u16 = 17;
    pub const single_arm_dumbbell_shoulder_press: u16 = 18;
    pub const single_arm_step_up_and_press: u16 = 19;
    pub const smith_machine_overhead_press: u16 = 20;
    pub const split_stance_hammer_curl_to_press: u16 = 21;
    pub const swiss_ball_dumbbell_shoulder_press: u16 = 22;
    pub const weight_plate_front_raise: u16 = 23;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const ShoulderStabilityExerciseName = struct {
    pub const _90_degree_cable_external_rotation: u16 = 0;
    pub const band_external_rotation: u16 = 1;
    pub const band_internal_rotation: u16 = 2;
    pub const bent_arm_lateral_raise_and_external_rotation: u16 = 3;
    pub const cable_external_rotation: u16 = 4;
    pub const dumbbell_face_pull_with_external_rotation: u16 = 5;
    pub const floor_i_raise: u16 = 6;
    pub const weighted_floor_i_raise: u16 = 7;
    pub const floor_t_raise: u16 = 8;
    pub const weighted_floor_t_raise: u16 = 9;
    pub const floor_y_raise: u16 = 10;
    pub const weighted_floor_y_raise: u16 = 11;
    pub const incline_i_raise: u16 = 12;
    pub const weighted_incline_i_raise: u16 = 13;
    pub const incline_l_raise: u16 = 14;
    pub const weighted_incline_l_raise: u16 = 15;
    pub const incline_t_raise: u16 = 16;
    pub const weighted_incline_t_raise: u16 = 17;
    pub const incline_w_raise: u16 = 18;
    pub const weighted_incline_w_raise: u16 = 19;
    pub const incline_y_raise: u16 = 20;
    pub const weighted_incline_y_raise: u16 = 21;
    pub const lying_external_rotation: u16 = 22;
    pub const seated_dumbbell_external_rotation: u16 = 23;
    pub const standing_l_raise: u16 = 24;
    pub const swiss_ball_i_raise: u16 = 25;
    pub const weighted_swiss_ball_i_raise: u16 = 26;
    pub const swiss_ball_t_raise: u16 = 27;
    pub const weighted_swiss_ball_t_raise: u16 = 28;
    pub const swiss_ball_w_raise: u16 = 29;
    pub const weighted_swiss_ball_w_raise: u16 = 30;
    pub const swiss_ball_y_raise: u16 = 31;
    pub const weighted_swiss_ball_y_raise: u16 = 32;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const ShrugExerciseName = struct {
    pub const barbell_jump_shrug: u16 = 0;
    pub const barbell_shrug: u16 = 1;
    pub const barbell_upright_row: u16 = 2;
    pub const behind_the_back_smith_machine_shrug: u16 = 3;
    pub const dumbbell_jump_shrug: u16 = 4;
    pub const dumbbell_shrug: u16 = 5;
    pub const dumbbell_upright_row: u16 = 6;
    pub const incline_dumbbell_shrug: u16 = 7;
    pub const overhead_barbell_shrug: u16 = 8;
    pub const overhead_dumbbell_shrug: u16 = 9;
    pub const scaption_and_shrug: u16 = 10;
    pub const scapular_retraction: u16 = 11;
    pub const serratus_chair_shrug: u16 = 12;
    pub const weighted_serratus_chair_shrug: u16 = 13;
    pub const serratus_shrug: u16 = 14;
    pub const weighted_serratus_shrug: u16 = 15;
    pub const wide_grip_jump_shrug: u16 = 16;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const SitUpExerciseName = struct {
    pub const alternating_sit_up: u16 = 0;
    pub const weighted_alternating_sit_up: u16 = 1;
    pub const bent_knee_v_up: u16 = 2;
    pub const weighted_bent_knee_v_up: u16 = 3;
    pub const butterfly_sit_up: u16 = 4;
    pub const weighted_butterfly_situp: u16 = 5;
    pub const cross_punch_roll_up: u16 = 6;
    pub const weighted_cross_punch_roll_up: u16 = 7;
    pub const crossed_arms_sit_up: u16 = 8;
    pub const weighted_crossed_arms_sit_up: u16 = 9;
    pub const get_up_sit_up: u16 = 10;
    pub const weighted_get_up_sit_up: u16 = 11;
    pub const hovering_sit_up: u16 = 12;
    pub const weighted_hovering_sit_up: u16 = 13;
    pub const kettlebell_sit_up: u16 = 14;
    pub const medicine_ball_alternating_v_up: u16 = 15;
    pub const medicine_ball_sit_up: u16 = 16;
    pub const medicine_ball_v_up: u16 = 17;
    pub const modified_sit_up: u16 = 18;
    pub const negative_sit_up: u16 = 19;
    pub const one_arm_full_sit_up: u16 = 20;
    pub const reclining_circle: u16 = 21;
    pub const weighted_reclining_circle: u16 = 22;
    pub const reverse_curl_up: u16 = 23;
    pub const weighted_reverse_curl_up: u16 = 24;
    pub const single_leg_swiss_ball_jackknife: u16 = 25;
    pub const weighted_single_leg_swiss_ball_jackknife: u16 = 26;
    pub const the_teaser: u16 = 27;
    pub const the_teaser_weighted: u16 = 28;
    pub const three_part_roll_down: u16 = 29;
    pub const weighted_three_part_roll_down: u16 = 30;
    pub const v_up: u16 = 31;
    pub const weighted_v_up: u16 = 32;
    pub const weighted_russian_twist_on_swiss_ball: u16 = 33;
    pub const weighted_sit_up: u16 = 34;
    pub const x_abs: u16 = 35;
    pub const weighted_x_abs: u16 = 36;
    pub const sit_up: u16 = 37;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const SquatExerciseName = struct {
    pub const leg_press: u16 = 0;
    pub const back_squat_with_body_bar: u16 = 1;
    pub const back_squats: u16 = 2;
    pub const weighted_back_squats: u16 = 3;
    pub const balancing_squat: u16 = 4;
    pub const weighted_balancing_squat: u16 = 5;
    pub const barbell_back_squat: u16 = 6;
    pub const barbell_box_squat: u16 = 7;
    pub const barbell_front_squat: u16 = 8;
    pub const barbell_hack_squat: u16 = 9;
    pub const barbell_hang_squat_snatch: u16 = 10;
    pub const barbell_lateral_step_up: u16 = 11;
    pub const barbell_quarter_squat: u16 = 12;
    pub const barbell_siff_squat: u16 = 13;
    pub const barbell_squat_snatch: u16 = 14;
    pub const barbell_squat_with_heels_raised: u16 = 15;
    pub const barbell_stepover: u16 = 16;
    pub const barbell_step_up: u16 = 17;
    pub const bench_squat_with_rotational_chop: u16 = 18;
    pub const weighted_bench_squat_with_rotational_chop: u16 = 19;
    pub const body_weight_wall_squat: u16 = 20;
    pub const weighted_wall_squat: u16 = 21;
    pub const box_step_squat: u16 = 22;
    pub const weighted_box_step_squat: u16 = 23;
    pub const braced_squat: u16 = 24;
    pub const crossed_arm_barbell_front_squat: u16 = 25;
    pub const crossover_dumbbell_step_up: u16 = 26;
    pub const dumbbell_front_squat: u16 = 27;
    pub const dumbbell_split_squat: u16 = 28;
    pub const dumbbell_squat: u16 = 29;
    pub const dumbbell_squat_clean: u16 = 30;
    pub const dumbbell_stepover: u16 = 31;
    pub const dumbbell_step_up: u16 = 32;
    pub const elevated_single_leg_squat: u16 = 33;
    pub const weighted_elevated_single_leg_squat: u16 = 34;
    pub const figure_four_squats: u16 = 35;
    pub const weighted_figure_four_squats: u16 = 36;
    pub const goblet_squat: u16 = 37;
    pub const kettlebell_squat: u16 = 38;
    pub const kettlebell_swing_overhead: u16 = 39;
    pub const kettlebell_swing_with_flip_to_squat: u16 = 40;
    pub const lateral_dumbbell_step_up: u16 = 41;
    pub const one_legged_squat: u16 = 42;
    pub const overhead_dumbbell_squat: u16 = 43;
    pub const overhead_squat: u16 = 44;
    pub const partial_single_leg_squat: u16 = 45;
    pub const weighted_partial_single_leg_squat: u16 = 46;
    pub const pistol_squat: u16 = 47;
    pub const weighted_pistol_squat: u16 = 48;
    pub const plie_slides: u16 = 49;
    pub const weighted_plie_slides: u16 = 50;
    pub const plie_squat: u16 = 51;
    pub const weighted_plie_squat: u16 = 52;
    pub const prisoner_squat: u16 = 53;
    pub const weighted_prisoner_squat: u16 = 54;
    pub const single_leg_bench_get_up: u16 = 55;
    pub const weighted_single_leg_bench_get_up: u16 = 56;
    pub const single_leg_bench_squat: u16 = 57;
    pub const weighted_single_leg_bench_squat: u16 = 58;
    pub const single_leg_squat_on_swiss_ball: u16 = 59;
    pub const weighted_single_leg_squat_on_swiss_ball: u16 = 60;
    pub const squat: u16 = 61;
    pub const weighted_squat: u16 = 62;
    pub const squats_with_band: u16 = 63;
    pub const staggered_squat: u16 = 64;
    pub const weighted_staggered_squat: u16 = 65;
    pub const step_up: u16 = 66;
    pub const weighted_step_up: u16 = 67;
    pub const suitcase_squats: u16 = 68;
    pub const sumo_squat: u16 = 69;
    pub const sumo_squat_slide_in: u16 = 70;
    pub const weighted_sumo_squat_slide_in: u16 = 71;
    pub const sumo_squat_to_high_pull: u16 = 72;
    pub const sumo_squat_to_stand: u16 = 73;
    pub const weighted_sumo_squat_to_stand: u16 = 74;
    pub const sumo_squat_with_rotation: u16 = 75;
    pub const weighted_sumo_squat_with_rotation: u16 = 76;
    pub const swiss_ball_body_weight_wall_squat: u16 = 77;
    pub const weighted_swiss_ball_wall_squat: u16 = 78;
    pub const thrusters: u16 = 79;
    pub const uneven_squat: u16 = 80;
    pub const weighted_uneven_squat: u16 = 81;
    pub const waist_slimming_squat: u16 = 82;
    pub const wall_ball: u16 = 83;
    pub const wide_stance_barbell_squat: u16 = 84;
    pub const wide_stance_goblet_squat: u16 = 85;
    pub const zercher_squat: u16 = 86;
    pub const kbs_overhead: u16 = 87;
    pub const squat_and_side_kick: u16 = 88;
    pub const squat_jumps_in_n_out: u16 = 89;
    pub const pilates_plie_squats_parallel_turned_out_flat_and_heels: u16 = 90;
    pub const releve_straight_leg_and_knee_bent_with_one_leg_variation: u16 = 91;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const TotalBodyExerciseName = struct {
    pub const burpee: u16 = 0;
    pub const weighted_burpee: u16 = 1;
    pub const burpee_box_jump: u16 = 2;
    pub const weighted_burpee_box_jump: u16 = 3;
    pub const high_pull_burpee: u16 = 4;
    pub const man_makers: u16 = 5;
    pub const one_arm_burpee: u16 = 6;
    pub const squat_thrusts: u16 = 7;
    pub const weighted_squat_thrusts: u16 = 8;
    pub const squat_plank_push_up: u16 = 9;
    pub const weighted_squat_plank_push_up: u16 = 10;
    pub const standing_t_rotation_balance: u16 = 11;
    pub const weighted_standing_t_rotation_balance: u16 = 12;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const TricepsExtensionExerciseName = struct {
    pub const bench_dip: u16 = 0;
    pub const weighted_bench_dip: u16 = 1;
    pub const body_weight_dip: u16 = 2;
    pub const cable_kickback: u16 = 3;
    pub const cable_lying_triceps_extension: u16 = 4;
    pub const cable_overhead_triceps_extension: u16 = 5;
    pub const dumbbell_kickback: u16 = 6;
    pub const dumbbell_lying_triceps_extension: u16 = 7;
    pub const ez_bar_overhead_triceps_extension: u16 = 8;
    pub const incline_dip: u16 = 9;
    pub const weighted_incline_dip: u16 = 10;
    pub const incline_ez_bar_lying_triceps_extension: u16 = 11;
    pub const lying_dumbbell_pullover_to_extension: u16 = 12;
    pub const lying_ez_bar_triceps_extension: u16 = 13;
    pub const lying_triceps_extension_to_close_grip_bench_press: u16 = 14;
    pub const overhead_dumbbell_triceps_extension: u16 = 15;
    pub const reclining_triceps_press: u16 = 16;
    pub const reverse_grip_pressdown: u16 = 17;
    pub const reverse_grip_triceps_pressdown: u16 = 18;
    pub const rope_pressdown: u16 = 19;
    pub const seated_barbell_overhead_triceps_extension: u16 = 20;
    pub const seated_dumbbell_overhead_triceps_extension: u16 = 21;
    pub const seated_ez_bar_overhead_triceps_extension: u16 = 22;
    pub const seated_single_arm_overhead_dumbbell_extension: u16 = 23;
    pub const single_arm_dumbbell_overhead_triceps_extension: u16 = 24;
    pub const single_dumbbell_seated_overhead_triceps_extension: u16 = 25;
    pub const single_leg_bench_dip_and_kick: u16 = 26;
    pub const weighted_single_leg_bench_dip_and_kick: u16 = 27;
    pub const single_leg_dip: u16 = 28;
    pub const weighted_single_leg_dip: u16 = 29;
    pub const static_lying_triceps_extension: u16 = 30;
    pub const suspended_dip: u16 = 31;
    pub const weighted_suspended_dip: u16 = 32;
    pub const swiss_ball_dumbbell_lying_triceps_extension: u16 = 33;
    pub const swiss_ball_ez_bar_lying_triceps_extension: u16 = 34;
    pub const swiss_ball_ez_bar_overhead_triceps_extension: u16 = 35;
    pub const tabletop_dip: u16 = 36;
    pub const weighted_tabletop_dip: u16 = 37;
    pub const triceps_extension_on_floor: u16 = 38;
    pub const triceps_pressdown: u16 = 39;
    pub const weighted_dip: u16 = 40;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const WarmUpExerciseName = struct {
    pub const quadruped_rocking: u16 = 0;
    pub const neck_tilts: u16 = 1;
    pub const ankle_circles: u16 = 2;
    pub const ankle_dorsiflexion_with_band: u16 = 3;
    pub const ankle_internal_rotation: u16 = 4;
    pub const arm_circles: u16 = 5;
    pub const bent_over_reach_to_sky: u16 = 6;
    pub const cat_camel: u16 = 7;
    pub const elbow_to_foot_lunge: u16 = 8;
    pub const forward_and_backward_leg_swings: u16 = 9;
    pub const groiners: u16 = 10;
    pub const inverted_hamstring_stretch: u16 = 11;
    pub const lateral_duck_under: u16 = 12;
    pub const neck_rotations: u16 = 13;
    pub const opposite_arm_and_leg_balance: u16 = 14;
    pub const reach_roll_and_lift: u16 = 15;
    pub const scorpion: u16 = 16;
    pub const shoulder_circles: u16 = 17;
    pub const side_to_side_leg_swings: u16 = 18;
    pub const sleeper_stretch: u16 = 19;
    pub const slide_out: u16 = 20;
    pub const swiss_ball_hip_crossover: u16 = 21;
    pub const swiss_ball_reach_roll_and_lift: u16 = 22;
    pub const swiss_ball_windshield_wipers: u16 = 23;
    pub const thoracic_rotation: u16 = 24;
    pub const walking_high_kicks: u16 = 25;
    pub const walking_high_knees: u16 = 26;
    pub const walking_knee_hugs: u16 = 27;
    pub const walking_leg_cradles: u16 = 28;
    pub const walkout: u16 = 29;
    pub const walkout_from_push_up_position: u16 = 30;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const RunExerciseName = struct {
    pub const run: u16 = 0;
    pub const walk: u16 = 1;
    pub const jog: u16 = 2;
    pub const sprint: u16 = 3;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const WaterType = struct {
    pub const fresh = 0;
    pub const salt = 1;
    pub const en13319 = 2;
    pub const custom = 3;
};

pub const TissueModelType = struct {
    pub const zhl_16c = 0;
};

pub const DiveGasStatus = struct {
    pub const disabled = 0;
    pub const enabled = 1;
    pub const backup_only = 2;
};

pub const DiveAlarmType = struct {
    pub const depth = 0;
    pub const time = 1;
};

pub const DiveBacklightMode = struct {
    pub const at_depth = 0;
    pub const always_on = 1;
};

pub const FaveroProduct = struct {
    pub const assioma_uno: u16 = 10;
    pub const assioma_duo: u16 = 12;

    const Self = @This();
    pub fn toString(i: u16) []const u8 {
        return genericToString(Self, u16, i);
    }
};

pub const ClimbProEvent = struct {
    pub const approach = 0;
    pub const start = 1;
    pub const complete = 2;
};

pub const TapSensitivity = struct {
    pub const high = 0;
    pub const medium = 1;
    pub const low = 2;
};

pub const RadarThreatLevelType = struct {
    pub const threat_unknown = 0;
    pub const threat_none = 1;
    pub const threat_approaching = 2;
    pub const threat_approaching_fast = 3;
};

pub const Mesg = struct {
    pub const size = 254;
    pub const def_size = 278;
};

pub const FileIdMesg = struct {
    pub const size = 35;
    pub const def_size = 26;
    pub const product_name_count = 20;
};

pub const FileIdFieldNum = struct {
    pub const serial_number: u8 = 3;
    pub const time_created: u8 = 4;
    pub const product_name: u8 = 8;
    pub const manufacturer: u8 = 1;
    pub const product: u8 = 2;
    pub const number: u8 = 5;
    pub const typ: u8 = 0;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const FileCreatorMesg = struct {
    pub const size: u8 = 3;
    pub const def_size: u8 = 11;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const FileCreatorFieldNum = struct {
    pub const software_version: u8 = 0;
    pub const hardware_version: u8 = 1;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const SoftwareMesg = struct {
    pub const size: u8 = 20;
    pub const def_size: u8 = 14;
    pub const part_number_count: u8 = 16;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const SoftwareFieldNum = struct {
    pub const part_number: u8 = 5;
    pub const message_index: u8 = 254;
    pub const version: u8 = 3;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const SlaveDeviceMesg = struct {
    pub const size: u8 = 4;
    pub const def_size: u8 = 11;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const SlaveDeviceFieldNum = struct {
    pub const manufacturer: u8 = 0;
    pub const product: u8 = 1;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const CapabilitiesMesg = struct {
    pub const size: u8 = 13;
    pub const def_size: u8 = 17;
    pub const languages_count: u8 = 4;
    pub const sports_count: u8 = 1;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const CapabilitiesFieldNum = struct {
    pub const languages: u8 = 0;
    pub const workouts_supported: u8 = 21;
    pub const connectivity_supported: u8 = 23;
    pub const sports: u8 = 1;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const FileCapabilitiesMesg = struct {
    pub const size: u8 = 26;
    pub const def_size: u8 = 23;
    pub const directory_count: u8 = 16;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const FileCapabilitiesFieldNum = struct {
    pub const directory: u8 = 2;
    pub const max_size: u8 = 4;
    pub const message_index: u8 = 254;
    pub const max_count: u8 = 3;
    pub const typ: u8 = 0;
    pub const flags: u8 = 1;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const MesgCapabilitiesMesg = struct {
    pub const size: u8 = 8;
    pub const def_size: u8 = 20;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const MesgCapabilitiesFieldNum = struct {
    pub const message_index: u8 = 254;
    pub const mesg_num: u8 = 1;
    pub const file: u8 = 0;
    pub const count_type: u8 = 2;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const FieldCapabilitiesMesg = struct {
    pub const size: u8 = 8;
    pub const def_size: u8 = 20;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const FieldCapabilitiesFieldNum = struct {
    pub const message_index: u8 = 254;
    pub const mesg_num: u8 = 1;
    pub const file: u8 = 0;
    pub const field_num: u8 = 2;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const DeviceSettingsMesg = struct {
    pub const size: u8 = 36;
    pub const def_size: u8 = 56;
    pub const time_offset_count: u8 = 2;
    pub const pages_enabled_count: u8 = 1;
    pub const default_page_count: u8 = 1;
    pub const time_mode_count: u8 = 2;
    pub const time_zone_offset_count: u8 = 2;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const DeviceSettingsFieldNum = struct {
    pub const utc_offset: u8 = 1;
    pub const time_offset: u8 = 2;
    pub const clock_time: u8 = 39;
    pub const pages_enabled: u8 = 40;
    pub const default_page: u8 = 57;
    pub const autosync_min_steps: u8 = 58;
    pub const autosync_min_time: u8 = 59;
    pub const active_time_zone: u8 = 0;
    pub const time_mode: u8 = 4;
    pub const time_zone_offset: u8 = 5;
    pub const backlight_mode: u8 = 12;
    pub const activity_tracker_enabled: u8 = 36;
    pub const move_alert_enabled: u8 = 46;
    pub const date_mode: u8 = 47;
    pub const display_orientation: u8 = 55;
    pub const mounting_side: u8 = 56;
    pub const tap_sensitivity: u8 = 174;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const UserProfileMesg = struct {
    pub const size: u8 = 50;
    pub const def_size: u8 = 80;
    pub const friendly_name_count: u8 = 16;
    pub const global_id_count: u8 = 6;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const UserProfileFieldNum = struct {
    pub const friendly_name: u8 = 0;
    pub const message_index: u8 = 254;
    pub const weight: u8 = 4;
    pub const local_id: u8 = 22;
    pub const user_running_step_length: u8 = 31;
    pub const user_walking_step_length: u8 = 32;
    pub const gender: u8 = 1;
    pub const age: u8 = 2;
    pub const height: u8 = 3;
    pub const language: u8 = 5;
    pub const elev_setting: u8 = 6;
    pub const weight_setting: u8 = 7;
    pub const resting_heart_rate: u8 = 8;
    pub const default_max_running_heart_rate: u8 = 9;
    pub const default_max_biking_heart_rate: u8 = 10;
    pub const default_max_heart_rate: u8 = 11;
    pub const hr_setting: u8 = 12;
    pub const speed_setting: u8 = 13;
    pub const dist_setting: u8 = 14;
    pub const power_setting: u8 = 16;
    pub const activity_class: u8 = 17;
    pub const position_setting: u8 = 18;
    pub const temperature_setting: u8 = 21;
    pub const global_id: u8 = 23;
    pub const height_setting: u8 = 30;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const HrmProfileMesg = struct {
    pub const size: u8 = 7;
    pub const def_size: u8 = 20;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const HrmProfileFieldNum = struct {
    pub const message_index: u8 = 254;
    pub const hrm_ant_id: u8 = 1;
    pub const enabled: u8 = 0;
    pub const log_hrv: u8 = 2;
    pub const hrm_ant_id_trans_type: u8 = 3;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const SdmProfileMesg = struct {
    pub const size: u8 = 14;
    pub const def_size: u8 = 29;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const SdmProfileFieldNum = struct {
    pub const odometer: u8 = 3;
    pub const message_index: u8 = 254;
    pub const sdm_ant_id: u8 = 1;
    pub const sdm_cal_factor: u8 = 2;
    pub const enabled: u8 = 0;
    pub const speed_source: u8 = 4;
    pub const sdm_ant_id_trans_type: u8 = 5;
    pub const odometer_rollover: u8 = 7;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const BikeProfileMesg = struct {
    pub const size: u8 = 59;
    pub const def_size: u8 = 101;
    pub const name_count: u8 = 16;
    pub const front_gear_count: u8 = 1;
    pub const rear_gear_count: u8 = 1;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const BikeProfileFieldNum = struct {
    pub const name: u8 = 0;
    pub const odometer: u8 = 3;
    pub const message_index: u8 = 254;
    pub const bike_spd_ant_id: u8 = 4;
    pub const bike_cad_ant_id: u8 = 5;
    pub const bike_spdcad_ant_id: u8 = 6;
    pub const bike_power_ant_id: u8 = 7;
    pub const custom_wheelsize: u8 = 8;
    pub const auto_wheelsize: u8 = 9;
    pub const bike_weight: u8 = 10;
    pub const power_cal_factor: u8 = 11;
    pub const sport: u8 = 1;
    pub const sub_sport: u8 = 2;
    pub const auto_wheel_cal: u8 = 12;
    pub const auto_power_zero: u8 = 13;
    pub const id: u8 = 14;
    pub const spd_enabled: u8 = 15;
    pub const cad_enabled: u8 = 16;
    pub const spdcad_enabled: u8 = 17;
    pub const power_enabled: u8 = 18;
    pub const crank_length: u8 = 19;
    pub const enabled: u8 = 20;
    pub const bike_spd_ant_id_trans_type: u8 = 21;
    pub const bike_cad_ant_id_trans_type: u8 = 22;
    pub const bike_spdcad_ant_id_trans_type: u8 = 23;
    pub const bike_power_ant_id_trans_type: u8 = 24;
    pub const odometer_rollover: u8 = 37;
    pub const front_gear_num: u8 = 38;
    pub const front_gear: u8 = 39;
    pub const rear_gear_num: u8 = 40;
    pub const rear_gear: u8 = 41;
    pub const shimano_di2_enabled: u8 = 44;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const ConnectivityMesg = struct {
    pub const size: u8 = 36;
    pub const def_size: u8 = 44;
    pub const name_count: u8 = 24;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const ConnectivityFieldNum = struct {
    pub const name: u8 = 3;
    pub const bluetooth_enabled: u8 = 0;
    pub const bluetooth_le_enabled: u8 = 1;
    pub const ant_enabled: u8 = 2;
    pub const live_tracking_enabled: u8 = 4;
    pub const weather_conditions_enabled: u8 = 5;
    pub const weather_alerts_enabled: u8 = 6;
    pub const auto_activity_upload_enabled: u8 = 7;
    pub const course_download_enabled: u8 = 8;
    pub const workout_download_enabled: u8 = 9;
    pub const gps_ephemeris_download_enabled: u8 = 10;
    pub const incident_detection_enabled: u8 = 11;
    pub const grouptrack_enabled: u8 = 12;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const ZonesTargetMesg = struct {
    pub const size: u8 = 6;
    pub const def_size: u8 = 20;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const ZonesTargetFieldNum = struct {
    pub const functional_threshold_power: u8 = 3;
    pub const max_heart_rate: u8 = 1;
    pub const threshold_heart_rate: u8 = 2;
    pub const hr_calc_type: u8 = 5;
    pub const pwr_calc_type: u8 = 7;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const SportMesg = struct {
    pub const size: u8 = 18;
    pub const def_size: u8 = 14;
    pub const name_count: u8 = 16;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const SportFieldNum = struct {
    pub const name: u8 = 3;
    pub const sport: u8 = 0;
    pub const sub_sport: u8 = 1;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const HrZoneMesg = struct {
    pub const size: u8 = 19;
    pub const def_size: u8 = 14;
    pub const name_count: u8 = 16;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const HrZoneFieldNum = struct {
    pub const name: u8 = 2;
    pub const message_index: u8 = 254;
    pub const high_bpm: u8 = 1;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const SpeedZoneMesg = struct {
    pub const size: u8 = 20;
    pub const def_size: u8 = 14;
    pub const name_count: u8 = 16;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const SpeedZoneFieldNum = struct {
    pub const name: u8 = 1;
    pub const message_index: u8 = 254;
    pub const high_value: u8 = 0;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const CadenceZoneMesg = struct {
    pub const size: u8 = 19;
    pub const def_size: u8 = 14;
    pub const name_count: u8 = 16;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const CadenceZoneFieldNum = struct {
    pub const name: u8 = 1;
    pub const message_index: u8 = 254;
    pub const high_value: u8 = 0;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const PowerZoneMesg = struct {
    pub const size: u8 = 20;
    pub const def_size: u8 = 14;
    pub const name_count: u8 = 16;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const PowerZoneFieldNum = struct {
    pub const name: u8 = 2;
    pub const message_index: u8 = 254;
    pub const high_value: u8 = 1;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const MetZoneMesg = struct {
    pub const size: u8 = 6;
    pub const def_size: u8 = 17;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const MetZoneFieldNum = struct {
    pub const message_index: u8 = 254;
    pub const calories: u8 = 2;
    pub const high_bpm: u8 = 1;
    pub const fat_calories: u8 = 3;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const DiveSettingsMesg = struct {
    pub const size: u8 = 17;
    pub const def_size: u8 = 11;
    pub const name_count: u8 = 16;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const DiveSettingsFieldNum = struct {
    pub const name: u8 = 0;
    pub const heart_rate_source: u8 = 20;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const GoalMesg = struct {
    pub const size: u8 = 27;
    pub const def_size: u8 = 44;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const GoalFieldNum = struct {
    pub const start_date: u8 = 2;
    pub const end_date: u8 = 3;
    pub const value: u8 = 5;
    pub const target_value: u8 = 7;
    pub const message_index: u8 = 254;
    pub const recurrence_value: u8 = 9;
    pub const sport: u8 = 0;
    pub const sub_sport: u8 = 1;
    pub const typ: u8 = 4;
    pub const repeat: u8 = 6;
    pub const recurrence: u8 = 8;
    pub const enabled: u8 = 10;
    pub const source: u8 = 11;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const ActivityMesg = struct {
    pub const size: u8 = 18;
    pub const def_size: u8 = 29;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const ActivityFieldNum = struct {
    pub const timestamp: u8 = 253;
    pub const total_timer_time: u8 = 0;
    pub const local_timestamp: u8 = 5;
    pub const num_sessions: u8 = 1;
    pub const typ: u8 = 2;
    pub const event: u8 = 3;
    pub const event_type: u8 = 4;
    pub const event_group: u8 = 6;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const SessionMesg = struct {
    pub const size: u8 = 209;
    pub const def_size: u8 = 278;
    pub const time_in_hr_zone_count: u8 = 1;
    pub const time_in_speed_zone_count: u8 = 1;
    pub const time_in_cadence_zone_count: u8 = 1;
    pub const time_in_power_zone_count: u8 = 1;
    pub const stroke_count_count: u8 = 1;
    pub const zone_count_count: u8 = 1;
    pub const opponent_name_count: u8 = 1;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const SessionFieldNum = struct {
    pub const timestamp: u8 = 253;
    pub const start_time: u8 = 2;
    pub const start_position_lat: u8 = 3;
    pub const start_position_long: u8 = 4;
    pub const total_elapsed_time: u8 = 7;
    pub const total_timer_time: u8 = 8;
    pub const total_distance: u8 = 9;
    pub const total_cycles: u8 = 10;
    pub const nec_lat: u8 = 29;
    pub const nec_long: u8 = 30;
    pub const swc_lat: u8 = 31;
    pub const swc_long: u8 = 32;
    pub const avg_stroke_count: u8 = 41;
    pub const total_work: u8 = 48;
    pub const total_moving_time: u8 = 59;
    pub const time_in_hr_zone: u8 = 65;
    pub const time_in_speed_zone: u8 = 66;
    pub const time_in_cadence_zone: u8 = 67;
    pub const time_in_power_zone: u8 = 68;
    pub const avg_lap_time: u8 = 69;
    pub const enhanced_avg_speed: u8 = 124;
    pub const enhanced_max_speed: u8 = 125;
    pub const enhanced_avg_altitude: u8 = 126;
    pub const enhanced_min_altitude: u8 = 127;
    pub const enhanced_max_altitude: u8 = 128;
    pub const message_index: u8 = 254;
    pub const total_calories: u8 = 11;
    pub const total_fat_calories: u8 = 13;
    pub const avg_speed: u8 = 14;
    pub const max_speed: u8 = 15;
    pub const avg_power: u8 = 20;
    pub const max_power: u8 = 21;
    pub const total_ascent: u8 = 22;
    pub const total_descent: u8 = 23;
    pub const first_lap_index: u8 = 25;
    pub const num_laps: u8 = 26;
    pub const num_lengths: u8 = 33;
    pub const normalized_power: u8 = 34;
    pub const training_stress_score: u8 = 35;
    pub const intensity_factor: u8 = 36;
    pub const left_right_balance: u8 = 37;
    pub const avg_stroke_distance: u8 = 42;
    pub const pool_length: u8 = 44;
    pub const threshold_power: u8 = 45;
    pub const num_active_lengths: u8 = 47;
    pub const avg_altitude: u8 = 49;
    pub const max_altitude: u8 = 50;
    pub const avg_grade: u8 = 52;
    pub const avg_pos_grade: u8 = 53;
    pub const avg_neg_grade: u8 = 54;
    pub const max_pos_grade: u8 = 55;
    pub const max_neg_grade: u8 = 56;
    pub const avg_pos_vertical_speed: u8 = 60;
    pub const avg_neg_vertical_speed: u8 = 61;
    pub const max_pos_vertical_speed: u8 = 62;
    pub const max_neg_vertical_speed: u8 = 63;
    pub const best_lap_index: u8 = 70;
    pub const min_altitude: u8 = 71;
    pub const player_score: u8 = 82;
    pub const opponent_score: u8 = 83;
    pub const stroke_count: u8 = 85;
    pub const zone_count: u8 = 86;
    pub const max_ball_speed: u8 = 87;
    pub const avg_ball_speed: u8 = 88;
    pub const avg_vertical_oscillation: u8 = 89;
    pub const avg_stance_time_percent: u8 = 90;
    pub const avg_stance_time: u8 = 91;
    pub const avg_vam: u8 = 139;
    pub const event: u8 = 0;
    pub const event_type: u8 = 1;
    pub const sport: u8 = 5;
    pub const sub_sport: u8 = 6;
    pub const avg_heart_rate: u8 = 16;
    pub const max_heart_rate: u8 = 17;
    pub const avg_cadence: u8 = 18;
    pub const max_cadence: u8 = 19;
    pub const total_training_effect: u8 = 24;
    pub const event_group: u8 = 27;
    pub const trigger: u8 = 28;
    pub const swim_stroke: u8 = 43;
    pub const pool_length_unit: u8 = 46;
    pub const gps_accuracy: u8 = 51;
    pub const avg_temperature: u8 = 57;
    pub const max_temperature: u8 = 58;
    pub const min_heart_rate: u8 = 64;
    pub const opponent_name: u8 = 84;
    pub const avg_fractional_cadence: u8 = 92;
    pub const max_fractional_cadence: u8 = 93;
    pub const total_fractional_cycles: u8 = 94;
    pub const sport_index: u8 = 111;
    pub const total_anaerobic_training_effect: u8 = 137;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const LapMesg = struct {
    pub const size: u8 = 189;
    pub const def_size: u8 = 254;
    pub const time_in_hr_zone_count: u8 = 1;
    pub const time_in_speed_zone_count: u8 = 1;
    pub const time_in_cadence_zone_count: u8 = 1;
    pub const time_in_power_zone_count: u8 = 1;
    pub const stroke_count_count: u8 = 1;
    pub const zone_count_count: u8 = 1;
    pub const avg_total_hemoglobin_conc_count: u8 = 1;
    pub const min_total_hemoglobin_conc_count: u8 = 1;
    pub const max_total_hemoglobin_conc_count: u8 = 1;
    pub const avg_saturated_hemoglobin_percent_count: u8 = 1;
    pub const min_saturated_hemoglobin_percent_count: u8 = 1;
    pub const max_saturated_hemoglobin_percent_count: u8 = 1;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const LapFieldNum = struct {
    pub const timestamp: u8 = 253;
    pub const start_time: u8 = 2;
    pub const start_position_lat: u8 = 3;
    pub const start_position_long: u8 = 4;
    pub const end_position_lat: u8 = 5;
    pub const end_position_long: u8 = 6;
    pub const total_elapsed_time: u8 = 7;
    pub const total_timer_time: u8 = 8;
    pub const total_distance: u8 = 9;
    pub const total_cycles: u8 = 10;
    pub const total_work: u8 = 41;
    pub const total_moving_time: u8 = 52;
    pub const time_in_hr_zone: u8 = 57;
    pub const time_in_speed_zone: u8 = 58;
    pub const time_in_cadence_zone: u8 = 59;
    pub const time_in_power_zone: u8 = 60;
    pub const enhanced_avg_speed: u8 = 110;
    pub const enhanced_max_speed: u8 = 111;
    pub const enhanced_avg_altitude: u8 = 112;
    pub const enhanced_min_altitude: u8 = 113;
    pub const enhanced_max_altitude: u8 = 114;
    pub const message_index: u8 = 254;
    pub const total_calories: u8 = 11;
    pub const total_fat_calories: u8 = 12;
    pub const avg_speed: u8 = 13;
    pub const max_speed: u8 = 14;
    pub const avg_power: u8 = 19;
    pub const max_power: u8 = 20;
    pub const total_ascent: u8 = 21;
    pub const total_descent: u8 = 22;
    pub const num_lengths: u8 = 32;
    pub const normalized_power: u8 = 33;
    pub const left_right_balance: u8 = 34;
    pub const first_length_index: u8 = 35;
    pub const avg_stroke_distance: u8 = 37;
    pub const num_active_lengths: u8 = 40;
    pub const avg_altitude: u8 = 42;
    pub const max_altitude: u8 = 43;
    pub const avg_grade: u8 = 45;
    pub const avg_pos_grade: u8 = 46;
    pub const avg_neg_grade: u8 = 47;
    pub const max_pos_grade: u8 = 48;
    pub const max_neg_grade: u8 = 49;
    pub const avg_pos_vertical_speed: u8 = 53;
    pub const avg_neg_vertical_speed: u8 = 54;
    pub const max_pos_vertical_speed: u8 = 55;
    pub const max_neg_vertical_speed: u8 = 56;
    pub const repetition_num: u8 = 61;
    pub const min_altitude: u8 = 62;
    pub const wkt_step_index: u8 = 71;
    pub const opponent_score: u8 = 74;
    pub const stroke_count: u8 = 75;
    pub const zone_count: u8 = 76;
    pub const avg_vertical_oscillation: u8 = 77;
    pub const avg_stance_time_percent: u8 = 78;
    pub const avg_stance_time: u8 = 79;
    pub const player_score: u8 = 83;
    pub const avg_total_hemoglobin_conc: u8 = 84;
    pub const min_total_hemoglobin_conc: u8 = 85;
    pub const max_total_hemoglobin_conc: u8 = 86;
    pub const avg_saturated_hemoglobin_percent: u8 = 87;
    pub const min_saturated_hemoglobin_percent: u8 = 88;
    pub const max_saturated_hemoglobin_percent: u8 = 89;
    pub const avg_vam: u8 = 121;
    pub const event: u8 = 0;
    pub const event_type: u8 = 1;
    pub const avg_heart_rate: u8 = 15;
    pub const max_heart_rate: u8 = 16;
    pub const avg_cadence: u8 = 17;
    pub const max_cadence: u8 = 18;
    pub const intensity: u8 = 23;
    pub const lap_trigger: u8 = 24;
    pub const sport: u8 = 25;
    pub const event_group: u8 = 26;
    pub const swim_stroke: u8 = 38;
    pub const sub_sport: u8 = 39;
    pub const gps_accuracy: u8 = 44;
    pub const avg_temperature: u8 = 50;
    pub const max_temperature: u8 = 51;
    pub const min_heart_rate: u8 = 63;
    pub const avg_fractional_cadence: u8 = 80;
    pub const max_fractional_cadence: u8 = 81;
    pub const total_fractional_cycles: u8 = 82;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const LengthMesg = struct {
    pub const size: u8 = 38;
    pub const def_size: u8 = 59;
    pub const stroke_count_count: u8 = 1;
    pub const zone_count_count: u8 = 1;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const LengthFieldNum = struct {
    pub const timestamp: u8 = 253;
    pub const start_time: u8 = 2;
    pub const total_elapsed_time: u8 = 3;
    pub const total_timer_time: u8 = 4;
    pub const message_index: u8 = 254;
    pub const total_strokes: u8 = 5;
    pub const avg_speed: u8 = 6;
    pub const total_calories: u8 = 11;
    pub const player_score: u8 = 18;
    pub const opponent_score: u8 = 19;
    pub const stroke_count: u8 = 20;
    pub const zone_count: u8 = 21;
    pub const event: u8 = 0;
    pub const event_type: u8 = 1;
    pub const swim_stroke: u8 = 7;
    pub const avg_swimming_cadence: u8 = 9;
    pub const event_group: u8 = 10;
    pub const length_type: u8 = 12;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const RecordMesg = struct {
    pub const size: u8 = 99;
    pub const def_size: u8 = 149;
    pub const compressed_speed_distance_count: u8 = 3;
    pub const speed_1s_count: u8 = 5;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const RecordFieldNum = struct {
    pub const timestamp: u8 = 253;
    pub const position_lat: u8 = 0;
    pub const position_long: u8 = 1;
    pub const distance: u8 = 5;
    pub const time_from_course: u8 = 11;
    pub const total_cycles: u8 = 19;
    pub const accumulated_power: u8 = 29;
    pub const enhanced_speed: u8 = 73;
    pub const enhanced_altitude: u8 = 78;
    pub const altitude: u8 = 2;
    pub const speed: u8 = 6;
    pub const power: u8 = 7;
    pub const grade: u8 = 9;
    pub const compressed_accumulated_power: u8 = 28;
    pub const vertical_speed: u8 = 32;
    pub const calories: u8 = 33;
    pub const vertical_oscillation: u8 = 39;
    pub const stance_time_percent: u8 = 40;
    pub const stance_time: u8 = 41;
    pub const ball_speed: u8 = 51;
    pub const cadence256: u8 = 52;
    pub const total_hemoglobin_conc: u8 = 54;
    pub const total_hemoglobin_conc_min: u8 = 55;
    pub const total_hemoglobin_conc_max: u8 = 56;
    pub const saturated_hemoglobin_percent: u8 = 57;
    pub const saturated_hemoglobin_percent_min: u8 = 58;
    pub const saturated_hemoglobin_percent_max: u8 = 59;
    pub const heart_rate: u8 = 3;
    pub const cadence: u8 = 4;
    pub const compressed_speed_distance: u8 = 8;
    pub const resistance: u8 = 10;
    pub const cycle_length: u8 = 12;
    pub const temperature: u8 = 13;
    pub const speed_1s: u8 = 17;
    pub const cycles: u8 = 18;
    pub const left_right_balance: u8 = 30;
    pub const gps_accuracy: u8 = 31;
    pub const activity_type: u8 = 42;
    pub const left_torque_effectiveness: u8 = 43;
    pub const right_torque_effectiveness: u8 = 44;
    pub const left_pedal_smoothness: u8 = 45;
    pub const right_pedal_smoothness: u8 = 46;
    pub const combined_pedal_smoothness: u8 = 47;
    pub const time128: u8 = 48;
    pub const stroke_type: u8 = 49;
    pub const zone: u8 = 50;
    pub const fractional_cadence: u8 = 53;
    pub const device_index: u8 = 62;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const EventMesg = struct {
    pub const size: u8 = 23;
    pub const def_size: u8 = 47;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const EventFieldNum = struct {
    pub const timestamp: u8 = 253;
    pub const data: u8 = 3;
    pub const data16: u8 = 2;
    pub const score: u8 = 7;
    pub const opponent_score: u8 = 8;
    pub const event: u8 = 0;
    pub const event_type: u8 = 1;
    pub const event_group: u8 = 4;
    pub const front_gear_num: u8 = 9;
    pub const front_gear: u8 = 10;
    pub const rear_gear_num: u8 = 11;
    pub const rear_gear: u8 = 12;
    pub const radar_threat_level_max: u8 = 21;
    pub const radar_threat_count: u8 = 22;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const DeviceInfoMesg = struct {
    pub const size: u8 = 51;
    pub const def_size: u8 = 59;
    pub const product_name_count: u8 = 20;
    pub const descriptor_count: u8 = 1;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const DeviceInfoFieldNum = struct {
    pub const timestamp: u8 = 253;
    pub const serial_number: u8 = 3;
    pub const cum_operating_time: u8 = 7;
    pub const product_name: u8 = 27;
    pub const manufacturer: u8 = 2;
    pub const product: u8 = 4;
    pub const software_version: u8 = 5;
    pub const battery_voltage: u8 = 10;
    pub const ant_device_number: u8 = 21;
    pub const device_index: u8 = 0;
    pub const device_type: u8 = 1;
    pub const hardware_version: u8 = 6;
    pub const battery_status: u8 = 11;
    pub const sensor_position: u8 = 18;
    pub const descriptor: u8 = 19;
    pub const ant_transmission_type: u8 = 20;
    pub const ant_network: u8 = 22;
    pub const source_type: u8 = 25;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const TrainingFileMesg = struct {
    pub const size: u8 = 17;
    pub const def_size: u8 = 23;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const TrainingFileFieldNum = struct {
    pub const timestamp: u8 = 253;
    pub const serial_number: u8 = 3;
    pub const time_created: u8 = 4;
    pub const manufacturer: u8 = 1;
    pub const product: u8 = 2;
    pub const typ: u8 = 0;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const HrvMesg = struct {
    pub const size: u8 = 2;
    pub const def_size: u8 = 8;
    pub const time_count: u8 = 1;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const WeatherConditionsMesg = struct {
    pub const size: u8 = 93;
    pub const def_size: u8 = 53;
    pub const location_count: u8 = 64;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const WeatherConditionsFieldNum = struct {
    pub const timestamp: u8 = 253;
    pub const location: u8 = 8;
    pub const observed_at_time: u8 = 9;
    pub const observed_location_lat: u8 = 10;
    pub const observed_location_long: u8 = 11;
    pub const wind_direction: u8 = 3;
    pub const wind_speed: u8 = 4;
    pub const weather_report: u8 = 0;
    pub const temperature: u8 = 1;
    pub const condition: u8 = 2;
    pub const precipitation_probability: u8 = 5;
    pub const temperature_feels_like: u8 = 6;
    pub const relative_humidity: u8 = 7;
    pub const day_of_week: u8 = 12;
    pub const high_temperature: u8 = 13;
    pub const low_temperature: u8 = 14;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const WeatherAlertMesg = struct {
    pub const size: u8 = 26;
    pub const def_size: u8 = 23;
    pub const report_id_count: u8 = 12;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const WeatherAlertFieldNum = struct {
    pub const timestamp: u8 = 253;
    pub const report_id: u8 = 0;
    pub const issue_time: u8 = 1;
    pub const expire_time: u8 = 2;
    pub const severity: u8 = 3;
    pub const typ: u8 = 4;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const NmeaSentenceMesg = struct {
    pub const size: u8 = 89;
    pub const def_size: u8 = 14;
    pub const sentence_count: u8 = 83;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const NmeaSentenceFieldNum = struct {
    pub const timestamp: u8 = 253;
    pub const timestamp_ms: u8 = 0;
    pub const sentence: u8 = 1;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const AviationAttitudeMesg = struct {
    pub const size: u8 = 26;
    pub const def_size: u8 = 41;
    pub const system_time_count: u8 = 1;
    pub const pitch_count: u8 = 1;
    pub const roll_count: u8 = 1;
    pub const accel_lateral_count: u8 = 1;
    pub const accel_normal_count: u8 = 1;
    pub const turn_rate_count: u8 = 1;
    pub const track_count: u8 = 1;
    pub const validity_count: u8 = 1;
    pub const stage_count: u8 = 1;
    pub const attitude_stage_complete_count: u8 = 1;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const AviationAttitudeFieldNum = struct {
    pub const timestamp: u8 = 253;
    pub const system_time: u8 = 1;
    pub const timestamp_ms: u8 = 0;
    pub const pitch: u8 = 2;
    pub const roll: u8 = 3;
    pub const accel_lateral: u8 = 4;
    pub const accel_normal: u8 = 5;
    pub const turn_rate: u8 = 6;
    pub const track: u8 = 9;
    pub const validity: u8 = 10;
    pub const stage: u8 = 7;
    pub const attitude_stage_complete: u8 = 8;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const VideoTitleMesg = struct {
    pub const size: u8 = 84;
    pub const def_size: u8 = 14;
    pub const text_count: u8 = 80;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const VideoTitleFieldNum = struct {
    pub const text: u8 = 1;
    pub const message_index: u8 = 254;
    pub const message_count: u8 = 0;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const VideoDescriptionMesg = struct {
    pub const size: u8 = 254;
    pub const def_size: u8 = 14;
    pub const text_count: u8 = 250;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const VideoDescriptionFieldNum = struct {
    pub const message_index: u8 = 254;
    pub const message_count: u8 = 0;
    pub const text: u8 = 1;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const SetMesg = struct {
    pub const size: u8 = 2;
    pub const def_size: u8 = 8;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const CourseMesg = struct {
    pub const size: u8 = 22;
    pub const def_size: u8 = 17;
    pub const name_count: u8 = 16;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const CourseFieldNum = struct {
    pub const name: u8 = 5;
    pub const capabilities: u8 = 6;
    pub const sport: u8 = 4;
    pub const sub_sport: u8 = 7;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const CoursePointMesg = struct {
    pub const size: u8 = 36;
    pub const def_size: u8 = 29;
    pub const name_count: u8 = 16;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const CoursePointFieldNum = struct {
    pub const timestamp: u8 = 1;
    pub const position_lat: u8 = 2;
    pub const position_long: u8 = 3;
    pub const distance: u8 = 4;
    pub const name: u8 = 6;
    pub const message_index: u8 = 254;
    pub const typ: u8 = 5;
    pub const favorite: u8 = 8;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const SegmentIdMesg = struct {
    pub const size: u8 = 15;
    pub const def_size: u8 = 32;
    pub const name_count: u8 = 1;
    pub const uuid_count: u8 = 1;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const SegmentIdFieldNum = struct {
    pub const user_profile_primary_key: u8 = 4;
    pub const device_id: u8 = 5;
    pub const name: u8 = 0;
    pub const uuid: u8 = 1;
    pub const sport: u8 = 2;
    pub const enabled: u8 = 3;
    pub const default_race_leader: u8 = 6;
    pub const delete_status: u8 = 7;
    pub const selection_type: u8 = 8;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const SegmentLeaderboardEntryMesg = struct {
    pub const size: u8 = 16;
    pub const def_size: u8 = 23;
    pub const name_count: u8 = 1;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const SegmentLeaderboardEntryFieldNum = struct {
    pub const group_primary_key: u8 = 2;
    pub const activity_id: u8 = 3;
    pub const segment_time: u8 = 4;
    pub const message_index: u8 = 254;
    pub const name: u8 = 0;
    pub const typ: u8 = 1;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const SegmentPointMesg = struct {
    pub const size: u8 = 20;
    pub const def_size: u8 = 23;
    pub const leader_time_count: u8 = 1;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const SegmentPointFieldNum = struct {
    pub const position_lat: u8 = 1;
    pub const position_long: u8 = 2;
    pub const distance: u8 = 3;
    pub const leader_time: u8 = 5;
    pub const message_index: u8 = 254;
    pub const altitude: u8 = 4;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const SegmentLapMesg = struct {
    pub const size: u8 = 210;
    pub const def_size: u8 = 224;
    pub const name_count: u8 = 16;
    pub const time_in_hr_zone_count: u8 = 1;
    pub const time_in_speed_zone_count: u8 = 1;
    pub const time_in_cadence_zone_count: u8 = 1;
    pub const time_in_power_zone_count: u8 = 1;
    pub const uuid_count: u8 = 33;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const SegmentLapFieldNum = struct {
    pub const timestamp: u8 = 253;
    pub const start_time: u8 = 2;
    pub const start_position_lat: u8 = 3;
    pub const start_position_long: u8 = 4;
    pub const end_position_lat: u8 = 5;
    pub const end_position_long: u8 = 6;
    pub const total_elapsed_time: u8 = 7;
    pub const total_timer_time: u8 = 8;
    pub const total_distance: u8 = 9;
    pub const total_cycles: u8 = 10;
    pub const nec_lat: u8 = 25;
    pub const nec_long: u8 = 26;
    pub const swc_lat: u8 = 27;
    pub const swc_long: u8 = 28;
    pub const name: u8 = 29;
    pub const total_work: u8 = 33;
    pub const total_moving_time: u8 = 44;
    pub const time_in_hr_zone: u8 = 49;
    pub const time_in_speed_zone: u8 = 50;
    pub const time_in_cadence_zone: u8 = 51;
    pub const time_in_power_zone: u8 = 52;
    pub const active_time: u8 = 56;
    pub const message_index: u8 = 254;
    pub const total_calories: u8 = 11;
    pub const total_fat_calories: u8 = 12;
    pub const avg_speed: u8 = 13;
    pub const max_speed: u8 = 14;
    pub const avg_power: u8 = 19;
    pub const max_power: u8 = 20;
    pub const total_ascent: u8 = 21;
    pub const total_descent: u8 = 22;
    pub const normalized_power: u8 = 30;
    pub const left_right_balance: u8 = 31;
    pub const avg_altitude: u8 = 34;
    pub const max_altitude: u8 = 35;
    pub const avg_grade: u8 = 37;
    pub const avg_pos_grade: u8 = 38;
    pub const avg_neg_grade: u8 = 39;
    pub const max_pos_grade: u8 = 40;
    pub const max_neg_grade: u8 = 41;
    pub const avg_pos_vertical_speed: u8 = 45;
    pub const avg_neg_vertical_speed: u8 = 46;
    pub const max_pos_vertical_speed: u8 = 47;
    pub const max_neg_vertical_speed: u8 = 48;
    pub const repetition_num: u8 = 53;
    pub const min_altitude: u8 = 54;
    pub const wkt_step_index: u8 = 57;
    pub const front_gear_shift_count: u8 = 69;
    pub const rear_gear_shift_count: u8 = 70;
    pub const event: u8 = 0;
    pub const event_type: u8 = 1;
    pub const avg_heart_rate: u8 = 15;
    pub const max_heart_rate: u8 = 16;
    pub const avg_cadence: u8 = 17;
    pub const max_cadence: u8 = 18;
    pub const sport: u8 = 23;
    pub const event_group: u8 = 24;
    pub const sub_sport: u8 = 32;
    pub const gps_accuracy: u8 = 36;
    pub const avg_temperature: u8 = 42;
    pub const max_temperature: u8 = 43;
    pub const min_heart_rate: u8 = 55;
    pub const sport_event: u8 = 58;
    pub const avg_left_torque_effectiveness: u8 = 59;
    pub const avg_right_torque_effectiveness: u8 = 60;
    pub const avg_left_pedal_smoothness: u8 = 61;
    pub const avg_right_pedal_smoothness: u8 = 62;
    pub const avg_combined_pedal_smoothness: u8 = 63;
    pub const status: u8 = 64;
    pub const uuid: u8 = 65;
    pub const avg_fractional_cadence: u8 = 66;
    pub const max_fractional_cadence: u8 = 67;
    pub const total_fractional_cycles: u8 = 68;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const SegmentFileMesg = struct {
    pub const size: u8 = 17;
    pub const def_size: u8 = 26;
    pub const leader_group_primary_key_count: u8 = 1;
    pub const leader_activity_id_count: u8 = 1;
    pub const file_uuid_count: u8 = 1;
    pub const leader_type_count: u8 = 1;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const SegmentFileFieldNum = struct {
    pub const user_profile_primary_key: u8 = 4;
    pub const leader_group_primary_key: u8 = 8;
    pub const leader_activity_id: u8 = 9;
    pub const message_index: u8 = 254;
    pub const file_uuid: u8 = 1;
    pub const enabled: u8 = 3;
    pub const leader_type: u8 = 7;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const WorkoutMesg = struct {
    pub const size: u8 = 27;
    pub const def_size: u8 = 26;
    pub const wkt_name_count: u8 = 16;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const WorkoutFieldNum = struct {
    pub const capabilities: u8 = 5;
    pub const wkt_name: u8 = 8;
    pub const num_valid_steps: u8 = 6;
    pub const pool_length: u8 = 14;
    pub const sport: u8 = 4;
    pub const sub_sport: u8 = 11;
    pub const pool_length_unit: u8 = 15;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const WorkoutSessionMesg = struct {
    pub const size: u8 = 11;
    pub const def_size: u8 = 26;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const WorkoutSessionFieldNum = struct {
    pub const message_index: u8 = 254;
    pub const num_valid_steps: u8 = 2;
    pub const first_step_index: u8 = 3;
    pub const pool_length: u8 = 4;
    pub const sport: u8 = 0;
    pub const sub_sport: u8 = 1;
    pub const pool_length_unit: u8 = 5;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const WorkoutStepMesg = struct {
    pub const size: u8 = 90;
    pub const def_size: u8 = 41;
    pub const wkt_step_name_count: u8 = 16;
    pub const notes_count: u8 = 50;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const WorkoutStepFieldNum = struct {
    pub const wkt_step_name: u8 = 0;
    pub const duration_value: u8 = 2;
    pub const target_value: u8 = 4;
    pub const custom_target_value_low: u8 = 5;
    pub const custom_target_value_high: u8 = 6;
    pub const message_index: u8 = 254;
    pub const exercise_category: u8 = 10;
    pub const duration_type: u8 = 1;
    pub const target_type: u8 = 3;
    pub const intensity: u8 = 7;
    pub const notes: u8 = 8;
    pub const equipment: u8 = 9;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const ExerciseTitleMesg = struct {
    pub const size: u8 = 206;
    pub const def_size: u8 = 17;
    pub const wkt_step_name_count: u8 = 200;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const ExerciseTitleFieldNum = struct {
    pub const wkt_step_name: u8 = 2;
    pub const message_index: u8 = 254;
    pub const exercise_category: u8 = 0;
    pub const exercise_name: u8 = 1;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const ScheduleMesg = struct {
    pub const size: u8 = 18;
    pub const def_size: u8 = 26;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const ScheduleFieldNum = struct {
    pub const serial_number: u8 = 2;
    pub const time_created: u8 = 3;
    pub const scheduled_time: u8 = 6;
    pub const manufacturer: u8 = 0;
    pub const product: u8 = 1;
    pub const completed: u8 = 4;
    pub const typ: u8 = 5;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const TotalsMesg = struct {
    pub const size: u8 = 29;
    pub const def_size: u8 = 32;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const TotalsFieldNum = struct {
    pub const timestamp: u8 = 253;
    pub const timer_time: u8 = 0;
    pub const distance: u8 = 1;
    pub const calories: u8 = 2;
    pub const elapsed_time: u8 = 4;
    pub const active_time: u8 = 6;
    pub const message_index: u8 = 254;
    pub const sessions: u8 = 5;
    pub const sport: u8 = 3;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const WeightScaleMesg = struct {
    pub const size: u8 = 25;
    pub const def_size: u8 = 44;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const WeightScaleFieldNum = struct {
    pub const timestamp: u8 = 253;
    pub const weight: u8 = 0;
    pub const percent_fat: u8 = 1;
    pub const percent_hydration: u8 = 2;
    pub const visceral_fat_mass: u8 = 3;
    pub const bone_mass: u8 = 4;
    pub const muscle_mass: u8 = 5;
    pub const basal_met: u8 = 7;
    pub const active_met: u8 = 9;
    pub const user_profile_index: u8 = 12;
    pub const physique_rating: u8 = 8;
    pub const metabolic_age: u8 = 10;
    pub const visceral_fat_rating: u8 = 11;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const BloodPressureMesg = struct {
    pub const size: u8 = 21;
    pub const def_size: u8 = 38;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const BloodPressureFieldNum = struct {
    pub const timestamp: u8 = 253;
    pub const systolic_pressure: u8 = 0;
    pub const diastolic_pressure: u8 = 1;
    pub const mean_arterial_pressure: u8 = 2;
    pub const map_3_sample_mean: u8 = 3;
    pub const map_morning_values: u8 = 4;
    pub const map_evening_values: u8 = 5;
    pub const user_profile_index: u8 = 9;
    pub const heart_rate: u8 = 6;
    pub const heart_rate_type: u8 = 7;
    pub const status: u8 = 8;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const MonitoringInfoMesg = struct {
    pub const size: u8 = 8;
    pub const def_size: u8 = 11;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const MonitoringInfoFieldNum = struct {
    pub const timestamp: u8 = 253;
    pub const local_timestamp: u8 = 0;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const MonitoringMesg = struct {
    pub const size: u8 = 31;
    pub const def_size: u8 = 41;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const MonitoringFieldNum = struct {
    pub const timestamp: u8 = 253;
    pub const distance: u8 = 2;
    pub const cycles: u8 = 3;
    pub const active_time: u8 = 4;
    pub const local_timestamp: u8 = 11;
    pub const calories: u8 = 1;
    pub const distance_16: u8 = 8;
    pub const cycles_16: u8 = 9;
    pub const active_time_16: u8 = 10;
    pub const device_index: u8 = 0;
    pub const activity_type: u8 = 5;
    pub const activity_subtype: u8 = 6;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const HrMesg = struct {
    pub const size: u8 = 13;
    pub const def_size: u8 = 23;
    pub const event_timestamp_count: u8 = 1;
    pub const filtered_bpm_count: u8 = 1;
    pub const event_timestamp_12_count: u8 = 1;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const HrFieldNum = struct {
    pub const timestamp: u8 = 253;
    pub const event_timestamp: u8 = 9;
    pub const fractional_timestamp: u8 = 0;
    pub const time256: u8 = 1;
    pub const filtered_bpm: u8 = 6;
    pub const event_timestamp_12: u8 = 10;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const AntRxMesg = struct {
    pub const size: u8 = 25;
    pub const def_size: u8 = 23;
    pub const data_count: u8 = 8;
    pub const mesg_data_count: u8 = 9;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const AntRxFieldNum = struct {
    pub const timestamp: u8 = 253;
    pub const data: u8 = 4;
    pub const fractional_timestamp: u8 = 0;
    pub const mesg_id: u8 = 1;
    pub const mesg_data: u8 = 2;
    pub const channel_number: u8 = 3;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const AntTxMesg = struct {
    pub const size: u8 = 25;
    pub const def_size: u8 = 23;
    pub const data_count: u8 = 8;
    pub const mesg_data_count: u8 = 9;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const AntTxFieldNum = struct {
    pub const timestamp: u8 = 253;
    pub const data: u8 = 4;
    pub const fractional_timestamp: u8 = 0;
    pub const mesg_id: u8 = 1;
    pub const mesg_data: u8 = 2;
    pub const channel_number: u8 = 3;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const ExdScreenConfigurationMesg = struct {
    pub const size: u8 = 4;
    pub const def_size: u8 = 17;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const ExdScreenConfigurationFieldNum = struct {
    pub const screen_index: u8 = 0;
    pub const field_count: u8 = 1;
    pub const layout: u8 = 2;
    pub const screen_enabled: u8 = 3;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const ExdDataFieldConfigurationMesg = struct {
    pub const size: u8 = 6;
    pub const def_size: u8 = 23;
    pub const title_count: u8 = 1;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const ExdDataFieldConfigurationFieldNum = struct {
    pub const screen_index: u8 = 0;
    pub const concept_field: u8 = 1;
    pub const field_id: u8 = 2;
    pub const concept_count: u8 = 3;
    pub const display_type: u8 = 4;
    pub const title: u8 = 5;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const ExdDataConceptConfigurationMesg = struct {
    pub const size: u8 = 11;
    pub const def_size: u8 = 38;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const ExdDataConceptConfigurationFieldNum = struct {
    pub const screen_index: u8 = 0;
    pub const concept_field: u8 = 1;
    pub const field_id: u8 = 2;
    pub const concept_index: u8 = 3;
    pub const data_page: u8 = 4;
    pub const concept_key: u8 = 5;
    pub const scaling: u8 = 6;
    pub const data_units: u8 = 8;
    pub const qualifier: u8 = 9;
    pub const descriptor: u8 = 10;
    pub const is_signed: u8 = 11;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const FieldDescriptionMesg = struct {
    pub const size: u8 = 90;
    pub const def_size: u8 = 35;
    pub const field_name_count: u8 = 64;
    pub const units_count: u8 = 16;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const FieldDescriptionFieldNum = struct {
    pub const field_name: u8 = 3;
    pub const units: u8 = 8;
    pub const fit_base_unit_id: u8 = 13;
    pub const native_mesg_num: u8 = 14;
    pub const developer_data_index: u8 = 0;
    pub const field_definition_number: u8 = 1;
    pub const fit_base_type_id: u8 = 2;
    pub const scale: u8 = 6;
    pub const offset: u8 = 7;
    pub const native_field_num: u8 = 15;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const DeveloperDataIdMesg = struct {
    pub const size: u8 = 39;
    pub const def_size: u8 = 20;
    pub const developer_id_count: u8 = 16;
    pub const application_id_count: u8 = 16;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

pub const DeveloperDataIdFieldNum = struct {
    pub const developer_id: u8 = 0;
    pub const application_id: u8 = 1;
    pub const application_version: u8 = 4;
    pub const manufacturer_id: u8 = 2;
    pub const developer_data_index: u8 = 3;

    const Self = @This();
    pub fn toString(i: u8) []const u8 {
        return genericToString(Self, u8, i);
    }
};

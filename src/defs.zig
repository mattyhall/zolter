pub const MsgTypes = struct {
    pub const file_id = 0;
    pub const capabilities = 1;
    pub const device_settings = 2;
    pub const user_profile = 3;
    pub const hrm_profile = 4;
    pub const sdm_profile = 5;
    pub const bike_profile = 6;
    pub const zones_target = 7;
    pub const hr_zone = 8;
    pub const power_zone = 9;
    pub const met_zone = 10;
    pub const sport = 12;
    pub const goal = 15;
    pub const session = 18;
    pub const lap = 19;
    pub const record = 20;
    pub const event = 21;
    pub const device_info = 23;
    pub const workout = 26;
    pub const workout_step = 27;
    pub const schedule = 28;
    pub const weight_scale = 30;
    pub const course = 31;
    pub const course_point = 32;
    pub const totals = 33;
    pub const activity = 34;
    pub const software = 35;
    pub const file_capabilities = 37;
    pub const mesg_capabilities = 38;
    pub const field_capabilities = 39;
    pub const file_creator = 49;
    pub const blood_pressure = 51;
    pub const speed_zone = 53;
    pub const monitoring = 55;
    pub const training_file = 72;
    pub const hrv = 78;
    pub const ant_rx = 80;
    pub const ant_tx = 81;
    pub const ant_channel_id = 82;
    pub const length = 101;
    pub const monitoring_info = 103;
    pub const pad = 105;
    pub const slave_device = 106;
    pub const connectivity = 127;
    pub const weather_conditions = 128;
    pub const weather_alert = 129;
    pub const cadence_zone = 131;
    pub const hr = 132;
    pub const segment_lap = 142;
    pub const memo_glob = 145;
    pub const segment_id = 148;
    pub const segment_leaderboard_entry = 149;
    pub const segment_point = 150;
    pub const segment_file = 151;
    pub const workout_session = 158;
    pub const watchface_settings = 159;
    pub const gps_metadata = 160;
    pub const camera_event = 161;
    pub const timestamp_correlation = 162;
    pub const gyroscope_data = 164;
    pub const accelerometer_data = 165;
    pub const three_d_sensor_calibration = 167;
    pub const video_frame = 169;
    pub const obdii_data = 174;
    pub const nmea_sentence = 177;
    pub const aviation_attitude = 178;
    pub const video = 184;
    pub const video_title = 185;
    pub const video_description = 186;
    pub const video_clip = 187;
    pub const ohr_settings = 188;
    pub const exd_screen_configuration = 200;
    pub const exd_data_field_configuration = 201;
    pub const exd_data_concept_configuration = 202;
    pub const field_description = 206;
    pub const developer_data_id = 207;
    pub const magnetometer_data = 208;
    pub const barometer_data = 209;
    pub const one_d_sensor_calibration = 210;
    pub const set = 225;
    pub const stress_level = 227;
    pub const dive_settings = 258;
    pub const dive_gas = 259;
    pub const dive_alarm = 262;
    pub const exercise_title = 264;
    pub const dive_summary = 268;
    pub const jump = 285;
    pub const climb_pro = 317;
};

fn generic_to_string(comptime T: anytype, comptime V: anytype, i: V) []const u8 {
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

pub const KnownFileIdFields = struct {
    pub const typ: u8 = 0;
    pub const manufacturer: u8 = 1;
    pub const product: u8 = 2;
    pub const serial_number: u8 = 3;
    pub const file_created: u8 = 4;
    pub const number: u8 = 5;
    pub const product_name: u8 = 8;

    const Self = @This();

    pub fn to_string(i: u8) []const u8 {
        return generic_to_string(Self, u8, i);
    }
};

pub const Types = enum(u8) {
    @"enum" = 0x00,
    sint8 = 0x01,
    uint8 = 0x02,
    string = 0x07,
    uint8z = 0x0A,
    byte = 0x0D,
    num_mask = 0x1F,
    reserved = 0x60,
    endian_flag = 0x80,
    sint16 = 0x83,
    uint16 = 0x84,
    sint32 = 0x85,
    uint32 = 0x86,
    float32 = 0x88,
    float64 = 0x89,
    uint16z = 0x8B,
    uint32z = 0x8C,
    sint64 = 0x8E,
    uint64 = 0x8F,
    uint64z = 0x90,
};

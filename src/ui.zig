const std = @import("std");
const zbox = @import("zbox");

pub fn drawBoxRect(buf: *zbox.Buffer, y: usize, x: usize, height: usize, width: usize) !void {
    var cursor = buf.cursorAt(y, x);
    var writer = cursor.writer();
    try writer.writeAll("┌");
    var i: usize = 0;
    while (i < width - 2) : (i += 1) {
        try writer.writeAll("─");
    }
    try writer.writeAll("┐");

    i = 1;
    while (i < buf.height - 1) : (i += 1) {
        cursor = buf.cursorAt(y + i, x);
        writer = cursor.writer();
        try writer.writeAll("│");
        cursor = buf.cursorAt(y + i, x + width - 1);
        writer = cursor.writer();
        try writer.writeAll("│");
    }

    cursor = buf.cursorAt(height - 1, x);
    writer = cursor.writer();
    try writer.writeAll("└");
    i = 0;
    while (i < width - 2) : (i += 1) {
        try writer.writeAll("─");
    }
    try writer.writeAll("┘");
}

pub fn drawBoxBuf(buf: *zbox.Buffer) !void {
    return drawBoxRect(buf, 0, 0, buf.height, buf.width);
}

pub const List = struct {
    allocator: *std.mem.Allocator,
    buf: zbox.Buffer,
    data: [][]const u8,
    selected: usize,
    offset: usize,

    const Self = @This();

    pub fn init(allocator: *std.mem.Allocator, data: [][]const u8) !Self {
        const buf = try zbox.Buffer.init(allocator, 10, 10);
        return Self{
            .allocator = allocator,
            .buf = buf,
            .data = data,
            .selected = 0,
            .offset = 0,
        };
    }

    pub fn resize(self: *Self, height: usize, width: usize) !void {
        try self.buf.resize(height, width);
    }

    pub fn draw(self: *Self) !void {
        self.buf.clear();
        try drawBoxBuf(&self.buf);

        const usable_height = self.buf.height - 2;
        const usable_width = self.buf.width - 2;
        const bottom = std.math.min(self.data.len, self.offset + usable_height);
        const data = self.data[self.offset..bottom];
        var i: usize = self.offset;
        while (i < bottom) : (i += 1) {
            const line = i - self.offset + 1;
            var s = self.data[i];
            var cursor = self.buf.cursorAt(line, 1);
            if (i == self.selected) {
                cursor.attribs.fg_cyan = true;
                cursor.attribs.bg_white = true;
            }
            try cursor.writer().writeAll(s[0..std.math.min(usable_width, s.len)]);
        }
    }

    pub fn handleInput(self: *Self, e: zbox.Event) void {
        const top_index = self.offset;
        const usable_height = self.buf.height - 2;
        const bottom_index = self.offset + usable_height - 1;
        switch (e) {
            .up => {
                if (self.selected == 0) {
                    self.selected = self.data.len - 1;
                    self.offset = if (usable_height >= self.data.len) 0 else self.data.len - usable_height;
                } else {
                    if (self.selected == top_index) {
                        self.offset -= 1;
                    }
                    self.selected -= 1;
                }
            },
            .down => {
                if (self.selected == self.data.len - 1) {
                    self.selected = 0;
                    self.offset = 0;
                } else {
                    if (self.selected == bottom_index) {
                        self.offset += 1;
                    }
                    self.selected += 1;
                }
            },
            else => {},
        }
    }

    pub fn deinit(self: *Self) void {
        self.buf.deinit();
    }
};

pub const Bar = struct {
    x_label: []const u8,
    y: f32,
    y_label: []const u8,
};

pub const BarGraph = struct {
    allocator: *std.mem.Allocator,
    values: std.ArrayList(Bar),
    max_val: f32,
    max_label_cols: usize,

    const Self = @This();

    pub fn init(allocator: *std.mem.Allocator) Self {
        return .{ .allocator = allocator, .values = std.ArrayList(Bar).init(allocator), .max_val = 0.0, .max_label_cols = 0 };
    }

    // Must be added in the order you want them to appear
    pub fn add(self: *Self, comptime x_fmt_string: []const u8, x_args: anytype, y: f32, comptime y_fmt_string: []const u8, y_args: anytype) !void {
        var x_label = std.ArrayList(u8).init(self.allocator);
        try x_label.writer().print(x_fmt_string, x_args);
        var y_label = std.ArrayList(u8).init(self.allocator);
        try y_label.writer().print(y_fmt_string, y_args);
        const label_cols = x_label.items.len + y_label.items.len;
        try self.values.append(.{
            .x_label = x_label.toOwnedSlice(),
            .y_label = y_label.toOwnedSlice(),
            .y = y,
        });
        if (y > self.max_val) self.max_val = y;
        if (label_cols > self.max_label_cols) self.max_label_cols = label_cols;
    }

    // TODO: just take a buffer here and use its width and height
    pub fn draw(self: *const Self, output: *zbox.Buffer, height: usize, width: usize) !void {
        const each_column_val = self.max_val / @intToFloat(f32, width - self.max_label_cols - 4);
        var cursor = output.cursorAt(0, 0);
        for (self.values.items) |bar| {
            try cursor.writer().print(" {s} ", .{bar.x_label});
            const bar_width = @floatToInt(u32, bar.y / each_column_val);
            var i: usize = 0;
            cursor.attribs.fg_white = false;
            cursor.attribs.fg_cyan = true;
            while (i < bar_width) : (i += 1) {
                _ = try cursor.writer().write("▇");
            }
            cursor.attribs.fg_white = true;
            cursor.attribs.fg_cyan = false;
            try cursor.writer().print(" {s}\n", .{bar.y_label});
            if (cursor.row_num >= height) {
                break;
            }
        }
    }

    pub fn deinit(self: *Self) void {
        for (self.values.items) |*v| {
            self.allocator.free(v.x_label);
            self.allocator.free(v.y_label);
        }
        self.values.deinit();
    }
};

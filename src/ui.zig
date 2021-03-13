const std = @import("std");
const zbox = @import("zbox");

pub fn drawBox(buf: *zbox.Buffer) !void {
    var cursor = buf.cursorAt(0, 0);
    var writer = cursor.writer();
    try writer.writeAll("┌");
    var i: usize = 0;
    while (i < buf.width - 2) : (i += 1) {
        try writer.writeAll("─");
    }
    try writer.writeAll("┐");

    i = 1;
    while (i < buf.height - 1) : (i += 1) {
        cursor = buf.cursorAt(i, 0);
        writer = cursor.writer();
        try writer.writeAll("│");
        cursor = buf.cursorAt(i, buf.width - 1);
        writer = cursor.writer();
        try writer.writeAll("│");
    }

    cursor = buf.cursorAt(buf.height - 1, 0);
    writer = cursor.writer();
    try writer.writeAll("└");
    i = 0;
    while (i < buf.width - 2) : (i += 1) {
        try writer.writeAll("─");
    }
    try writer.writeAll("┘");
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
        try drawBox(&self.buf);

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

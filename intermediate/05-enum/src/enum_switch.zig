//! switchでの使用
//! このモジュールでは、enumをswitchで使う方法を学びます。

const std = @import("std");

const Color = enum {
    red,
    green,
    blue,
    yellow,

    pub fn toRGB(self: Color) struct { r: u8, g: u8, b: u8 } {
        return switch (self) {
            .red => .{ .r = 255, .g = 0, .b = 0 },
            .green => .{ .r = 0, .g = 255, .b = 0 },
            .blue => .{ .r = 0, .g = 0, .b = 255 },
            .yellow => .{ .r = 255, .g = 255, .b = 0 },
        };
    }

    pub fn toHex(self: Color) []const u8 {
        return switch (self) {
            .red => "#FF0000",
            .green => "#00FF00",
            .blue => "#0000FF",
            .yellow => "#FFFF00",
        };
    }

    pub fn mixWith(self: Color, other: Color) ?Color {
        return switch (self) {
            .red => switch (other) {
                .red => .red,
                .green => .yellow,
                .blue => null, // 紫は定義していない
                .yellow => .yellow,
            },
            .green => switch (other) {
                .red => .yellow,
                .green => .green,
                .blue => null, // シアンは定義していない
                .yellow => .yellow,
            },
            .blue => switch (other) {
                .red => null, // 紫は定義していない
                .green => null, // シアンは定義していない
                .blue => .blue,
                .yellow => .green,
            },
            .yellow => .yellow, // 黄色と何を混ぜても黄色系
        };
    }
};

// 季節を表すenum
const Season = enum {
    spring,
    summer,
    autumn,
    winter,

    pub fn getTemperature(self: Season) []const u8 {
        return switch (self) {
            .spring => "暖かい",
            .summer => "暑い",
            .autumn => "涼しい",
            .winter => "寒い",
        };
    }

    pub fn getMonths(self: Season) []const u8 {
        return switch (self) {
            .spring => "3月, 4月, 5月",
            .summer => "6月, 7月, 8月",
            .autumn => "9月, 10月, 11月",
            .winter => "12月, 1月, 2月",
        };
    }
};

pub fn run() void {
    std.debug.print("\n--- switchでの使用 ---\n", .{});

    std.debug.print("\n1. 色のRGB変換:\n", .{});
    const color = Color.red;
    const rgb = color.toRGB();
    std.debug.print("Color: {}\n", .{color});
    std.debug.print("RGB: ({}, {}, {})\n", .{ rgb.r, rgb.g, rgb.b });
    std.debug.print("Hex: {s}\n", .{color.toHex()});

    std.debug.print("\n2. 全ての色を変換:\n", .{});
    const colors = [_]Color{ .red, .green, .blue, .yellow };
    for (colors) |c| {
        const rgb_val = c.toRGB();
        std.debug.print("{}: RGB({}, {}, {}) = {s}\n", .{
            c,
            rgb_val.r,
            rgb_val.g,
            rgb_val.b,
            c.toHex(),
        });
    }

    std.debug.print("\n3. 色の混合:\n", .{});
    std.debug.print("赤 + 緑 = ", .{});
    if (Color.red.mixWith(.green)) |result| {
        std.debug.print("{}\n", .{result});
    } else {
        std.debug.print("混合不可\n", .{});
    }

    std.debug.print("赤 + 青 = ", .{});
    if (Color.red.mixWith(.blue)) |result| {
        std.debug.print("{}\n", .{result});
    } else {
        std.debug.print("混合不可（紫は未定義）\n", .{});
    }

    std.debug.print("\n4. 季節の情報:\n", .{});
    const seasons = [_]Season{ .spring, .summer, .autumn, .winter };
    for (seasons) |s| {
        std.debug.print("{}: {s}, 月: {s}\n", .{
            s,
            s.getTemperature(),
            s.getMonths(),
        });
    }

    std.debug.print("\n5. switch式の値を使う:\n", .{});
    const current_season = Season.summer;
    const activity = switch (current_season) {
        .spring => "花見",
        .summer => "海水浴",
        .autumn => "紅葉狩り",
        .winter => "スキー",
    };
    std.debug.print("{}の活動: {s}\n", .{ current_season, activity });

    std.debug.print("\n解説:\n", .{});
    std.debug.print("- switchはenumの全ケースを網羅する必要がある\n", .{});
    std.debug.print("- コンパイル時に網羅性がチェックされる\n", .{});
    std.debug.print("- switch式は値を返せる\n", .{});
    std.debug.print("- ネストしたswitchも可能\n", .{});
}

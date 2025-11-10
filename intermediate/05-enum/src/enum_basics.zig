//! enumの基本
//! このモジュールでは、enumの基本的な使い方を学びます。

const std = @import("std");

const Direction = enum {
    north,
    south,
    east,
    west,

    pub fn opposite(self: Direction) Direction {
        return switch (self) {
            .north => .south,
            .south => .north,
            .east => .west,
            .west => .east,
        };
    }

    pub fn toString(self: Direction) []const u8 {
        return switch (self) {
            .north => "北",
            .south => "南",
            .east => "東",
            .west => "西",
        };
    }
};

pub fn run() void {
    std.debug.print("\n--- enumの基本 ---\n", .{});

    std.debug.print("\n1. enum値の基本的な使用:\n", .{});
    const dir = Direction.north;
    std.debug.print("Direction: {}\n", .{dir});
    std.debug.print("Opposite: {}\n", .{dir.opposite()});
    std.debug.print("日本語: {s}\n", .{dir.toString()});

    std.debug.print("\n2. 全ての方向をテスト:\n", .{});
    const directions = [_]Direction{ .north, .south, .east, .west };
    for (directions) |d| {
        std.debug.print("{} -> {} (反対方向)\n", .{ d, d.opposite() });
    }

    std.debug.print("\n3. switchによる網羅性チェック:\n", .{});
    const current = Direction.east;
    const description = switch (current) {
        .north => "上へ進む",
        .south => "下へ進む",
        .east => "右へ進む",
        .west => "左へ進む",
    };
    std.debug.print("{}の場合: {s}\n", .{ current, description });

    std.debug.print("\n解説:\n", .{});
    std.debug.print("- enumは名前付き定数の集合\n", .{});
    std.debug.print("- メソッドを定義可能\n", .{});
    std.debug.print("- switchで網羅性がコンパイル時にチェックされる\n", .{});
    std.debug.print("- Rustのenumと似ているが、データを持たないシンプルな形\n", .{});
}

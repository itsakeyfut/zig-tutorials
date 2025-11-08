//! 複数の defer
//! 複数の defer は LIFO（後入れ先出し）順で実行されます

const std = @import("std");

pub fn run() void {
    std.debug.print("\n--- 複数の defer ---\n", .{});

    defer std.debug.print("1\n", .{});
    defer std.debug.print("2\n", .{});
    defer std.debug.print("3\n", .{});

    std.debug.print("Start\n", .{});

    // 出力順序（LIFO）:
    // Start
    // 3
    // 2
    // 1
}

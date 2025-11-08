//! defer の基本
//! defer はスコープの終了時に実行される処理を定義します

const std = @import("std");

pub fn run() !void {
    std.debug.print("\n--- defer の基本 ---\n", .{});

    std.debug.print("Start\n", .{});

    defer std.debug.print("End\n", .{});

    std.debug.print("Middle\n", .{});

    // 出力順序:
    // Start
    // Middle
    // End
}

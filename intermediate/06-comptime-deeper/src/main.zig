//! Zig comptime の実践チュートリアル
//! このプログラムは、comptime変数と関数、inline ループ、型生成、
//! コンパイル時実行の活用方法を学びます。

const std = @import("std");

// 各例のモジュールをインポート
const comptime_basics = @import("comptime_basics.zig");
const inline_loops = @import("inline_loops.zig");
const type_generation = @import("type_generation.zig");
const comptime_execution = @import("comptime_execution.zig");

pub fn main() void {
    std.debug.print("===================================\n", .{});
    std.debug.print("Zig Comptime (Deep Dive)\n", .{});
    std.debug.print("===================================\n", .{});

    // 各comptimeのパターンを実行
    comptime_basics.run();
    inline_loops.run();
    type_generation.run();
    comptime_execution.run();

    std.debug.print("\n===================================\n", .{});
    std.debug.print("Tutorial completed!\n", .{});
    std.debug.print("===================================\n", .{});
}

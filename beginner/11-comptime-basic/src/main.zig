//! Zig comptime入門のチュートリアル
//! このプログラムは、comptime変数とジェネリック関数の使い方を示します。

const std = @import("std");

// 各例のモジュールをインポート
const comptime_variable = @import("comptime_variable.zig");
const generic_function = @import("generic_function.zig");

pub fn main() void {
    std.debug.print("===================================\n", .{});
    std.debug.print("Zig Comptime Basic Tutorial\n", .{});
    std.debug.print("===================================\n", .{});

    // 各例を実行
    comptime_variable.run();
    generic_function.run();

    std.debug.print("\n===================================\n", .{});
    std.debug.print("Tutorial completed!\n", .{});
    std.debug.print("===================================\n", .{});
}

//! Zigの配列とスライスのチュートリアル
//! このプログラムは、配列、スライス、文字列の使い方を示します。

const std = @import("std");

// 各例のモジュールをインポート
const array_basic = @import("array_basic.zig");
const slice_basic = @import("slice_basic.zig");
const string_slice = @import("string_slice.zig");
const mutable_slice = @import("mutable_slice.zig");

pub fn main() void {
    std.debug.print("===================================\n", .{});
    std.debug.print("Zig Array & Slice Tutorial\n", .{});
    std.debug.print("===================================\n", .{});

    // 配列の基本
    array_basic.run();

    // スライスの基本
    slice_basic.run();

    // 文字列（スライス）
    string_slice.run();
    string_slice.runStringFeatures();

    // 可変スライス
    mutable_slice.run();
    mutable_slice.runConstVsMutable();

    std.debug.print("\n===================================\n", .{});
    std.debug.print("Tutorial completed!\n", .{});
    std.debug.print("===================================\n", .{});
}

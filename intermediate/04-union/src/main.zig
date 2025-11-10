//! Zigユニオンとタグ付きユニオンのチュートリアル
//! このプログラムは、基本的なユニオン、タグ付きユニオン、
//! 複雑なタグ付きユニオンの使い方を学びます。

const std = @import("std");

// 各例のモジュールをインポート
const basic_union = @import("basic_union.zig");
const tagged_union = @import("tagged_union.zig");
const complex_union = @import("complex_union.zig");

pub fn main() void {
    std.debug.print("===================================\n", .{});
    std.debug.print("Zig Unions and Tagged Unions\n", .{});
    std.debug.print("===================================\n", .{});

    // 各ユニオンのパターンを実行
    basic_union.run();
    tagged_union.run();
    complex_union.run();

    std.debug.print("\n===================================\n", .{});
    std.debug.print("Tutorial completed!\n", .{});
    std.debug.print("===================================\n", .{});
}

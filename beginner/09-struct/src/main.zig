//! Zigの構造体のチュートリアル
//! このプログラムは、構造体の基本、デフォルト値、ネストした構造体の使い方を示します。

const std = @import("std");

// 各例のモジュールをインポート
const basic_struct = @import("basic_struct.zig");
const default_values = @import("default_values.zig");
const nested_struct = @import("nested_struct.zig");

pub fn main() void {
    std.debug.print("===================================\n", .{});
    std.debug.print("Zig Struct Tutorial\n", .{});
    std.debug.print("===================================\n", .{});

    // 基本的な構造体
    basic_struct.run();
    basic_struct.runMoreExamples();

    // デフォルト値
    default_values.run();
    default_values.runMoreExamples();

    // ネストした構造体
    nested_struct.run();
    nested_struct.runMoreExamples();
    nested_struct.runWithOptional();

    std.debug.print("\n===================================\n", .{});
    std.debug.print("Tutorial completed!\n", .{});
    std.debug.print("===================================\n", .{});
}
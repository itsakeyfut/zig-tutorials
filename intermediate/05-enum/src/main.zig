//! Zig enum（列挙型）チュートリアル
//! このプログラムは、enumの基本、整数値の割り当て、switchでの使い方を示します。

const std = @import("std");

// 各例のモジュールをインポート
const enum_basics = @import("enum_basics.zig");
const enum_integer = @import("enum_integer.zig");
const enum_switch = @import("enum_switch.zig");

pub fn main() !void {
    std.debug.print("===================================\n", .{});
    std.debug.print("Zig Enum (Enumerations)\n", .{});
    std.debug.print("===================================\n", .{});

    // 各enumパターンの例を実行
    enum_basics.run();
    enum_integer.run();
    enum_switch.run();

    std.debug.print("\n===================================\n", .{});
    std.debug.print("Tutorial completed!\n", .{});
    std.debug.print("===================================\n", .{});
}

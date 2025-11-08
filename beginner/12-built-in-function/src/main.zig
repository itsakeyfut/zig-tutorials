//! Zig組み込み関数（基礎）のチュートリアル
//! このプログラムは、@as、@intCast、@TypeOfなどの組み込み関数の使い方を示します。

const std = @import("std");

// 各例のモジュールをインポート
const as_example = @import("as_example.zig");
const intcast_example = @import("intcast_example.zig");
const typeof_example = @import("typeof_example.zig");

pub fn main() void {
    std.debug.print("===================================\n", .{});
    std.debug.print("Zig Built-in Functions Tutorial\n", .{});
    std.debug.print("===================================\n", .{});

    // 各組み込み関数の例を実行
    as_example.run();
    intcast_example.run();
    typeof_example.run();

    std.debug.print("\n===================================\n", .{});
    std.debug.print("Tutorial completed!\n", .{});
    std.debug.print("===================================\n", .{});
}

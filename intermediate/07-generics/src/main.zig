//! Zigジェネリクスチュートリアル
//! このプログラムは、anytypeによる型推論、comptime typeパラメータ、
//! 型制約、ジェネリック構造体の使い方を示します。

const std = @import("std");

// 各例のモジュールをインポート
const anytype_inference = @import("anytype_inference.zig");
const comptime_type = @import("comptime_type.zig");
const type_constraints = @import("type_constraints.zig");
const generic_structures = @import("generic_structures.zig");

pub fn main() !void {
    std.debug.print("===================================\n", .{});
    std.debug.print("Zig Generics\n", .{});
    std.debug.print("===================================\n", .{});

    // 各ジェネリクスパターンの例を実行
    anytype_inference.run();
    comptime_type.run();
    type_constraints.run();
    try generic_structures.run();

    std.debug.print("\n===================================\n", .{});
    std.debug.print("Tutorial completed!\n", .{});
    std.debug.print("===================================\n", .{});
}

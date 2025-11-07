//! ZigのOptional型のチュートリアル
//! このプログラムは、?T、orelse、.?などのOptional型の使い方を示します。

const std = @import("std");

// 各例のモジュールをインポート
const basic_optional = @import("basic_optional.zig");
const unwrap_example = @import("unwrap_example.zig");
const struct_optional = @import("struct_optional.zig");

pub fn main() void {
    std.debug.print("===================================\n", .{});
    std.debug.print("Zig Optional Type Tutorial\n", .{});
    std.debug.print("===================================\n", .{});

    // Optional型の基本
    basic_optional.run();

    // .? による強制アンラップ
    unwrap_example.run();
    unwrap_example.runSafeAlternatives();

    // 構造体でのOptional型
    struct_optional.run();
    struct_optional.runSearch();

    std.debug.print("\n===================================\n", .{});
    std.debug.print("Tutorial completed!\n", .{});
    std.debug.print("===================================\n", .{});
}

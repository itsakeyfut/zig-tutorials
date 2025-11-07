//! Zig制御構文のチュートリアル
//! このプログラムは、if、while、for、switchなどの制御構文の使い方を示します。

const std = @import("std");

// 各例のモジュールをインポート
const if_example = @import("if_example.zig");
const while_example = @import("while_example.zig");
const for_example = @import("for_example.zig");
const switch_example = @import("switch_example.zig");

pub fn main() void {
    std.debug.print("===================================\n", .{});
    std.debug.print("Zig Control Flow Tutorial\n", .{});
    std.debug.print("===================================\n", .{});

    // 各制御構文の例を実行
    if_example.run();
    while_example.run();
    for_example.run();
    switch_example.run();

    std.debug.print("\n===================================\n", .{});
    std.debug.print("Tutorial completed!\n", .{});
    std.debug.print("===================================\n", .{});
}

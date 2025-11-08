//! Zigテストのチュートリアル
//! このプログラムは、testブロックの使い方、エラーのテスト方法を示します。

const std = @import("std");

// 各例のモジュールをインポート
const basic_test = @import("basic_test.zig");
const error_test = @import("error_test.zig");

pub fn main() void {
    std.debug.print("===================================\n", .{});
    std.debug.print("Zig Testing Tutorial\n", .{});
    std.debug.print("===================================\n", .{});

    // 各テストの例を実行
    basic_test.run();
    error_test.run();

    std.debug.print("\n===================================\n", .{});
    std.debug.print("Tutorial completed!\n", .{});
    std.debug.print("===================================\n", .{});
}

//! Zig標準ライブラリのチュートリアル
//! このプログラムは、よく使う標準ライブラリの使い方を示します。
//! - std.mem（メモリ操作）
//! - std.fs（ファイル操作）
//! - std.json（JSON処理）

const std = @import("std");

// 各例のモジュールをインポート
const mem_operations = @import("mem_operations.zig");
const fs_operations = @import("fs_operations.zig");
const json_operations = @import("json_operations.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    std.debug.print("===================================\n", .{});
    std.debug.print("Zig Standard Library Examples\n", .{});
    std.debug.print("===================================\n", .{});

    // 各標準ライブラリの例を実行
    try mem_operations.run();
    try fs_operations.run(allocator);
    try json_operations.run(allocator);

    std.debug.print("\n===================================\n", .{});
    std.debug.print("Tutorial completed!\n", .{});
    std.debug.print("===================================\n", .{});
}

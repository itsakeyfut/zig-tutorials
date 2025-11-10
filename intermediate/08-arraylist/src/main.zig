//! Zig動的データ構造チュートリアル
//! このプログラムは、ArrayList、HashMap、アロケータの実践、
//! カスタムデータ構造の使い方を示します。

const std = @import("std");

// 各例のモジュールをインポート
const arraylist_basics = @import("arraylist_basics.zig");
const hashmap_basics = @import("hashmap_basics.zig");
const allocator_practice = @import("allocator_practice.zig");
const custom_structures = @import("custom_structures.zig");

pub fn main() !void {
    std.debug.print("===================================\n", .{});
    std.debug.print("Zig Dynamic Data Structures\n", .{});
    std.debug.print("===================================\n", .{});

    // 各データ構造パターンの例を実行
    try arraylist_basics.run();
    try hashmap_basics.run();
    try allocator_practice.run();
    try custom_structures.run();

    std.debug.print("\n===================================\n", .{});
    std.debug.print("Tutorial completed!\n", .{});
    std.debug.print("===================================\n", .{});
}

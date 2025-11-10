//! Zigメモリアロケータの概念チュートリアル
//! このプログラムは、アロケータの基本、種類、渡し方のパターンなど
//! メモリ管理の概念を学びます。

const std = @import("std");

// 各例のモジュールをインポート
const allocator_basics = @import("allocator_basics.zig");
const allocator_types = @import("allocator_types.zig");
const allocator_patterns = @import("allocator_patterns.zig");

pub fn main() !void {
    std.debug.print("===================================\n", .{});
    std.debug.print("Zig Memory Allocator Concepts\n", .{});
    std.debug.print("===================================\n", .{});

    // 各アロケータのパターンを実行
    try allocator_basics.run();
    try allocator_types.run();
    try allocator_patterns.run();

    std.debug.print("\n===================================\n", .{});
    std.debug.print("Tutorial completed!\n", .{});
    std.debug.print("===================================\n", .{});
}

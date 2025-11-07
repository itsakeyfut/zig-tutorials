const std = @import("std");

/// forループの例を実行
pub fn run() void {
    std.debug.print("\n=== for Loop Examples ===\n", .{});

    const items = [_]i32{ 1, 2, 3, 4, 5 };

    // 要素のイテレート
    std.debug.print("\n1. Iterating over elements:\n", .{});
    for (items) |item| {
        std.debug.print("{}\n", .{item});
    }

    // インデックス付き
    std.debug.print("\n2. With index:\n", .{});
    for (items, 0..) |item, i| {
        std.debug.print("[{}] = {}\n", .{ i, item });
    }

    // 範囲（0..5 で 0 から 4 までの範囲）
    std.debug.print("\n3. Range iteration:\n", .{});
    for (0..5) |i| {
        std.debug.print("{}\n", .{i});
    }
}

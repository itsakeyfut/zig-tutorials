const std = @import("std");

// Optional型（Rustの Option<T> 相当）
fn find(items: []const i32, target: i32) ?usize {
    for (items, 0..) |item, i| {
        if (item == target) return i;
    }
    return null;
}

pub fn run() void {
    std.debug.print("\n=== Optional Type (?T) Basics ===\n", .{});

    const numbers = [_]i32{ 10, 20, 30, 40, 50 };

    // orelse でデフォルト値
    std.debug.print("\n1. Using orelse for default values:\n", .{});
    const index1 = find(&numbers, 30) orelse 999;
    std.debug.print("Index of 30: {}\n", .{index1}); // 2

    const index2 = find(&numbers, 99) orelse 999;
    std.debug.print("Index of 99: {}\n", .{index2}); // 999

    // if でパターンマッチ
    std.debug.print("\n2. Pattern matching with if:\n", .{});
    if (find(&numbers, 20)) |idx| {
        std.debug.print("Found 20 at index {}\n", .{idx});
    } else {
        std.debug.print("Not found\n", .{});
    }

    if (find(&numbers, 100)) |idx| {
        std.debug.print("Found 100 at index {}\n", .{idx});
    } else {
        std.debug.print("100 not found\n", .{});
    }

    // null チェック
    std.debug.print("\n3. Checking for null:\n", .{});
    const result = find(&numbers, 40);
    if (result == null) {
        std.debug.print("Result is null\n", .{});
    } else {
        std.debug.print("Result is not null\n", .{});
    }
}

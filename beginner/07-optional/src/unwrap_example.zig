const std = @import("std");

pub fn run() void {
    std.debug.print("\n=== Forced Unwrap with .? ===\n", .{});

    // 値がある場合
    std.debug.print("\n1. Unwrapping a value with .?:\n", .{});
    const maybe_value: ?i32 = 42;
    const value = maybe_value.?;
    std.debug.print("Value: {}\n", .{value});

    // 別の例
    std.debug.print("\n2. Unwrapping in expressions:\n", .{});
    const maybe_x: ?i32 = 10;
    const maybe_y: ?i32 = 20;
    const sum = maybe_x.? + maybe_y.?;
    std.debug.print("Sum: {}\n", .{sum});

    // null の場合は実行時エラー（コメントアウト）
    std.debug.print("\n3. Warning: unwrapping null causes panic:\n", .{});
    std.debug.print("The following code would panic if uncommented:\n", .{});
    std.debug.print("  const none: ?i32 = null;\n", .{});
    std.debug.print("  const bad = none.?;  // ❌ panic!\n", .{});
    std.debug.print("Always use 'orelse' or 'if' for safe handling.\n", .{});
}

// 安全なunwrapの代替パターン
pub fn runSafeAlternatives() void {
    std.debug.print("\n4. Safe alternatives to .?:\n", .{});

    const maybe_value: ?i32 = null;

    // orelse を使う（推奨）
    const safe1 = maybe_value orelse 0;
    std.debug.print("Using orelse: {}\n", .{safe1});

    // if を使う（推奨）
    if (maybe_value) |val| {
        std.debug.print("Using if: {}\n", .{val});
    } else {
        std.debug.print("Using if: value is null, using default\n", .{});
    }
}

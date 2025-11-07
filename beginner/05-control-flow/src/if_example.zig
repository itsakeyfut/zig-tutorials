const std = @import("std");

/// if文の例を実行
pub fn run() void {
    const x = 10;

    std.debug.print("\n=== if Statement Examples ===\n", .{});

    // if 文
    std.debug.print("\n1. Basic if statement:\n", .{});
    if (x > 5) {
        std.debug.print("x is greater than 5\n", .{});
    } else {
        std.debug.print("x is not greater than 5\n", .{});
    }

    // if 式（Rustと同じ）
    std.debug.print("\n2. if as expression (like Rust):\n", .{});
    const result = if (x > 5) "big" else "small";
    std.debug.print("x is {s}\n", .{result});

    // else if
    std.debug.print("\n3. else if chain:\n", .{});
    if (x < 0) {
        std.debug.print("negative\n", .{});
    } else if (x == 0) {
        std.debug.print("zero\n", .{});
    } else {
        std.debug.print("positive\n", .{});
    }
}

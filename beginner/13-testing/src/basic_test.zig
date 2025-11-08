//! 基本的なテストの例
//! addition関数のテストを示します

const std = @import("std");

fn add(a: i32, b: i32) i32 {
    return a + b;
}

test "basic addition" {
    const result = add(2, 3);
    try std.testing.expectEqual(5, result);
}

test "negative numbers" {
    const result = add(-5, 3);
    try std.testing.expectEqual(-2, result);
}

pub fn run() void {
    std.debug.print("\n--- Basic Test Examples ---\n", .{});
    std.debug.print("add(2, 3) = {}\n", .{add(2, 3)});
    std.debug.print("add(-5, 3) = {}\n", .{add(-5, 3)});
    std.debug.print("Run 'zig test src/basic_test.zig' to run tests\n", .{});
}

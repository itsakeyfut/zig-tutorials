const std = @import("std");

/// ジェネリック関数の定義
fn max(comptime T: type, a: T, b: T) T {
    return if (a > b) a else b;
}

/// ジェネリック関数の例を実行
pub fn run() void {
    std.debug.print("\n=== Generic Function Example ===\n", .{});

    const x = max(i32, 10, 20);
    const y = max(f32, 1.5, 2.5);

    std.debug.print("max(10, 20) = {}\n", .{x});
    std.debug.print("max(1.5, 2.5) = {}\n", .{y});
}

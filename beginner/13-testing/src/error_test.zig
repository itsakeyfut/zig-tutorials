//! エラーハンドリングのテスト例
//! エラーを返す関数のテストを示します

const std = @import("std");

const MathError = error{DivisionByZero};

fn divide(a: i32, b: i32) MathError!i32 {
    if (b == 0) return error.DivisionByZero;
    return @divTrunc(a, b);
}

test "division by zero" {
    const result = divide(10, 0);
    try std.testing.expectError(error.DivisionByZero, result);
}

test "normal division" {
    const result = try divide(10, 2);
    try std.testing.expectEqual(5, result);
}

pub fn run() void {
    std.debug.print("\n--- Error Test Examples ---\n", .{});

    // 正常な除算
    const normal = divide(10, 2) catch {
        std.debug.print("Unexpected error\n", .{});
        return;
    };
    std.debug.print("divide(10, 2) = {}\n", .{normal});

    // ゼロ除算（エラー処理）
    const zero_div = divide(10, 0);
    if (zero_div) |_| {
        std.debug.print("Should have returned error\n", .{});
    } else |err| {
        std.debug.print("divide(10, 0) = error.{s}\n", .{@errorName(err)});
    }

    std.debug.print("Run 'zig test src/error_test.zig' to run tests\n", .{});
}

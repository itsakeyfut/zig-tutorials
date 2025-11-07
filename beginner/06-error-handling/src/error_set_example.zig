const std = @import("std");

// エラーセットの定義
const MathError = error{
    DivisionByZero,
    Overflow,
    NegativeValue,
};

// エラーユニオン（Rustの Result<T, E> 相当）
fn divide(a: i32, b: i32) MathError!i32 {
    if (b == 0) return error.DivisionByZero;
    return @divTrunc(a, b);
}

fn squareRoot(value: i32) MathError!i32 {
    if (value < 0) return error.NegativeValue;
    // 簡易的な平方根（整数）
    var i: i32 = 0;
    while (i * i <= value) : (i += 1) {}
    return i - 1;
}

pub fn run() void {
    std.debug.print("\n=== Error Set Examples ===\n", .{});

    // 成功ケース
    std.debug.print("\n1. Successful division:\n", .{});
    const result = divide(10, 2) catch |err| {
        std.debug.print("Error: {}\n", .{err});
        return;
    };
    std.debug.print("Result: {}\n", .{result});

    // エラーケース: DivisionByZero
    std.debug.print("\n2. Division by zero:\n", .{});
    const result2 = divide(10, 0) catch |err| {
        std.debug.print("Error caught: {}\n", .{err});
        return;
    };
    std.debug.print("Result: {}\n", .{result2});
}

pub fn runWithNegative() void {
    std.debug.print("\n3. Square root of negative number:\n", .{});
    const result = squareRoot(-5) catch |err| {
        std.debug.print("Error caught: {}\n", .{err});
        return;
    };
    std.debug.print("Result: {}\n", .{result});
}

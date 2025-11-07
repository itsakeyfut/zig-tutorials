const std = @import("std");

// 任意のエラーを返せる
fn mightFail(should_fail: bool) anyerror!i32 {
    if (should_fail) {
        return error.SomethingWentWrong;
    }
    return 42;
}

// エラーセットを推論（!T は anyerror!T と同じ）
fn autoInferError(value: i32) !i32 {
    if (value < 0) return error.NegativeValue;
    if (value == 0) return error.ZeroValue;
    return value * 2;
}

// 複数のエラーを返す可能性がある関数
fn complexOperation(value: i32) !i32 {
    // tryを使って他の関数のエラーを伝播
    const doubled = try autoInferError(value);

    if (doubled > 100) return error.TooLarge;

    return doubled;
}

pub fn run() void {
    std.debug.print("\n=== anyerror and Inferred Error Examples ===\n", .{});

    // anyerror の例
    std.debug.print("\n1. anyerror - success case:\n", .{});
    const result1 = mightFail(false) catch |err| {
        std.debug.print("Error: {}\n", .{err});
        return;
    };
    std.debug.print("Result: {}\n", .{result1});

    std.debug.print("\n2. anyerror - failure case:\n", .{});
    const result2 = mightFail(true) catch |err| {
        std.debug.print("Error caught: {}\n", .{err});
        return;
    };
    std.debug.print("Result: {}\n", .{result2});
}

pub fn runInferred() void {
    std.debug.print("\n3. Inferred error set (!i32):\n", .{});

    // 成功ケース
    const result1 = autoInferError(10) catch |err| {
        std.debug.print("Error: {}\n", .{err});
        return;
    };
    std.debug.print("Result: {}\n", .{result1});

    // エラーケース
    std.debug.print("\n4. Negative value error:\n", .{});
    const result2 = autoInferError(-5) catch |err| {
        std.debug.print("Error caught: {}\n", .{err});
        return;
    };
    std.debug.print("Result: {}\n", .{result2});
}

pub fn runComplex() void {
    std.debug.print("\n5. Complex error propagation:\n", .{});

    // 成功ケース
    const result1 = complexOperation(10) catch |err| {
        std.debug.print("Error: {}\n", .{err});
        return;
    };
    std.debug.print("Result: {}\n", .{result1});

    // TooLargeエラー
    std.debug.print("\n6. Too large error:\n", .{});
    const result2 = complexOperation(60) catch |err| {
        std.debug.print("Error caught: {}\n", .{err});
        return;
    };
    std.debug.print("Result: {}\n", .{result2});
}

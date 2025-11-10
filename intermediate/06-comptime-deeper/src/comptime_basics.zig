//! comptime変数と関数
//! このモジュールでは、コンパイル時計算の基本を学びます。

const std = @import("std");

// コンパイル時に計算
comptime {
    var sum: i32 = 0;
    var i: i32 = 0;
    while (i < 10) : (i += 1) {
        sum += i;
    }
    std.debug.assert(sum == 45);
}

// コンパイル時関数
fn fibonacci(n: comptime_int) comptime_int {
    if (n <= 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

// 階乗の計算
fn factorial(n: comptime_int) comptime_int {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}

pub fn run() void {
    std.debug.print("\n--- comptime変数と関数 ---\n", .{});

    // コンパイル時に計算（実行時コストゼロ）
    std.debug.print("\n1. フィボナッチ数列（コンパイル時計算）:\n", .{});
    @setEvalBranchQuota(50000);
    const fib10 = comptime fibonacci(10);
    const fib15 = comptime fibonacci(15);
    const fib20 = comptime fibonacci(20);

    std.debug.print("fibonacci(10) = {}\n", .{fib10});
    std.debug.print("fibonacci(15) = {}\n", .{fib15});
    std.debug.print("fibonacci(20) = {}\n", .{fib20});

    // 階乗の計算
    std.debug.print("\n2. 階乗（コンパイル時計算）:\n", .{});
    const fact5 = comptime factorial(5);
    const fact10 = comptime factorial(10);

    std.debug.print("factorial(5) = {}\n", .{fact5});
    std.debug.print("factorial(10) = {}\n", .{fact10});

    // comptime ブロック
    std.debug.print("\n3. comptime ブロック:\n", .{});
    const sum = comptime blk: {
        var total: i32 = 0;
        var i: i32 = 1;
        while (i <= 100) : (i += 1) {
            total += i;
        }
        break :blk total;
    };
    std.debug.print("1 + 2 + ... + 100 = {}\n", .{sum});

    std.debug.print("\n解説:\n", .{});
    std.debug.print("- comptime でコンパイル時に実行\n", .{});
    std.debug.print("- 実行時コストはゼロ（定数として埋め込まれる）\n", .{});
    std.debug.print("- 再帰的な計算も可能\n", .{});
    std.debug.print("- comptime ブロックで複雑な計算も可能\n", .{});
}

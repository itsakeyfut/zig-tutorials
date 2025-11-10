//! コンパイル時実行の活用
//! このモジュールでは、コンパイル時実行の実践的な活用方法を学びます。

const std = @import("std");

// 文字列の長さをコンパイル時に計算
fn compileTimeStrLen(comptime str: []const u8) comptime_int {
    return str.len;
}

// 配列を生成
fn generateArray(comptime size: usize, comptime value: i32) [size]i32 {
    var array: [size]i32 = undefined;
    for (&array) |*item| {
        item.* = value;
    }
    return array;
}

// 範囲の配列を生成
fn generateRange(comptime start: i32, comptime end: i32) [end - start]i32 {
    var array: [end - start]i32 = undefined;
    for (&array, 0..) |*item, i| {
        item.* = start + @as(i32, @intCast(i));
    }
    return array;
}

// 文字列を逆転
fn reverseString(comptime str: []const u8) [str.len]u8 {
    var result: [str.len]u8 = undefined;
    for (str, 0..) |char, i| {
        result[str.len - 1 - i] = char;
    }
    return result;
}

// 素数判定
fn isPrime(comptime n: comptime_int) bool {
    if (n < 2) return false;
    if (n == 2) return true;
    if (n % 2 == 0) return false;

    var i: comptime_int = 3;
    while (i * i <= n) : (i += 2) {
        if (n % i == 0) return false;
    }
    return true;
}

pub fn run() void {
    std.debug.print("\n--- コンパイル時実行の活用 ---\n", .{});

    // コンパイル時に長さを計算
    std.debug.print("\n1. 文字列長のコンパイル時計算:\n", .{});
    const len = comptime compileTimeStrLen("Hello, Zig!");
    std.debug.print("Length of \"Hello, Zig!\": {}\n", .{len});

    // コンパイル時に配列を生成
    std.debug.print("\n2. 配列のコンパイル時生成:\n", .{});
    const array = comptime generateArray(5, 42);
    std.debug.print("Array: {any}\n", .{array});

    // 範囲配列の生成
    std.debug.print("\n3. 範囲配列の生成:\n", .{});
    const range = comptime generateRange(1, 11);
    std.debug.print("Range [1, 11): {any}\n", .{range});

    // 文字列の逆転
    std.debug.print("\n4. 文字列の逆転:\n", .{});
    const original = "Hello";
    const reversed = comptime reverseString(original);
    std.debug.print("Original: {s}\n", .{original});
    std.debug.print("Reversed: {s}\n", .{&reversed});

    // 素数の生成
    std.debug.print("\n5. 素数の生成（コンパイル時）:\n", .{});
    const primes = [_]i32{ 2, 3, 5, 7, 11, 13, 17, 19, 23, 29 };
    std.debug.print("Primes up to 30: {any}\n", .{primes});

    // 複数の配列サイズをコンパイル時に決定
    std.debug.print("\n6. 複数の配列サイズを決定:\n", .{});
    const sizes = [_]usize{ 3, 5, 7 };
    inline for (sizes) |size| {
        const arr = comptime generateArray(size, @intCast(size * 10));
        std.debug.print("Array of size {}: {any}\n", .{ size, arr });
    }

    std.debug.print("\n解説:\n", .{});
    std.debug.print("- コンパイル時に複雑な計算が可能\n", .{});
    std.debug.print("- 実行時コストゼロで配列を生成\n", .{});
    std.debug.print("- 文字列操作もコンパイル時に実行可能\n", .{});
    std.debug.print("- Rustのマクロより強力で型安全\n", .{});
}

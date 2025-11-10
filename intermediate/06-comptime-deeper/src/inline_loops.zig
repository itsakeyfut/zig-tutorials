//! inline for/while
//! このモジュールでは、inline ループによるアンロールを学びます。

const std = @import("std");

pub fn run() void {
    std.debug.print("\n--- inline for/while ---\n", .{});

    // inline for: ループをアンロール
    std.debug.print("\n1. inline for（ループアンロール）:\n", .{});
    std.debug.print("Numbers: ", .{});
    inline for (0..5) |i| {
        std.debug.print("{} ", .{i});
    }
    std.debug.print("\n", .{});

    // 配列の各要素に対して実行
    std.debug.print("\n2. 型のサイズを出力:\n", .{});
    const types = [_]type{ i8, i16, i32, i64 };
    inline for (types) |T| {
        std.debug.print("Size of {s}: {} bytes\n", .{ @typeName(T), @sizeOf(T) });
    }

    // タプルのイテレーション
    std.debug.print("\n3. タプルのイテレーション:\n", .{});
    const tuple = .{ 42, 3.14, "hello", true };
    inline for (tuple, 0..) |value, i| {
        std.debug.print("tuple[{}] = {any} (type: {s})\n", .{ i, value, @typeName(@TypeOf(value)) });
    }

    // 配列の各要素に対して異なる処理
    std.debug.print("\n4. 配列の各要素に対して異なる処理:\n", .{});
    const numbers = [_]comptime_int{ 1, 2, 3, 4, 5 };
    inline for (numbers) |n| {
        const squared = n * n;
        std.debug.print("{}^2 = {}\n", .{ n, squared });
    }

    // inline while
    std.debug.print("\n5. inline while:\n", .{});
    comptime var i: usize = 0;
    std.debug.print("Powers of 2: ", .{});
    inline while (i < 5) : (i += 1) {
        const power = comptime blk: {
            var result: usize = 1;
            var j: usize = 0;
            while (j < i) : (j += 1) {
                result *= 2;
            }
            break :blk result;
        };
        std.debug.print("{} ", .{power});
    }
    std.debug.print("\n", .{});

    std.debug.print("\n解説:\n", .{});
    std.debug.print("- inline for でループをアンロール\n", .{});
    std.debug.print("- コンパイル時に展開されるため高速\n", .{});
    std.debug.print("- 型のイテレーションが可能\n", .{});
    std.debug.print("- タプルの各要素を処理可能\n", .{});
}

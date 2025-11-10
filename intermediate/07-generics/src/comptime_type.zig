//! comptime type パラメータ
//! このモジュールでは、明示的な型パラメータの使い方を学びます。

const std = @import("std");

// 明示的な型パラメータ
fn swap(comptime T: type, a: *T, b: *T) void {
    const temp = a.*;
    a.* = b.*;
    b.* = temp;
}

fn sum(comptime T: type, values: []const T) T {
    var result: T = 0;
    for (values) |value| {
        result += value;
    }
    return result;
}

// 配列の平均を計算
fn average(comptime T: type, values: []const T) T {
    if (values.len == 0) return 0;
    const total = sum(T, values);
    return @divTrunc(total, @as(T, @intCast(values.len)));
}

// 最大値を見つける
fn findMax(comptime T: type, values: []const T) ?T {
    if (values.len == 0) return null;
    var max_val = values[0];
    for (values[1..]) |value| {
        if (value > max_val) {
            max_val = value;
        }
    }
    return max_val;
}

// 配列を埋める
fn fill(comptime T: type, array: []T, value: T) void {
    for (array) |*item| {
        item.* = value;
    }
}

// 配列をコピー
fn copy(comptime T: type, dest: []T, src: []const T) void {
    const len = @min(dest.len, src.len);
    for (0..len) |i| {
        dest[i] = src[i];
    }
}

pub fn run() void {
    std.debug.print("\n--- comptime type パラメータ ---\n", .{});

    std.debug.print("\n1. swap関数（値の交換）:\n", .{});
    var x: i32 = 10;
    var y: i32 = 20;
    std.debug.print("Before swap: x = {}, y = {}\n", .{ x, y });
    swap(i32, &x, &y);
    std.debug.print("After swap: x = {}, y = {}\n", .{ x, y });

    var a: f64 = 1.5;
    var b: f64 = 2.5;
    std.debug.print("Before swap: a = {d:.1}, b = {d:.1}\n", .{ a, b });
    swap(f64, &a, &b);
    std.debug.print("After swap: a = {d:.1}, b = {d:.1}\n", .{ a, b });

    std.debug.print("\n2. sum関数（合計計算）:\n", .{});
    const numbers = [_]i32{ 1, 2, 3, 4, 5 };
    const total = sum(i32, &numbers);
    std.debug.print("Sum of {any}: {}\n", .{ numbers, total });

    const floats = [_]f64{ 1.5, 2.5, 3.5 };
    const float_total = sum(f64, &floats);
    std.debug.print("Sum of {any}: {d:.1}\n", .{ floats, float_total });

    std.debug.print("\n3. average関数（平均計算）:\n", .{});
    const avg = average(i32, &numbers);
    std.debug.print("Average of {any}: {}\n", .{ numbers, avg });

    std.debug.print("\n4. findMax関数（最大値）:\n", .{});
    if (findMax(i32, &numbers)) |max_val| {
        std.debug.print("Max of {any}: {}\n", .{ numbers, max_val });
    }

    std.debug.print("\n5. fill関数（配列を埋める）:\n", .{});
    var buffer: [5]i32 = undefined;
    fill(i32, &buffer, 42);
    std.debug.print("Filled array: {any}\n", .{buffer});

    std.debug.print("\n6. copy関数（配列をコピー）:\n", .{});
    var dest: [5]i32 = undefined;
    const src = [_]i32{ 10, 20, 30, 40, 50 };
    copy(i32, &dest, &src);
    std.debug.print("Source: {any}\n", .{src});
    std.debug.print("Destination: {any}\n", .{dest});

    std.debug.print("\n解説:\n", .{});
    std.debug.print("- comptime T: type で明示的な型パラメータ\n", .{});
    std.debug.print("- 呼び出し時に型を指定する必要がある\n", .{});
    std.debug.print("- anytypeより明示的で読みやすい\n", .{});
    std.debug.print("- Rustのジェネリクス <T> に近い\n", .{});
}

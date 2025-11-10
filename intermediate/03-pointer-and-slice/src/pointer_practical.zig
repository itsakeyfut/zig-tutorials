//! ポインタの実践例
//! このモジュールでは、ポインタとスライスを実際の関数で使う例を学びます。

const std = @import("std");

// 関数外の値を変更
fn increment(ptr: *i32) void {
    ptr.* += 1;
}

// 配列を操作
fn fillArray(array: []i32, value: i32) void {
    for (array) |*item| {
        item.* = value;
    }
}

// スライスを返す
fn getSubslice(data: []const u8, start: usize, end: usize) []const u8 {
    return data[start..end];
}

// 配列の合計を計算
fn sum(values: []const i32) i32 {
    var total: i32 = 0;
    for (values) |value| {
        total += value;
    }
    return total;
}

// 配列をソート（単純なバブルソート）
fn bubbleSort(array: []i32) void {
    const n = array.len;
    var i: usize = 0;
    while (i < n) : (i += 1) {
        var j: usize = 0;
        while (j < n - 1 - i) : (j += 1) {
            if (array[j] > array[j + 1]) {
                const temp = array[j];
                array[j] = array[j + 1];
                array[j + 1] = temp;
            }
        }
    }
}

pub fn run() void {
    std.debug.print("\n--- ポインタの実践例 ---\n", .{});

    // 例1: 関数外の値を変更
    std.debug.print("\n1. 関数外の値を変更:\n", .{});
    var x: i32 = 10;
    std.debug.print("変更前: x = {}\n", .{x});
    increment(&x);
    std.debug.print("変更後: x = {}\n", .{x});

    // 例2: 配列を操作
    std.debug.print("\n2. 配列を操作:\n", .{});
    var array = [_]i32{0} ** 5;
    std.debug.print("初期化前: {any}\n", .{array});
    fillArray(&array, 42);
    std.debug.print("初期化後: {any}\n", .{array});

    // 例3: スライスを返す
    std.debug.print("\n3. スライスを返す:\n", .{});
    const data = "Hello, Zig!";
    const sub = getSubslice(data, 0, 5);
    std.debug.print("全体: {s}\n", .{data});
    std.debug.print("部分: {s}\n", .{sub});

    // 例4: 配列の合計を計算
    std.debug.print("\n4. 配列の合計を計算:\n", .{});
    const numbers = [_]i32{ 1, 2, 3, 4, 5 };
    const total = sum(&numbers);
    std.debug.print("配列: {any}\n", .{numbers});
    std.debug.print("合計: {}\n", .{total});

    // 例5: 配列をソート
    std.debug.print("\n5. 配列をソート:\n", .{});
    var unsorted = [_]i32{ 5, 2, 8, 1, 9, 3 };
    std.debug.print("ソート前: {any}\n", .{unsorted});
    bubbleSort(&unsorted);
    std.debug.print("ソート後: {any}\n", .{unsorted});

    std.debug.print("\n解説:\n", .{});
    std.debug.print("- ポインタで関数外の値を変更可能\n", .{});
    std.debug.print("- スライスで配列全体を安全に操作\n", .{});
    std.debug.print("- スライスを返すことも可能\n", .{});
    std.debug.print("- for ループの |*item| で要素のポインタを取得\n", .{});
}

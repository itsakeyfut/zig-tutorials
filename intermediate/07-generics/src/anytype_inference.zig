//! anytypeによる型推論
//! このモジュールでは、anytypeを使った型推論を学びます。

const std = @import("std");

// anytype: 呼び出し時に型推論
fn max(a: anytype, b: anytype) @TypeOf(a, b) {
    return if (a > b) a else b;
}

fn min(a: anytype, b: anytype) @TypeOf(a, b) {
    return if (a < b) a else b;
}

fn print(value: anytype) void {
    std.debug.print("Value: {any}\n", .{value});
}

// 複数の型を受け入れる関数
fn add(a: anytype, b: anytype) @TypeOf(a, b) {
    return a + b;
}

// 配列の長さを返す
fn len(array: anytype) usize {
    return array.len;
}

// 型情報を表示
fn printTypeInfo(value: anytype) void {
    const T = @TypeOf(value);
    std.debug.print("Type: {}\n", .{T});
    std.debug.print("Value: {any}\n", .{value});
}

pub fn run() void {
    std.debug.print("\n--- anytypeによる型推論 ---\n", .{});

    std.debug.print("\n1. max関数（型推論）:\n", .{});
    const x = max(10, 20);
    const y = max(1.5, 2.5);
    const z = max(@as(u8, 100), @as(u8, 200));

    std.debug.print("max(10, 20) = {}\n", .{x});
    std.debug.print("max(1.5, 2.5) = {d:.1}\n", .{y});
    std.debug.print("max(100, 200) = {}\n", .{z});

    std.debug.print("\n2. min関数:\n", .{});
    std.debug.print("min(10, 20) = {}\n", .{min(10, 20)});
    std.debug.print("min(1.5, 2.5) = {d:.1}\n", .{min(1.5, 2.5)});

    std.debug.print("\n3. print関数（任意の型を受け入れ）:\n", .{});
    print(42);
    print("hello");
    print(true);
    print(3.14);

    std.debug.print("\n4. add関数:\n", .{});
    std.debug.print("add(10, 20) = {}\n", .{add(10, 20)});
    std.debug.print("add(1.5, 2.5) = {d:.1}\n", .{add(1.5, 2.5)});

    std.debug.print("\n5. 配列の長さを取得:\n", .{});
    const arr1 = [_]i32{ 1, 2, 3, 4, 5 };
    const arr2 = [_]f64{ 1.0, 2.0, 3.0 };
    std.debug.print("arr1.len = {}\n", .{len(&arr1)});
    std.debug.print("arr2.len = {}\n", .{len(&arr2)});

    std.debug.print("\n6. 型情報の表示:\n", .{});
    printTypeInfo(42);
    printTypeInfo(3.14);
    printTypeInfo("hello");
    printTypeInfo(true);

    std.debug.print("\n解説:\n", .{});
    std.debug.print("- anytypeは呼び出し時に型が推論される\n", .{});
    std.debug.print("- @TypeOf(a, b)で共通の型を取得\n", .{});
    std.debug.print("- コンパイル時に型が決定される\n", .{});
    std.debug.print("- Rustのジェネリクスよりシンプル\n", .{});
}

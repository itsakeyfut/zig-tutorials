//! マルチアイテムポインタ
//! このモジュールでは、複数の要素を指すポインタ（長さ情報なし）の使い方を学びます。

const std = @import("std");

pub fn run() void {
    std.debug.print("\n--- マルチアイテムポインタ ---\n", .{});

    const array = [_]i32{ 1, 2, 3, 4, 5 };

    // マルチアイテムポインタ（長さ情報なし）
    const ptr: [*]const i32 = &array;

    std.debug.print("\n配列: {any}\n", .{array});
    std.debug.print("マルチアイテムポインタのアドレス: {*}\n", .{ptr});

    // インデックスでアクセス
    std.debug.print("\nインデックスでアクセス:\n", .{});
    std.debug.print("ptr[0] = {}\n", .{ptr[0]});
    std.debug.print("ptr[1] = {}\n", .{ptr[1]});
    std.debug.print("ptr[2] = {}\n", .{ptr[2]});

    // 長さは自分で管理する必要がある
    std.debug.print("\nループでアクセス（長さは手動管理）:\n", .{});
    for (0..array.len) |i| {
        std.debug.print("ptr[{}] = {}\n", .{ i, ptr[i] });
    }

    // ポインタ演算も可能
    const ptr_offset = ptr + 2;
    std.debug.print("\nポインタ演算: ptr + 2\n", .{});
    std.debug.print("(ptr + 2)[0] = {}\n", .{ptr_offset[0]}); // 3
    std.debug.print("(ptr + 2)[1] = {}\n", .{ptr_offset[1]}); // 4

    std.debug.print("\n解説:\n", .{});
    std.debug.print("- [*]T: マルチアイテムポインタ（長さ情報なし）\n", .{});
    std.debug.print("- インデックスでアクセス可能\n", .{});
    std.debug.print("- 長さは自分で管理する必要がある（危険！）\n", .{});
    std.debug.print("- ポインタ演算が可能\n", .{});
}

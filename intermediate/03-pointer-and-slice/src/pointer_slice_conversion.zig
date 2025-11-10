//! ポインタとスライスの変換
//! このモジュールでは、ポインタとスライスの間の変換方法を学びます。

const std = @import("std");

pub fn run() void {
    std.debug.print("\n--- ポインタとスライスの変換 ---\n", .{});

    var array = [_]i32{ 1, 2, 3, 4, 5 };

    // 配列 → スライス
    std.debug.print("\n1. 配列 → スライス:\n", .{});
    const slice: []i32 = &array;
    std.debug.print("slice: {any}\n", .{slice});
    std.debug.print("slice.len: {}\n", .{slice.len});

    // スライス → ポインタ
    std.debug.print("\n2. スライス → ポインタ:\n", .{});
    const ptr: [*]i32 = slice.ptr;
    std.debug.print("ptr[0]: {}\n", .{ptr[0]});
    std.debug.print("ptr[1]: {}\n", .{ptr[1]});

    // ポインタ → スライス（長さを指定）
    std.debug.print("\n3. ポインタ → スライス（長さ指定）:\n", .{});
    const new_slice: []i32 = ptr[0..5];
    std.debug.print("new_slice: {any}\n", .{new_slice});

    // 部分スライスの作成
    std.debug.print("\n4. 部分スライスの作成:\n", .{});
    const sub_slice: []i32 = ptr[1..4];
    std.debug.print("ptr[1..4]: {any}\n", .{sub_slice});

    // シングルアイテムポインタ → スライス（長さ1）
    std.debug.print("\n5. シングルアイテムポインタ → スライス:\n", .{});
    var single: i32 = 42;
    const single_ptr: *i32 = &single;
    const single_slice: []i32 = single_ptr[0..1];
    std.debug.print("single_slice[0] = {}\n", .{single_slice[0]});
    std.debug.print("single_slice.len = {}\n", .{single_slice.len});

    // スライスの変更
    std.debug.print("\n6. スライス経由でデータを変更:\n", .{});
    slice[0] = 100;
    slice[1] = 200;
    std.debug.print("変更後の配列: {any}\n", .{array});

    std.debug.print("\n解説:\n", .{});
    std.debug.print("- &array: 配列からスライスへの変換\n", .{});
    std.debug.print("- slice.ptr: スライスからポインタへの変換\n", .{});
    std.debug.print("- ptr[start..end]: ポインタからスライスへの変換\n", .{});
    std.debug.print("- single_ptr[0..1]: シングルポインタを長さ1のスライスに\n", .{});
}

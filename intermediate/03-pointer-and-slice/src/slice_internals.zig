//! スライスの内部構造
//! このモジュールでは、スライスがポインタと長さで構成されていることを学びます。

const std = @import("std");

pub fn run() void {
    std.debug.print("\n--- スライスの内部構造 ---\n", .{});

    const array = [_]i32{ 1, 2, 3, 4, 5 };

    // スライス = ポインタ + 長さ
    const slice: []const i32 = &array;

    std.debug.print("\n配列: {any}\n", .{array});
    std.debug.print("\nスライスの構造:\n", .{});
    std.debug.print("slice.ptr (ポインタ): {*}\n", .{slice.ptr});
    std.debug.print("slice.len (長さ): {}\n", .{slice.len});

    // スライスからポインタを取得
    const ptr: [*]const i32 = slice.ptr;
    std.debug.print("\nスライスから取得したポインタ:\n", .{});
    std.debug.print("ptr[0] = {}\n", .{ptr[0]});
    std.debug.print("ptr[1] = {}\n", .{ptr[1]});

    // スライスは安全にアクセスできる
    std.debug.print("\nスライス経由でアクセス:\n", .{});
    for (slice, 0..) |value, i| {
        std.debug.print("slice[{}] = {}\n", .{ i, value });
    }

    // サブスライスの作成
    const sub_slice = slice[1..4];
    std.debug.print("\nサブスライス slice[1..4]:\n", .{});
    std.debug.print("sub_slice: {any}\n", .{sub_slice});
    std.debug.print("sub_slice.len: {}\n", .{sub_slice.len});

    std.debug.print("\n解説:\n", .{});
    std.debug.print("- []T: スライス = ポインタ + 長さ\n", .{});
    std.debug.print("- slice.ptr: マルチアイテムポインタ\n", .{});
    std.debug.print("- slice.len: 長さ情報\n", .{});
    std.debug.print("- 境界チェックあり（安全）\n", .{});
    std.debug.print("- サブスライスの作成が簡単\n", .{});
}

//! シングルアイテムポインタ
//! このモジュールでは、単一の値を指すポインタの使い方を学びます。

const std = @import("std");

pub fn run() void {
    std.debug.print("\n--- シングルアイテムポインタ ---\n", .{});

    var x: i32 = 42;

    // ポインタの作成
    const ptr: *i32 = &x;
    const const_ptr: *const i32 = &x;

    std.debug.print("\n元の値: x = {}\n", .{x});
    std.debug.print("ポインタのアドレス: {*}\n", .{ptr});

    // 参照外し
    std.debug.print("ポインタ経由で値を読む: ptr.* = {}\n", .{ptr.*});

    // ポインタ経由で変更
    ptr.* = 100;
    std.debug.print("\nポインタ経由で変更: ptr.* = 100\n", .{});
    std.debug.print("変更後の値: x = {}\n", .{x});

    // const ポインタは変更不可
    std.debug.print("\nconst ポインタで値を読む: const_ptr.* = {}\n", .{const_ptr.*});
    std.debug.print("const ポインタは変更不可（コンパイルエラーになる）\n", .{});
    // const_ptr.* = 200;  // ❌ エラー: cannot assign to constant

    std.debug.print("\n解説:\n", .{});
    std.debug.print("- *T: 変更可能なポインタ\n", .{});
    std.debug.print("- *const T: 読み取り専用ポインタ\n", .{});
    std.debug.print("- &x: ポインタの作成\n", .{});
    std.debug.print("- ptr.*: ポインタの参照外し（明示的）\n", .{});
}

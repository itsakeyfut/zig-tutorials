//! Zigポインタとスライスのチュートリアル
//! このプログラムは、ポインタの種類、スライスの内部構造、変換方法など
//! ポインタとスライスの使い方を学びます。

const std = @import("std");

// 各例のモジュールをインポート
const single_item_pointer = @import("single_item_pointer.zig");
const multi_item_pointer = @import("multi_item_pointer.zig");
const slice_internals = @import("slice_internals.zig");
const pointer_slice_conversion = @import("pointer_slice_conversion.zig");
const pointer_practical = @import("pointer_practical.zig");

pub fn main() void {
    std.debug.print("===================================\n", .{});
    std.debug.print("Zig Pointers and Slices\n", .{});
    std.debug.print("===================================\n", .{});

    // 各ポインタとスライスのパターンを実行
    single_item_pointer.run();
    multi_item_pointer.run();
    slice_internals.run();
    pointer_slice_conversion.run();
    pointer_practical.run();

    std.debug.print("\n===================================\n", .{});
    std.debug.print("Tutorial completed!\n", .{});
    std.debug.print("===================================\n", .{});
}

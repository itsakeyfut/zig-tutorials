//! Zigエラーハンドリングのチュートリアル
//! このプログラムは、エラーセット、try、catch、anyerrorの使い方を示します。

const std = @import("std");

// 各例のモジュールをインポート
const error_set_example = @import("error_set_example.zig");
const try_catch_example = @import("try_catch_example.zig");
const anyerror_example = @import("anyerror_example.zig");

pub fn main() void {
    std.debug.print("===================================\n", .{});
    std.debug.print("Zig Error Handling Tutorial\n", .{});
    std.debug.print("===================================\n", .{});

    // エラーセットの例
    error_set_example.run();
    error_set_example.runWithNegative();

    // tryとcatchの例
    try_catch_example.run();
    try_catch_example.runPermissionDenied();

    // anyerrorと推論の例
    anyerror_example.run();
    anyerror_example.runInferred();
    anyerror_example.runComplex();

    std.debug.print("\n===================================\n", .{});
    std.debug.print("Tutorial completed!\n", .{});
    std.debug.print("===================================\n", .{});
}

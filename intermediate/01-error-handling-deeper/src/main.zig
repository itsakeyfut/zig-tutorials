//! Zigエラー処理の深掘りチュートリアル
//! このプログラムは、エラーセットの組み合わせ、推論、カスタムエラー設計、
//! errdeferの実践パターンなどの高度なエラー処理の使い方を示します。

const std = @import("std");

// 各例のモジュールをインポート
const error_sets = @import("error_sets.zig");
const error_inference = @import("error_inference.zig");
const custom_errors = @import("custom_errors.zig");
const errdefer_pattern = @import("errdefer_pattern.zig");

pub fn main() !void {
    std.debug.print("===================================\n", .{});
    std.debug.print("Zig Error Handling (Deep Dive)\n", .{});
    std.debug.print("===================================\n", .{});

    // 各エラー処理パターンの例を実行
    error_sets.run();
    error_inference.run();
    custom_errors.run();
    try errdefer_pattern.run();

    std.debug.print("\n===================================\n", .{});
    std.debug.print("Tutorial completed!\n", .{});
    std.debug.print("===================================\n", .{});
}

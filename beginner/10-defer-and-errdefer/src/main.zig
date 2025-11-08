//! Zig defer と errdefer のチュートリアル
//! このプログラムは、defer と errdefer の使い方を示します。

const std = @import("std");

// 各例のモジュールをインポート
const defer_basic = @import("defer_basic.zig");
const resource_management = @import("resource_management.zig");
const errdefer_example = @import("errdefer_example.zig");
const multiple_defer = @import("multiple_defer.zig");

pub fn main() !void {
    std.debug.print("===================================\n", .{});
    std.debug.print("Zig defer and errdefer Tutorial\n", .{});
    std.debug.print("===================================\n", .{});

    // 各例を実行
    try defer_basic.run();
    try resource_management.run();
    try errdefer_example.run();
    multiple_defer.run();

    std.debug.print("\n===================================\n", .{});
    std.debug.print("Tutorial completed!\n", .{});
    std.debug.print("===================================\n", .{});
}

const std = @import("std");

/// comptime変数の例を実行
pub fn run() void {
    std.debug.print("\n=== Comptime Variable Example ===\n", .{});

    // コンパイル時に計算
    comptime var x = 0;
    inline for (0..5) |i| {
        x += i;
    }

    std.debug.print("Sum: {}\n", .{x}); // 10
}

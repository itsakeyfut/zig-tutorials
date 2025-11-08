const std = @import("std");

/// @intCast（整数キャスト）の例を実行
pub fn run() void {
    std.debug.print("\n=== @intCast (Integer Cast) Example ===\n", .{});

    const x: i32 = 1000;
    const y: i16 = @intCast(x);

    std.debug.print("y = {}\n", .{y});
}

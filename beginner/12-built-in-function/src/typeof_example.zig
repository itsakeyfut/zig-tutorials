const std = @import("std");

/// @TypeOf（型取得）の例を実行
pub fn run() void {
    std.debug.print("\n=== @TypeOf (Get Type) Example ===\n", .{});

    const x = 10;
    const y = 3.14;

    std.debug.print("Type of x: {}\n", .{@TypeOf(x)});
    std.debug.print("Type of y: {}\n", .{@TypeOf(y)});
}

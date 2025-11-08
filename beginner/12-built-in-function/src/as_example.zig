const std = @import("std");

/// @as（型変換）の例を実行
pub fn run() void {
    std.debug.print("\n=== @as (Type Conversion) Example ===\n", .{});

    const x: i32 = 10;
    const y = @as(f32, @floatFromInt(x));

    std.debug.print("x = {}, y = {}\n", .{ x, y });
}

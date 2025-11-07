const std = @import("std");

/// switchの例を実行
pub fn run() void {
    std.debug.print("\n=== switch Statement Examples (like Rust's match) ===\n", .{});

    const value = 2;

    // switch 式
    std.debug.print("\n1. Basic switch expression:\n", .{});
    const result = switch (value) {
        1 => "one",
        2 => "two",
        3 => "three",
        else => "other",
    };
    std.debug.print("value is {s}\n", .{result});

    // 複数の値
    std.debug.print("\n2. Multiple values:\n", .{});
    const category = switch (value) {
        1, 2, 3 => "small",
        4, 5, 6 => "medium",
        else => "large",
    };
    std.debug.print("category: {s}\n", .{category});

    // 範囲
    std.debug.print("\n3. Range matching:\n", .{});
    const range_result = switch (value) {
        0...9 => "single digit",
        10...99 => "double digit",
        else => "large",
    };
    std.debug.print("range result: {s}\n", .{range_result});
}

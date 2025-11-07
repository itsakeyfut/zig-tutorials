const std = @import("std");

pub fn run() void {
    std.debug.print("\n=== Slice Basics ===\n", .{});

    const array = [_]i32{ 1, 2, 3, 4, 5 };

    // 配列全体のスライス
    std.debug.print("\n1. Slicing entire array:\n", .{});
    const slice1: []const i32 = &array;
    std.debug.print("slice1: []const i32 = &array\n", .{});
    std.debug.print("slice1.len = {}\n", .{slice1.len});

    // 部分スライス
    std.debug.print("\n2. Partial slice [1..4]:\n", .{});
    const slice2 = array[1..4]; // [2, 3, 4]
    std.debug.print("slice2 = array[1..4]\n", .{});
    std.debug.print("slice2: ", .{});
    for (slice2) |item| {
        std.debug.print("{} ", .{item});
    }
    std.debug.print("\n", .{});

    // 開始のみ指定
    std.debug.print("\n3. Slice from index [2..]:\n", .{});
    const slice3 = array[2..]; // [3, 4, 5]
    std.debug.print("slice3 = array[2..]\n", .{});
    std.debug.print("slice3: ", .{});
    for (slice3) |item| {
        std.debug.print("{} ", .{item});
    }
    std.debug.print("\n", .{});

    // 終了のみ指定
    std.debug.print("\n4. Slice up to index [0..3]:\n", .{});
    const slice4 = array[0..3]; // [1, 2, 3]
    std.debug.print("slice4 = array[0..3]\n", .{});
    std.debug.print("slice4: ", .{});
    for (slice4) |item| {
        std.debug.print("{} ", .{item});
    }
    std.debug.print("\n", .{});

    // for ループでの使用
    std.debug.print("\n5. Iterating over slice:\n", .{});
    std.debug.print("for (slice2) |item| {{ ... }}\n", .{});
    for (slice2) |item| {
        std.debug.print("  item: {}\n", .{item});
    }
}

const std = @import("std");

pub fn run() void {
    std.debug.print("\n=== Mutable Slice ===\n", .{});

    var array = [_]i32{ 1, 2, 3, 4, 5 };

    std.debug.print("\n1. Original array:\n", .{});
    std.debug.print("array: ", .{});
    for (array) |item| {
        std.debug.print("{} ", .{item});
    }
    std.debug.print("\n", .{});

    // 可変スライス
    std.debug.print("\n2. Creating mutable slice:\n", .{});
    const slice: []i32 = &array;
    std.debug.print("slice: []i32 = &array\n", .{});

    // 値を変更
    std.debug.print("\n3. Modifying values through slice:\n", .{});
    std.debug.print("slice[0] = 10\n", .{});
    std.debug.print("slice[1] = 20\n", .{});
    slice[0] = 10;
    slice[1] = 20;

    std.debug.print("\n4. Updated slice:\n", .{});
    std.debug.print("slice: ", .{});
    for (slice) |item| {
        std.debug.print("{} ", .{item});
    }
    std.debug.print("\n", .{});

    std.debug.print("\n5. Original array is also modified:\n", .{});
    std.debug.print("array: ", .{});
    for (array) |item| {
        std.debug.print("{} ", .{item});
    }
    std.debug.print("\n", .{});
}

pub fn runConstVsMutable() void {
    std.debug.print("\n=== Const vs Mutable Slices ===\n", .{});

    var numbers = [_]i32{ 1, 2, 3, 4, 5 };

    std.debug.print("\n1. Const slice (read-only):\n", .{});
    const const_slice: []const i32 = &numbers;
    std.debug.print("const_slice: []const i32 = &numbers\n", .{});
    std.debug.print("Can read: const_slice[0] = {}\n", .{const_slice[0]});
    std.debug.print("Cannot modify: const_slice[0] = 10  // ❌ compile error\n", .{});

    std.debug.print("\n2. Mutable slice (read-write):\n", .{});
    const mut_slice: []i32 = &numbers;
    std.debug.print("mut_slice: []i32 = &numbers\n", .{});
    std.debug.print("Can read: mut_slice[0] = {}\n", .{mut_slice[0]});
    std.debug.print("Can modify: mut_slice[0] = 100\n", .{});
    mut_slice[0] = 100;
    std.debug.print("After modification: mut_slice[0] = {}\n", .{mut_slice[0]});

    std.debug.print("\n3. Important notes:\n", .{});
    std.debug.print("- []const T: immutable slice (like &[T] in Rust)\n", .{});
    std.debug.print("- []T: mutable slice (like &mut [T] in Rust)\n", .{});
    std.debug.print("- Slices are views into arrays, not copies\n", .{});
}

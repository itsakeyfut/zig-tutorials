const std = @import("std");

pub fn run() void {
    std.debug.print("\n=== Array Basics ===\n", .{});

    // 配列の宣言
    std.debug.print("\n1. Array declaration:\n", .{});
    const array1 = [5]i32{ 1, 2, 3, 4, 5 };
    std.debug.print("array1: [5]i32 = {{ 1, 2, 3, 4, 5 }}\n", .{});

    // 型推論（[_] で要素数を推論）
    std.debug.print("\n2. Type inference with [_]:\n", .{});
    const array2 = [_]i32{ 10, 20, 30 };
    std.debug.print("array2: [_]i32 = {{ 10, 20, 30 }}\n", .{});
    std.debug.print("array2 actual type: [{}]i32\n", .{array2.len});

    // 要素にアクセス
    std.debug.print("\n3. Accessing elements:\n", .{});
    std.debug.print("array1[0] = {}\n", .{array1[0]});
    std.debug.print("array1[4] = {}\n", .{array1[4]});

    // 長さ
    std.debug.print("\n4. Array length:\n", .{});
    std.debug.print("array1.len = {}\n", .{array1.len});
    std.debug.print("array2.len = {}\n", .{array2.len});

    // 繰り返し初期化
    std.debug.print("\n5. Repeated initialization:\n", .{});
    const zeros = [_]i32{0} ** 10; // [0, 0, 0, ..., 0]
    std.debug.print("zeros: [_]i32{{0}} ** 10\n", .{});
    std.debug.print("zeros[0] = {}, zeros[9] = {}\n", .{ zeros[0], zeros[9] });
    std.debug.print("All elements are zero (length: {})\n", .{zeros.len});
}

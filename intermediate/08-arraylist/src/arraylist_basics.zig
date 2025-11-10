//! ArrayListの基本
//! このモジュールでは、ArrayListの基本的な使い方を学びます。

const std = @import("std");

pub fn run() !void {
    std.debug.print("\n--- ArrayListの基本 ---\n", .{});

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    std.debug.print("\n1. ArrayListの作成と要素の追加:\n", .{});
    var list = std.ArrayList(i32).init(allocator);
    defer list.deinit();

    // 要素の追加
    try list.append(10);
    try list.append(20);
    try list.append(30);
    try list.append(40);
    try list.append(50);

    std.debug.print("Length: {}\n", .{list.items.len});
    std.debug.print("Capacity: {}\n", .{list.capacity});

    std.debug.print("\n2. 要素へのアクセス:\n", .{});
    for (list.items, 0..) |item, i| {
        std.debug.print("[{}] = {}\n", .{ i, item });
    }

    std.debug.print("\n3. 要素の削除（pop）:\n", .{});
    const popped = list.pop();
    std.debug.print("Popped: {?}\n", .{popped});
    std.debug.print("New length: {}\n", .{list.items.len});

    std.debug.print("\n4. 要素の挿入:\n", .{});
    try list.insert(1, 15);
    std.debug.print("After insert(1, 15):\n", .{});
    for (list.items, 0..) |item, i| {
        std.debug.print("[{}] = {}\n", .{ i, item });
    }

    std.debug.print("\n5. 特定の要素の削除:\n", .{});
    const removed = list.orderedRemove(2);
    std.debug.print("Removed element at index 2: {}\n", .{removed});
    std.debug.print("After orderedRemove(2):\n", .{});
    for (list.items, 0..) |item, i| {
        std.debug.print("[{}] = {}\n", .{ i, item });
    }

    std.debug.print("\n6. 複数要素の追加（appendSlice）:\n", .{});
    const new_items = [_]i32{ 60, 70, 80 };
    try list.appendSlice(&new_items);
    std.debug.print("After appendSlice:\n", .{});
    for (list.items, 0..) |item, i| {
        std.debug.print("[{}] = {}\n", .{ i, item });
    }

    std.debug.print("\n7. 容量の確保（ensureTotalCapacity）:\n", .{});
    std.debug.print("Current capacity: {}\n", .{list.capacity});
    try list.ensureTotalCapacity(20);
    std.debug.print("After ensureTotalCapacity(20): {}\n", .{list.capacity});

    std.debug.print("\n8. クリア（clearRetainingCapacity）:\n", .{});
    list.clearRetainingCapacity();
    std.debug.print("Length after clear: {}\n", .{list.items.len});
    std.debug.print("Capacity after clear: {}\n", .{list.capacity});

    std.debug.print("\n9. 文字列のArrayList:\n", .{});
    var string_list = std.ArrayList([]const u8).init(allocator);
    defer string_list.deinit();

    try string_list.append("hello");
    try string_list.append("world");
    try string_list.append("zig");

    std.debug.print("String list:\n", .{});
    for (string_list.items, 0..) |item, i| {
        std.debug.print("[{}] = {s}\n", .{ i, item });
    }

    std.debug.print("\n解説:\n", .{});
    std.debug.print("- ArrayList は動的配列（Rustの Vec と同等）\n", .{});
    std.debug.print("- init() でアロケータを渡して初期化\n", .{});
    std.debug.print("- append() で要素を追加\n", .{});
    std.debug.print("- items フィールドでスライスとしてアクセス\n", .{});
    std.debug.print("- deinit() で必ずメモリを解放\n", .{});
}

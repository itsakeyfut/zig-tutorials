//! アロケータの実践
//! このモジュールでは、アロケータを使った実践的なパターンを学びます。

const std = @import("std");

// 一時的なデータ構造を使う関数
fn processData(allocator: std.mem.Allocator) !void {
    var list = std.ArrayList([]const u8).init(allocator);
    defer list.deinit();

    try list.append("hello");
    try list.append("world");
    try list.append("zig");

    std.debug.print("Processing data:\n", .{});
    for (list.items) |item| {
        std.debug.print("  - {s}\n", .{item});
    }
}

// 複数のデータ構造を使う関数
fn complexOperation(allocator: std.mem.Allocator) !void {
    var numbers = std.ArrayList(i32).init(allocator);
    defer numbers.deinit();

    var names = std.ArrayList([]const u8).init(allocator);
    defer names.deinit();

    // データの追加
    try numbers.append(1);
    try numbers.append(2);
    try numbers.append(3);

    try names.append("Alice");
    try names.append("Bob");
    try names.append("Charlie");

    std.debug.print("Complex operation:\n", .{});
    std.debug.print("  Numbers: {any}\n", .{numbers.items});
    std.debug.print("  Names: {any}\n", .{names.items});
}

// ArenaAllocatorで一括管理
fn processWithArena(arena_allocator: std.mem.Allocator) !void {
    // ArenaAllocator を使うと、個々の deinit() が不要
    var list1 = std.ArrayList(i32).init(arena_allocator);
    var list2 = std.ArrayList([]const u8).init(arena_allocator);
    var map = std.StringHashMap(i32).init(arena_allocator);

    // deinit() は不要（arena.deinit() で一括解放される）

    try list1.append(10);
    try list1.append(20);

    try list2.append("hello");
    try list2.append("world");

    try map.put("answer", 42);

    std.debug.print("Arena allocator contents:\n", .{});
    std.debug.print("  List1: {any}\n", .{list1.items});
    std.debug.print("  List2: {any}\n", .{list2.items});
    std.debug.print("  Map['answer']: {}\n", .{map.get("answer").?});
}

// メモリ使用量を計測
fn measureMemoryUsage(allocator: std.mem.Allocator) !void {
    std.debug.print("\nMemory usage measurement:\n", .{});

    var list = std.ArrayList(i32).init(allocator);
    defer list.deinit();

    std.debug.print("Initial capacity: {}\n", .{list.capacity});

    // 要素を追加していく
    var i: i32 = 0;
    while (i < 100) : (i += 1) {
        try list.append(i);

        // 容量が変わったら通知
        if (i == 0 or list.capacity != list.items.len) {
            if (i > 0) {
                std.debug.print("After {} items: capacity = {}\n", .{ i + 1, list.capacity });
            }
        }
    }

    std.debug.print("Final: {} items, capacity = {}\n", .{ list.items.len, list.capacity });
}

pub fn run() !void {
    std.debug.print("\n--- アロケータの実践 ---\n", .{});

    std.debug.print("\n1. 関数にアロケータを渡す:\n", .{});
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    try processData(allocator);

    std.debug.print("\n2. 複数のデータ構造を使う:\n", .{});
    try complexOperation(allocator);

    std.debug.print("\n3. ArenaAllocatorで一括管理:\n", .{});
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit(); // 全てまとめて解放

    const arena_allocator = arena.allocator();
    try processWithArena(arena_allocator);
    std.debug.print("  (全てのメモリは arena.deinit() で解放されます)\n", .{});

    std.debug.print("\n4. メモリ使用量の計測:\n", .{});
    try measureMemoryUsage(allocator);

    std.debug.print("\n5. FixedBufferAllocatorの使用:\n", .{});
    var buffer: [1024]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const fba_allocator = fba.allocator();

    var small_list = std.ArrayList(i32).init(fba_allocator);
    defer small_list.deinit();

    try small_list.append(1);
    try small_list.append(2);
    try small_list.append(3);

    std.debug.print("FixedBufferAllocator list: {any}\n", .{small_list.items});
    std.debug.print("Used bytes: {}\n", .{fba.end_index});

    std.debug.print("\n解説:\n", .{});
    std.debug.print("- 関数にアロケータを渡すパターンが一般的\n", .{});
    std.debug.print("- ArenaAllocator で一括管理すると deinit() 忘れを防げる\n", .{});
    std.debug.print("- FixedBufferAllocator はスタック上のメモリを使用\n", .{});
    std.debug.print("- Rustは所有権で管理、Zigは明示的なアロケータ\n", .{});
}

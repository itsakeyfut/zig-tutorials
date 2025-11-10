//! HashMapの基本
//! このモジュールでは、HashMapの基本的な使い方を学びます。

const std = @import("std");

pub fn run() !void {
    std.debug.print("\n--- HashMapの基本 ---\n", .{});

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    std.debug.print("\n1. HashMapの作成と要素の追加:\n", .{});
    var map = std.StringHashMap(i32).init(allocator);
    defer map.deinit();

    // 要素の追加
    try map.put("alice", 30);
    try map.put("bob", 25);
    try map.put("charlie", 35);
    try map.put("diana", 28);

    std.debug.print("Map size: {}\n", .{map.count()});

    std.debug.print("\n2. 要素の取得:\n", .{});
    if (map.get("alice")) |age| {
        std.debug.print("Alice is {} years old\n", .{age});
    }

    if (map.get("bob")) |age| {
        std.debug.print("Bob is {} years old\n", .{age});
    }

    // 存在しないキー
    if (map.get("unknown")) |age| {
        std.debug.print("Unknown: {}\n", .{age});
    } else {
        std.debug.print("'unknown' key does not exist\n", .{});
    }

    std.debug.print("\n3. 要素の存在確認:\n", .{});
    std.debug.print("Contains 'bob': {}\n", .{map.contains("bob")});
    std.debug.print("Contains 'unknown': {}\n", .{map.contains("unknown")});

    std.debug.print("\n4. イテレート:\n", .{});
    var iter = map.iterator();
    while (iter.next()) |entry| {
        std.debug.print("{s}: {}\n", .{ entry.key_ptr.*, entry.value_ptr.* });
    }

    std.debug.print("\n5. 要素の更新:\n", .{});
    try map.put("alice", 31); // 上書き
    std.debug.print("Alice's new age: {}\n", .{map.get("alice").?});

    std.debug.print("\n6. 要素の削除:\n", .{});
    _ = map.remove("charlie");
    std.debug.print("After removing 'charlie', map size: {}\n", .{map.count()});
    std.debug.print("Contains 'charlie': {}\n", .{map.contains("charlie")});

    std.debug.print("\n7. getOrPut（存在すれば取得、なければ追加）:\n", .{});
    const result = try map.getOrPut("eve");
    if (!result.found_existing) {
        result.value_ptr.* = 27;
        std.debug.print("Added 'eve' with age 27\n", .{});
    } else {
        std.debug.print("'eve' already exists with age {}\n", .{result.value_ptr.*});
    }

    std.debug.print("\n8. AutoHashMapの使用（任意の型のキー）:\n", .{});
    var int_map = std.AutoHashMap(i32, []const u8).init(allocator);
    defer int_map.deinit();

    try int_map.put(1, "one");
    try int_map.put(2, "two");
    try int_map.put(3, "three");

    std.debug.print("Integer keys:\n", .{});
    var int_iter = int_map.iterator();
    while (int_iter.next()) |entry| {
        std.debug.print("{}: {s}\n", .{ entry.key_ptr.*, entry.value_ptr.* });
    }

    std.debug.print("\n9. 構造体をキーとして使用:\n", .{});
    const Point = struct {
        x: i32,
        y: i32,

        pub fn hash(self: @This()) u64 {
            var hasher = std.hash.Wyhash.init(0);
            std.hash.autoHash(&hasher, self.x);
            std.hash.autoHash(&hasher, self.y);
            return hasher.final();
        }

        pub fn eql(self: @This(), other: @This()) bool {
            return self.x == other.x and self.y == other.y;
        }
    };

    var point_map = std.HashMap(Point, []const u8, struct {
        pub fn hash(_: @This(), key: Point) u64 {
            return key.hash();
        }
        pub fn eql(_: @This(), a: Point, b: Point) bool {
            return a.eql(b);
        }
    }, std.hash_map.default_max_load_percentage).init(allocator);
    defer point_map.deinit();

    try point_map.put(.{ .x = 0, .y = 0 }, "origin");
    try point_map.put(.{ .x = 1, .y = 1 }, "diagonal");

    if (point_map.get(.{ .x = 0, .y = 0 })) |value| {
        std.debug.print("Point (0, 0): {s}\n", .{value});
    }

    std.debug.print("\n解説:\n", .{});
    std.debug.print("- StringHashMap は文字列キーのハッシュマップ\n", .{});
    std.debug.print("- AutoHashMap は任意の型をキーにできる\n", .{});
    std.debug.print("- put() で要素を追加/更新\n", .{});
    std.debug.print("- get() で要素を取得（Optional）\n", .{});
    std.debug.print("- iterator() でイテレート\n", .{});
}

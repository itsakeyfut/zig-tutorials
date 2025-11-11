//! std.json（JSON処理）の例
//! JSONのシリアライズとデシリアライズ（パース）を示します。

const std = @import("std");

const User = struct {
    id: u32,
    name: []const u8,
    email: []const u8,
    active: bool,
};

pub fn run(allocator: std.mem.Allocator) !void {
    std.debug.print("\n--- std.json（JSON処理）---\n", .{});

    // JSONのシリアライズ
    const user = User{
        .id = 1,
        .name = "Alice",
        .email = "alice@example.com",
        .active = true,
    };

    var buffer = std.ArrayList(u8).init(allocator);
    defer buffer.deinit();

    try std.json.stringify(user, .{}, buffer.writer());

    std.debug.print("JSON: {s}\n", .{buffer.items});

    // JSONのデシリアライズ
    const json_text =
        \\{
        \\  "id": 2,
        \\  "name": "Bob",
        \\  "email": "bob@example.com",
        \\  "active": false
        \\}
    ;

    const parsed = try std.json.parseFromSlice(
        User,
        allocator,
        json_text,
        .{},
    );
    defer parsed.deinit();

    std.debug.print("Parsed: {s}\n", .{parsed.value.name});
}

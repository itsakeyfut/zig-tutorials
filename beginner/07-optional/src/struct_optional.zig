const std = @import("std");

const User = struct {
    name: []const u8,
    email: ?[]const u8, // emailはオプショナル
    age: ?u32, // ageもオプショナル
};

fn getUserEmail(user: User) []const u8 {
    return user.email orelse "no-email@example.com";
}

fn getUserAge(user: User) u32 {
    return user.age orelse 0;
}

pub fn run() void {
    std.debug.print("\n=== Optional in Structs ===\n", .{});

    // emailがある場合
    std.debug.print("\n1. User with email:\n", .{});
    const user1 = User{
        .name = "Alice",
        .email = "alice@example.com",
        .age = 30,
    };
    std.debug.print("{s}: {s}, age: {}\n", .{ user1.name, getUserEmail(user1), getUserAge(user1) });

    // emailがnullの場合
    std.debug.print("\n2. User without email:\n", .{});
    const user2 = User{
        .name = "Bob",
        .email = null,
        .age = 25,
    };
    std.debug.print("{s}: {s}, age: {}\n", .{ user2.name, getUserEmail(user2), getUserAge(user2) });

    // ageもnullの場合
    std.debug.print("\n3. User without email and age:\n", .{});
    const user3 = User{
        .name = "Charlie",
        .email = null,
        .age = null,
    };
    std.debug.print("{s}: {s}, age: {}\n", .{ user3.name, getUserEmail(user3), getUserAge(user3) });

    // if でパターンマッチング
    std.debug.print("\n4. Pattern matching on optional fields:\n", .{});
    if (user1.email) |email| {
        std.debug.print("{s} has email: {s}\n", .{ user1.name, email });
    } else {
        std.debug.print("{s} has no email\n", .{user1.name});
    }

    if (user2.email) |email| {
        std.debug.print("{s} has email: {s}\n", .{ user2.name, email });
    } else {
        std.debug.print("{s} has no email\n", .{user2.name});
    }
}

// Optional を返す関数
fn findUserByName(users: []const User, name: []const u8) ?User {
    for (users) |user| {
        if (std.mem.eql(u8, user.name, name)) {
            return user;
        }
    }
    return null;
}

pub fn runSearch() void {
    std.debug.print("\n5. Returning optional from functions:\n", .{});

    const users = [_]User{
        User{ .name = "Alice", .email = "alice@example.com", .age = 30 },
        User{ .name = "Bob", .email = null, .age = 25 },
        User{ .name = "Charlie", .email = null, .age = null },
    };

    // ユーザーが見つかる場合
    if (findUserByName(&users, "Alice")) |user| {
        std.debug.print("Found user: {s}\n", .{user.name});
    } else {
        std.debug.print("User not found\n", .{});
    }

    // ユーザーが見つからない場合
    if (findUserByName(&users, "David")) |user| {
        std.debug.print("Found user: {s}\n", .{user.name});
    } else {
        std.debug.print("User 'David' not found\n", .{});
    }
}

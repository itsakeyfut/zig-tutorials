//! カスタムエラーの設計の例
//! このモジュールでは、レイヤーごとにエラーを定義し、組み合わせる方法を示します。

const std = @import("std");

// レイヤーごとにエラーを定義
const DatabaseError = error{
    ConnectionFailed,
    QueryFailed,
    TransactionFailed,
};

const ValidationError = error{
    InvalidEmail,
    InvalidPassword,
    UsernameTooShort,
};

const AuthError = DatabaseError || ValidationError;

const User = struct {
    id: u32,
    username: []const u8,
    email: []const u8,
};

fn validateUsername(username: []const u8) ValidationError!void {
    if (username.len < 3) {
        return error.UsernameTooShort;
    }
}

fn validateEmail(email: []const u8) ValidationError!void {
    if (std.mem.indexOf(u8, email, "@") == null) {
        return error.InvalidEmail;
    }
}

fn createUser(username: []const u8, email: []const u8) AuthError!User {
    // バリデーション（エラーは自動で伝播）
    try validateUsername(username);
    try validateEmail(email);

    // データベース操作をシミュレート
    if (std.mem.eql(u8, username, "error")) {
        return error.ConnectionFailed;
    }

    return User{
        .id = 1,
        .username = username,
        .email = email,
    };
}

pub fn run() void {
    std.debug.print("\n--- カスタムエラーの設計 ---\n", .{});

    // 正常ケース
    const user1 = createUser("alice", "alice@example.com") catch |err| {
        handleError(err);
        return;
    };
    std.debug.print("Created user: {s}\n", .{user1.username});

    // バリデーションエラー: UsernameTooShort
    _ = createUser("ab", "ab@example.com") catch |err| {
        handleError(err);
    };

    // バリデーションエラー: InvalidEmail
    _ = createUser("bob", "bobexample.com") catch |err| {
        handleError(err);
    };

    // データベースエラー: ConnectionFailed
    _ = createUser("error", "error@example.com") catch |err| {
        handleError(err);
    };

    std.debug.print("\n解説:\n", .{});
    std.debug.print("- レイヤーごとにエラーを定義することで、責任を分離\n", .{});
    std.debug.print("- エラーセットの組み合わせで柔軟な設計が可能\n", .{});
    std.debug.print("- try で自動的にエラーを伝播\n", .{});
}

fn handleError(err: AuthError) void {
    switch (err) {
        error.UsernameTooShort => {
            std.debug.print("Error: Username must be at least 3 characters\n", .{});
        },
        error.InvalidEmail => {
            std.debug.print("Error: Invalid email format\n", .{});
        },
        error.ConnectionFailed => {
            std.debug.print("Error: Database connection failed\n", .{});
        },
        else => {
            std.debug.print("Error: Unknown error {}\n", .{err});
        },
    }
}

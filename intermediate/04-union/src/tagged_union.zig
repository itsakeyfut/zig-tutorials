//! タグ付きユニオン
//! このモジュールでは、タグ付きユニオン（Rustのenum相当）の使い方を学びます。

const std = @import("std");

// タグ付きユニオン
const Result = union(enum) {
    ok: i32,
    err: []const u8,

    pub fn isOk(self: Result) bool {
        return switch (self) {
            .ok => true,
            .err => false,
        };
    }

    pub fn isErr(self: Result) bool {
        return !self.isOk();
    }
};

pub fn run() void {
    std.debug.print("\n--- タグ付きユニオン ---\n", .{});

    const success = Result{ .ok = 42 };
    const failure = Result{ .err = "Something went wrong" };

    std.debug.print("\n1. タグ付きユニオンの作成:\n", .{});
    std.debug.print("success: Result{{ .ok = 42 }}\n", .{});
    std.debug.print("failure: Result{{ .err = \"Something went wrong\" }}\n", .{});

    // switch でパターンマッチング
    std.debug.print("\n2. switch でパターンマッチング:\n", .{});
    std.debug.print("success の処理:\n", .{});
    switch (success) {
        .ok => |value| std.debug.print("  Success: {}\n", .{value}),
        .err => |msg| std.debug.print("  Error: {s}\n", .{msg}),
    }

    std.debug.print("failure の処理:\n", .{});
    switch (failure) {
        .ok => |value| std.debug.print("  Success: {}\n", .{value}),
        .err => |msg| std.debug.print("  Error: {s}\n", .{msg}),
    }

    // メソッドの使用
    std.debug.print("\n3. メソッドの使用:\n", .{});
    std.debug.print("success.isOk() = {}\n", .{success.isOk()});
    std.debug.print("success.isErr() = {}\n", .{success.isErr()});
    std.debug.print("failure.isOk() = {}\n", .{failure.isOk()});
    std.debug.print("failure.isErr() = {}\n", .{failure.isErr()});

    // タグの取得
    std.debug.print("\n4. タグの取得:\n", .{});
    const success_tag = @as(std.meta.Tag(Result), success);
    const failure_tag = @as(std.meta.Tag(Result), failure);
    std.debug.print("success のタグ: {}\n", .{success_tag});
    std.debug.print("failure のタグ: {}\n", .{failure_tag});

    std.debug.print("\n解説:\n", .{});
    std.debug.print("- union(enum) でタグ付きユニオン\n", .{});
    std.debug.print("- switch で安全にパターンマッチング\n", .{});
    std.debug.print("- |variable| で値を取り出す\n", .{});
    std.debug.print("- Rust の enum に相当\n", .{});
    std.debug.print("- どのバリアントがアクティブか自動で追跡\n", .{});
}

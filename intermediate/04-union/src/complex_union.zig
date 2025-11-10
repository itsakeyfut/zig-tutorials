//! 複雑なタグ付きユニオン
//! このモジュールでは、より複雑なタグ付きユニオンの使い方を学びます。

const std = @import("std");

const Message = union(enum) {
    quit,
    move: struct { x: i32, y: i32 },
    write: []const u8,
    change_color: struct { r: u8, g: u8, b: u8 },

    pub fn handle(self: Message) void {
        switch (self) {
            .quit => std.debug.print("  Quitting\n", .{}),
            .move => |pos| std.debug.print("  Moving to ({}, {})\n", .{ pos.x, pos.y }),
            .write => |text| std.debug.print("  Writing: {s}\n", .{text}),
            .change_color => |color| std.debug.print("  Color: RGB({}, {}, {})\n", .{ color.r, color.g, color.b }),
        }
    }

    pub fn description(self: Message) []const u8 {
        return switch (self) {
            .quit => "終了メッセージ",
            .move => "移動メッセージ",
            .write => "書き込みメッセージ",
            .change_color => "色変更メッセージ",
        };
    }
};

pub fn run() void {
    std.debug.print("\n--- 複雑なタグ付きユニオン ---\n", .{});

    std.debug.print("\n1. 様々なメッセージの作成:\n", .{});
    const messages = [_]Message{
        Message.quit,
        Message{ .move = .{ .x = 10, .y = 20 } },
        Message{ .write = "Hello, Zig!" },
        Message{ .change_color = .{ .r = 255, .g = 0, .b = 0 } },
    };

    std.debug.print("作成したメッセージ数: {}\n", .{messages.len});

    std.debug.print("\n2. 各メッセージの処理:\n", .{});
    for (messages, 0..) |msg, i| {
        std.debug.print("Message {}: {s}\n", .{ i, msg.description() });
        msg.handle();
    }

    std.debug.print("\n3. データを持たないバリアント:\n", .{});
    const quit_msg = Message.quit;
    std.debug.print("quit メッセージはデータを持たない\n", .{});
    switch (quit_msg) {
        .quit => std.debug.print("  処理: アプリケーションを終了します\n", .{}),
        else => {},
    }

    std.debug.print("\n4. 構造体を含むバリアント:\n", .{});
    const move_msg = Message{ .move = .{ .x = 100, .y = 200 } };
    switch (move_msg) {
        .move => |pos| {
            std.debug.print("  x座標: {}\n", .{pos.x});
            std.debug.print("  y座標: {}\n", .{pos.y});
            std.debug.print("  距離: {d:.2}\n", .{@sqrt(@as(f64, @floatFromInt(pos.x * pos.x + pos.y * pos.y)))});
        },
        else => {},
    }

    std.debug.print("\n解説:\n", .{});
    std.debug.print("- データを持たないバリアントも定義可能\n", .{});
    std.debug.print("- 構造体を直接バリアントに含められる\n", .{});
    std.debug.print("- switch で安全にパターンマッチング\n", .{});
    std.debug.print("- メソッドで共通の振る舞いを定義\n", .{});
}

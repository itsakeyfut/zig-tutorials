//! Zigパッケージとモジュールのチュートリアル
//! このプログラムは、@importによるモジュール読み込み、pub修飾子による公開制御、
//! ディレクトリ階層を使ったパッケージ構成などの使い方を示します。

const std = @import("std");
const math = @import("math.zig");
const user_mod = @import("user.zig");
const User = @import("models/user.zig").User;

pub fn main() void {
    std.debug.print("=== @importの詳細 ===\n", .{});
    const sum = math.add(10, 20);
    const product = math.multiply(5, 6);

    std.debug.print("Sum: {}\n", .{sum});
    std.debug.print("Product: {}\n", .{product});
    std.debug.print("E: {d:.5}\n", .{math.E});

    // math.PI は使えない（プライベート）

    std.debug.print("\n=== pubによる公開制御 ===\n", .{});
    const user = user_mod.User.init(1, "Alice", "alice@example.com");

    std.debug.print("Name: {s}\n", .{user.getName()});

    // user.password_hash は直接アクセスできない
    // user_mod.internalHelper() は呼べない

    if (user_mod.validateEmail("test@example.com")) {
        std.debug.print("Valid email\n", .{});
    }

    std.debug.print("\n=== パッケージ構成 ===\n", .{});
    const user2 = User{ .id = 1, .name = "Alice" };
    std.debug.print("User: {s}\n", .{user2.name});
}

//! アロケータの基本
//! このモジュールでは、なぜアロケータが必要なのか、
//! そして基本的な使い方を学びます。

const std = @import("std");

pub fn run() !void {
    std.debug.print("\n--- アロケータの基本 ---\n", .{});

    // アロケータを明示的に選択
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    std.debug.print("\nZigには以下がありません:\n", .{});
    std.debug.print("- ガーベージコレクタ\n", .{});
    std.debug.print("- 暗黙的なメモリ管理\n", .{});
    std.debug.print("- グローバルアロケータ\n", .{});
    std.debug.print("\n代わりに: 明示的にアロケータを渡します\n", .{});

    // メモリ確保
    const buffer = try allocator.alloc(u8, 1024);
    defer allocator.free(buffer);

    std.debug.print("\nAllocated {} bytes\n", .{buffer.len});

    // 配列の確保と使用
    const numbers = try allocator.alloc(i32, 5);
    defer allocator.free(numbers);

    // データを書き込む
    for (numbers, 0..) |*num, i| {
        num.* = @intCast(i * 10);
    }

    std.debug.print("Numbers: ", .{});
    for (numbers) |num| {
        std.debug.print("{} ", .{num});
    }
    std.debug.print("\n", .{});

    std.debug.print("\n解説:\n", .{});
    std.debug.print("- allocator.alloc() でメモリを確保\n", .{});
    std.debug.print("- defer allocator.free() で確実に解放\n", .{});
    std.debug.print("- 明示的な管理により、メモリの動きが明確\n", .{});
}

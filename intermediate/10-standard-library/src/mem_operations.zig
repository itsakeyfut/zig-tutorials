//! std.mem（メモリ操作）の例
//! メモリのコピー、比較、文字列の検索・分割・トリムなどの操作を示します。

const std = @import("std");

pub fn run() !void {
    std.debug.print("\n--- std.mem（メモリ操作）---\n", .{});

    // メモリのコピー
    var src = [_]u8{ 1, 2, 3, 4, 5 };
    var dst: [5]u8 = undefined;
    @memcpy(&dst, &src);

    // メモリの比較
    const equal = std.mem.eql(u8, &src, &dst);
    std.debug.print("Equal: {}\n", .{equal});

    // 文字列の操作
    const text = "Hello, Zig!";

    // 文字列の検索
    if (std.mem.indexOf(u8, text, "Zig")) |index| {
        std.debug.print("Found at index {}\n", .{index});
    }

    // 文字列の分割
    var iter = std.mem.splitSequence(u8, text, ", ");
    while (iter.next()) |part| {
        std.debug.print("Part: {s}\n", .{part});
    }

    // トリム
    const whitespace = "  hello  ";
    const trimmed = std.mem.trim(u8, whitespace, " ");
    std.debug.print("Trimmed: '{s}'\n", .{trimmed});
}

//! errdefer（エラー時のみ実行）
//! errdefer はエラーが発生した時だけ実行される defer です

const std = @import("std");

fn allocateAndProcess(allocator: std.mem.Allocator) ![]u8 {
    const buffer = try allocator.alloc(u8, 1024);
    errdefer allocator.free(buffer); // エラー時のみ解放

    // 何か処理
    if (false) return error.ProcessingFailed;

    // 成功時は buffer を返す（解放しない）
    return buffer;
}

pub fn run() !void {
    std.debug.print("\n--- errdefer（エラー時のみ実行） ---\n", .{});

    const allocator = std.heap.page_allocator;

    const buffer = try allocateAndProcess(allocator);
    defer allocator.free(buffer);

    std.debug.print("Success\n", .{});
}

//! リソース管理
//! defer を使ってメモリやリソースを確実に解放します

const std = @import("std");

fn processFile(allocator: std.mem.Allocator, path: []const u8) !void {
    // メモリ確保
    const buffer = try allocator.alloc(u8, 1024);
    defer allocator.free(buffer); // スコープ終了時に解放

    std.debug.print("Processing {s}\n", .{path});

    // エラーが起きても defer は実行される
    if (std.mem.eql(u8, path, "bad.txt")) {
        return error.BadFile;
    }

    // 正常終了時も defer は実行される
}

pub fn run() !void {
    std.debug.print("\n--- リソース管理 ---\n", .{});

    const allocator = std.heap.page_allocator;

    processFile(allocator, "good.txt") catch |err| {
        std.debug.print("Error: {}\n", .{err});
    };
}

//! std.fs（ファイル操作）の例
//! ファイルの書き込み・読み込み、ディレクトリの作成・削除などの操作を示します。

const std = @import("std");

pub fn run(allocator: std.mem.Allocator) !void {
    std.debug.print("\n--- std.fs（ファイル操作）---\n", .{});

    // ファイルの書き込み
    const file = try std.fs.cwd().createFile("test.txt", .{});
    defer file.close();

    try file.writeAll("Hello, Zig!\n");
    try file.writeAll("This is a test.\n");

    // ファイルの読み込み
    const content = try std.fs.cwd().readFileAlloc(
        allocator,
        "test.txt",
        1024 * 1024, // 最大サイズ
    );
    defer allocator.free(content);

    std.debug.print("Content:\n{s}\n", .{content});

    // ディレクトリの作成
    try std.fs.cwd().makeDir("test_dir");

    // ディレクトリの削除
    try std.fs.cwd().deleteDir("test_dir");

    // ファイルの削除
    try std.fs.cwd().deleteFile("test.txt");
}

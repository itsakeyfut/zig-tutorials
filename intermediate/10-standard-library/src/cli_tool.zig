//! 実践的な例：CLIツール
//! コマンドライン引数を処理し、ファイルの行数と文字数をカウントします。

const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // コマンドライン引数を取得
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len < 2) {
        std.debug.print("Usage: {s} <filename>\n", .{args[0]});
        return;
    }

    const filename = args[1];

    // ファイルを読み込み
    const content = std.fs.cwd().readFileAlloc(
        allocator,
        filename,
        1024 * 1024,
    ) catch |err| {
        std.debug.print("Error reading file: {}\n", .{err});
        return;
    };
    defer allocator.free(content);

    // 行数と文字数をカウント
    var line_count: usize = 0;
    const char_count: usize = content.len;

    for (content) |c| {
        if (c == '\n') line_count += 1;
    }

    std.debug.print("Lines: {}\n", .{line_count});
    std.debug.print("Characters: {}\n", .{char_count});
}

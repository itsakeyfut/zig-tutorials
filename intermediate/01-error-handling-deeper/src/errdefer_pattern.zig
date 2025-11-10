//! errdefer の実践パターンの例
//! このモジュールでは、errdefer を使ったリソース管理の方法を示します。

const std = @import("std");

fn processWithCleanup(allocator: std.mem.Allocator, should_fail: bool) !void {
    std.debug.print("  リソース1を確保中...\n", .{});
    // リソース1を確保
    const buffer1 = try allocator.alloc(u8, 1024);
    errdefer {
        std.debug.print("  [errdefer] リソース1を解放\n", .{});
        allocator.free(buffer1);
    }

    std.debug.print("  リソース2を確保中...\n", .{});
    // リソース2を確保
    const buffer2 = try allocator.alloc(u8, 2048);
    errdefer {
        std.debug.print("  [errdefer] リソース2を解放\n", .{});
        allocator.free(buffer2);
    }

    // エラーが起きるかもしれない処理
    if (should_fail) {
        std.debug.print("  エラーが発生!\n", .{});
        return error.ProcessingFailed;
    }

    std.debug.print("  処理成功\n", .{});

    // 成功時はdeferで解放
    defer {
        std.debug.print("  [defer] リソース2を解放\n", .{});
        allocator.free(buffer2);
    }
    defer {
        std.debug.print("  [defer] リソース1を解放\n", .{});
        allocator.free(buffer1);
    }
}

pub fn run() !void {
    std.debug.print("\n--- errdefer の実践パターン ---\n", .{});

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    std.debug.print("\n1. 正常ケース:\n", .{});
    processWithCleanup(allocator, false) catch |err| {
        std.debug.print("Error occurred: {}\n", .{err});
    };

    std.debug.print("\n2. エラーケース:\n", .{});
    processWithCleanup(allocator, true) catch |err| {
        std.debug.print("  Error occurred: {}\n", .{err});
    };

    std.debug.print("\n解説:\n", .{});
    std.debug.print("- errdefer はエラー発生時のみ実行される\n", .{});
    std.debug.print("- defer は成功・失敗に関わらず実行される\n", .{});
    std.debug.print("- リソース確保の直後に errdefer を配置するのがベストプラクティス\n", .{});
    std.debug.print("- これにより、メモリリークを防ぐことができる\n", .{});
}

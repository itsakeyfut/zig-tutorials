//! アロケータの渡し方
//! このモジュールでは、アロケータを関数や構造体に渡す
//! 一般的なパターンを学びます。

const std = @import("std");

// パターン1: 関数にアロケータを渡す
fn processData(allocator: std.mem.Allocator, size: usize) ![]u8 {
    const buffer = try allocator.alloc(u8, size);
    // 処理... (ここではデータを書き込む)
    for (buffer, 0..) |*byte, i| {
        byte.* = @intCast(i % 256);
    }
    return buffer;
}

// パターン2: 構造体にアロケータを保持
const DataProcessor = struct {
    allocator: std.mem.Allocator,
    buffer: []u8,

    pub fn init(allocator: std.mem.Allocator, size: usize) !DataProcessor {
        const buffer = try allocator.alloc(u8, size);
        return DataProcessor{
            .allocator = allocator,
            .buffer = buffer,
        };
    }

    pub fn deinit(self: *DataProcessor) void {
        self.allocator.free(self.buffer);
    }

    pub fn process(self: *DataProcessor) void {
        std.debug.print("   Processing {} bytes\n", .{self.buffer.len});
        // 処理の例: 最初の5バイトを表示
        const show_len = @min(5, self.buffer.len);
        std.debug.print("   First {} bytes: ", .{show_len});
        for (self.buffer[0..show_len]) |byte| {
            std.debug.print("{} ", .{byte});
        }
        std.debug.print("\n", .{});
    }
};

pub fn run() !void {
    std.debug.print("\n--- アロケータの渡し方 ---\n", .{});

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // パターン1: 関数に渡す
    std.debug.print("\n1. 関数にアロケータを渡す:\n", .{});
    const data = try processData(allocator, 1024);
    defer allocator.free(data);
    std.debug.print("   Allocated {} bytes via function\n", .{data.len});
    std.debug.print("   First 5 bytes: {} {} {} {} {}\n", .{
        data[0],
        data[1],
        data[2],
        data[3],
        data[4],
    });

    // パターン2: 構造体に保持
    std.debug.print("\n2. 構造体にアロケータを保持:\n", .{});
    var processor = try DataProcessor.init(allocator, 2048);
    defer processor.deinit();
    processor.process();

    std.debug.print("\n解説:\n", .{});
    std.debug.print("- 関数パターン: シンプルで使いやすい\n", .{});
    std.debug.print("- 構造体パターン: 長期的なリソース管理に適している\n", .{});
    std.debug.print("- どちらも明示的にアロケータを渡すことで、\n", .{});
    std.debug.print("  メモリの動きが明確になる\n", .{});
}

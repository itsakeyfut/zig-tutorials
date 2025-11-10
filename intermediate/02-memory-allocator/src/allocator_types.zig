//! 標準アロケータの種類
//! このモジュールでは、Zigが提供する主要なアロケータの種類と
//! それぞれの特徴を学びます。

const std = @import("std");

pub fn run() !void {
    std.debug.print("\n--- 標準アロケータの種類 ---\n", .{});

    // 1. page_allocator（システムアロケータ）
    std.debug.print("\n1. page_allocator（システムアロケータ）\n", .{});
    std.debug.print("   - 直接OSからメモリを取得\n", .{});
    std.debug.print("   - 遅いが、シンプル\n", .{});

    const page_alloc = std.heap.page_allocator;
    const data1 = try page_alloc.alloc(u8, 100);
    defer page_alloc.free(data1);
    std.debug.print("   page_allocator: {} bytes allocated\n", .{data1.len});

    // 2. GeneralPurposeAllocator（汎用アロケータ）
    std.debug.print("\n2. GeneralPurposeAllocator（汎用アロケータ）\n", .{});
    std.debug.print("   - メモリリークを検出\n", .{});
    std.debug.print("   - デバッグに最適\n", .{});

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        const leaked = gpa.deinit();
        if (leaked == .leak) {
            std.debug.print("   Memory leak detected!\n", .{});
        } else {
            std.debug.print("   No memory leaks detected\n", .{});
        }
    }
    const gpa_alloc = gpa.allocator();

    const data2 = try gpa_alloc.alloc(u8, 200);
    defer gpa_alloc.free(data2);
    std.debug.print("   GeneralPurposeAllocator: {} bytes allocated\n", .{data2.len});

    // 3. ArenaAllocator（アリーナアロケータ）
    std.debug.print("\n3. ArenaAllocator（アリーナアロケータ）\n", .{});
    std.debug.print("   - まとめて解放\n", .{});
    std.debug.print("   - 一時的なメモリに最適\n", .{});

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit(); // 全てまとめて解放
    const arena_alloc = arena.allocator();

    // 複数のメモリを確保（個別のfreeは不要）
    const data3 = try arena_alloc.alloc(u8, 300);
    const data4 = try arena_alloc.alloc(u8, 400);
    const data5 = try arena_alloc.alloc(u8, 500);

    std.debug.print("   ArenaAllocator: {} + {} + {} = {} bytes allocated\n", .{
        data3.len,
        data4.len,
        data5.len,
        data3.len + data4.len + data5.len,
    });
    std.debug.print("   arena.deinit() で全てまとめて解放される\n", .{});

    // 4. FixedBufferAllocator（固定バッファアロケータ）
    std.debug.print("\n4. FixedBufferAllocator（固定バッファアロケータ）\n", .{});
    std.debug.print("   - スタック上のバッファを使用\n", .{});
    std.debug.print("   - OSコールなし\n", .{});

    var buffer: [1024]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const fba_alloc = fba.allocator();

    const data6 = try fba_alloc.alloc(u8, 512);
    std.debug.print("   FixedBufferAllocator: {} bytes allocated (from stack buffer)\n", .{data6.len});
    std.debug.print("   Buffer capacity: {} bytes\n", .{buffer.len});

    std.debug.print("\n解説:\n", .{});
    std.debug.print("- page_allocator: シンプルだが遅い\n", .{});
    std.debug.print("- GeneralPurposeAllocator: デバッグに最適\n", .{});
    std.debug.print("- ArenaAllocator: 一時的なメモリに便利\n", .{});
    std.debug.print("- FixedBufferAllocator: 高速だがサイズ固定\n", .{});
}

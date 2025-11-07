const std = @import("std");

/// whileループの例を実行
pub fn run() void {
    std.debug.print("\n=== while Loop Examples ===\n", .{});

    // 基本的なwhile
    std.debug.print("\n1. Basic while loop:\n", .{});
    var i: i32 = 0;
    while (i < 5) {
        std.debug.print("{}\n", .{i});
        i += 1;
    }

    // continue式付き
    std.debug.print("\n2. while with continue expression:\n", .{});
    i = 0;
    while (i < 5) : (i += 1) {
        std.debug.print("{}\n", .{i});
    }
}

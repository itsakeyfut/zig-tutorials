const std = @import("std");

pub fn run() void {
    std.debug.print("\n=== String (as Slice) ===\n", .{});

    // 文字列リテラル（[]const u8）
    std.debug.print("\n1. String literals ([]const u8):\n", .{});
    const str1: []const u8 = "Hello, Zig!";
    std.debug.print("str1: []const u8 = \"Hello, Zig!\"\n", .{});

    // 型推論
    std.debug.print("\n2. Type inference:\n", .{});
    const str2 = "Hello, World!";
    std.debug.print("str2 = \"Hello, World!\"\n", .{});

    // 文字列の長さ
    std.debug.print("\n3. String length:\n", .{});
    std.debug.print("str1.len = {}\n", .{str1.len});
    std.debug.print("str2.len = {}\n", .{str2.len});

    // 文字列の比較
    std.debug.print("\n4. String comparison:\n", .{});
    std.debug.print("Comparing str1 and str2:\n", .{});
    if (std.mem.eql(u8, str1, str2)) {
        std.debug.print("  Result: Equal\n", .{});
    } else {
        std.debug.print("  Result: Not equal\n", .{});
    }

    // 同じ文字列の比較
    std.debug.print("\nComparing str1 with itself:\n", .{});
    if (std.mem.eql(u8, str1, str1)) {
        std.debug.print("  Result: Equal\n", .{});
    } else {
        std.debug.print("  Result: Not equal\n", .{});
    }

    // 部分文字列
    std.debug.print("\n5. Substring (slicing):\n", .{});
    const substr = str1[0..5]; // "Hello"
    std.debug.print("substr = str1[0..5]\n", .{});
    std.debug.print("substr: {s}\n", .{substr});

    // より多くの部分文字列の例
    std.debug.print("\n6. More substring examples:\n", .{});
    const greeting = str1[0..5]; // "Hello"
    const comma_zig = str1[5..]; // ", Zig!"
    std.debug.print("greeting (str1[0..5]): {s}\n", .{greeting});
    std.debug.print("comma_zig (str1[5..]): {s}\n", .{comma_zig});
}

pub fn runStringFeatures() void {
    std.debug.print("\n=== Important String Features ===\n", .{});

    std.debug.print("\n1. Strings are UTF-8 encoded byte arrays:\n", .{});
    const utf8_str = "こんにちは"; // 日本語
    std.debug.print("utf8_str: {s}\n", .{utf8_str});
    std.debug.print("Byte length: {}\n", .{utf8_str.len});

    std.debug.print("\n2. No String type in Zig:\n", .{});
    std.debug.print("Zig has no built-in String type.\n", .{});
    std.debug.print("Strings are []const u8 (byte slices).\n", .{});

    std.debug.print("\n3. Use {{s}} format for string output:\n", .{});
    const example = "Use {{s}} not {{}}";
    std.debug.print("Correct: std.debug.print(\"{{s}}\", .{{str}});\n", .{});
    std.debug.print("Example: {s}\n", .{example});
}

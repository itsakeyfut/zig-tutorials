const std = @import("std");

pub fn main() void {
    std.debug.print("=== Zigの基本的な型 ===\n\n", .{});

    // ========================================
    // 1. 整数型
    // ========================================
    std.debug.print("1. 整数型\n", .{});

    // 符号付き整数
    const i8_val: i8 = -128;
    const i16_val: i16 = -32768;
    const i32_val: i32 = -2147483648;
    const i64_val: i64 = -9223372036854775808;

    std.debug.print("  符号付き整数:\n", .{});
    std.debug.print("    i8:  {} (範囲: -128 〜 127)\n", .{i8_val});
    std.debug.print("    i16: {} (範囲: -32768 〜 32767)\n", .{i16_val});
    std.debug.print("    i32: {} (範囲: -2147483648 〜 2147483647)\n", .{i32_val});
    std.debug.print("    i64: {} (範囲: -9223372036854775808 〜 9223372036854775807)\n", .{i64_val});

    // 符号なし整数
    const u8_val: u8 = 255;
    const u16_val: u16 = 65535;
    const u32_val: u32 = 4294967295;
    const u64_val: u64 = 18446744073709551615;

    std.debug.print("  符号なし整数:\n", .{});
    std.debug.print("    u8:  {} (範囲: 0 〜 255)\n", .{u8_val});
    std.debug.print("    u16: {} (範囲: 0 〜 65535)\n", .{u16_val});
    std.debug.print("    u32: {} (範囲: 0 〜 4294967295)\n", .{u32_val});
    std.debug.print("    u64: {} (範囲: 0 〜 18446744073709551615)\n", .{u64_val});

    // 任意サイズの整数（Zigの特殊機能）
    const i3_val: i3 = -4;  // -4 から 3
    const u7_val: u7 = 127; // 0 から 127

    std.debug.print("  任意サイズの整数:\n", .{});
    std.debug.print("    i3: {} (範囲: -4 〜 3)\n", .{i3_val});
    std.debug.print("    u7: {} (範囲: 0 〜 127)\n", .{u7_val});

    // ポインタサイズの整数
    const isize_val: isize = -100;
    const usize_val: usize = 100;

    std.debug.print("  ポインタサイズの整数:\n", .{});
    std.debug.print("    isize: {}\n", .{isize_val});
    std.debug.print("    usize: {}\n", .{usize_val});
    std.debug.print("\n", .{});

    // ========================================
    // 2. 浮動小数点型
    // ========================================
    std.debug.print("2. 浮動小数点型\n", .{});

    const f32_val: f32 = 3.14;
    const f64_val: f64 = 3.141592653589793;

    std.debug.print("  f32: {d:.2} (単精度浮動小数点)\n", .{f32_val});
    std.debug.print("  f64: {d:.15} (倍精度浮動小数点)\n", .{f64_val});

    // 型推論ではf64
    const pi = 3.14;
    std.debug.print("  型推論: {d:.2} (デフォルトは f64)\n", .{pi});
    std.debug.print("\n", .{});

    // ========================================
    // 3. bool と文字
    // ========================================
    std.debug.print("3. bool と文字\n", .{});

    const flag: bool = true;
    const letter: u8 = 'A';  // ASCII文字

    std.debug.print("  bool: {}\n", .{flag});
    std.debug.print("  文字 (u8): {} (ASCII コード: {})\n", .{letter, letter});

    // Zigには文字型がない（u8を使う）
    std.debug.print("  注意: Zigには専用の文字型がなく、u8を使用します\n", .{});
}

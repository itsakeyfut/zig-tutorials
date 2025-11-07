const std = @import("std");

pub fn main() void {
    std.debug.print("=== Zigの変数宣言 ===\n\n", .{});

    // ========================================
    // 1. var と const の基本
    // ========================================
    std.debug.print("1. var と const の基本\n", .{});

    // const: 不変（Rustの let）
    const x: i32 = 10;
    // x = 20;  // ❌ エラー: cannot assign to constant

    // var: 可変（Rustの let mut）
    var y: i32 = 10;
    y = 20; // ✅ OK

    std.debug.print("  x = {}, y = {}\n", .{ x, y });
    std.debug.print("\n", .{});

    // ========================================
    // 2. 型推論
    // ========================================
    std.debug.print("2. 型推論\n", .{});

    // 型推論（Rustと同様）
    const inferred_int = 10; // i32 と推論
    const pi = 3.14; // f64 と推論
    const flag = true; // bool

    // 明示的な型
    const explicit_u8: u8 = 255;
    const explicit_f32: f32 = 1.5;

    std.debug.print("  inferred_int = {} (型: i32)\n", .{inferred_int});
    std.debug.print("  pi = {d:.2} (型: f64)\n", .{pi});
    std.debug.print("  flag = {} (型: bool)\n", .{flag});
    std.debug.print("  explicit_u8 = {} (型: u8)\n", .{explicit_u8});
    std.debug.print("  explicit_f32 = {d:.1} (型: f32)\n", .{explicit_f32});
    std.debug.print("\n", .{});

    // ========================================
    // 3. comptime変数
    // ========================================
    std.debug.print("3. comptime変数\n", .{});

    // コンパイル時に計算される
    const result = comptime fibonacci(10);
    std.debug.print("  fibonacci(10) = {} (コンパイル時に計算)\n", .{result});
}

// フィボナッチ数列をコンパイル時に計算する関数
fn fibonacci(n: comptime_int) comptime_int {
    if (n <= 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

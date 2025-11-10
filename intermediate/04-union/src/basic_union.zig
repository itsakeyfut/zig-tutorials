//! 基本的なユニオン
//! このモジュールでは、タグなしユニオンの使い方を学びます。

const std = @import("std");

// 通常のユニオン（タグなし）
const Value = union {
    int: i32,
    float: f64,
    boolean: bool,
};

pub fn run() void {
    std.debug.print("\n--- 基本的なユニオン ---\n", .{});

    var value = Value{ .int = 42 };

    // どのフィールドがアクティブかはプログラマが管理
    std.debug.print("\n1. 整数値として初期化:\n", .{});
    std.debug.print("value.int = {}\n", .{value.int});

    // 別のフィールドに変更
    value = Value{ .float = 3.14 };
    std.debug.print("\n2. 浮動小数点値に変更:\n", .{});
    std.debug.print("value.float = {d:.2}\n", .{value.float});

    // 真偽値に変更
    value = Value{ .boolean = true };
    std.debug.print("\n3. 真偽値に変更:\n", .{});
    std.debug.print("value.boolean = {}\n", .{value.boolean});

    // 間違ったフィールドにアクセスすると未定義動作
    std.debug.print("\n注意: 間違ったフィールドにアクセスすると未定義動作(UB)!\n", .{});
    std.debug.print("現在のフィールドは boolean だが、int にアクセスすると...\n", .{});
    std.debug.print("（この例では実行していません - 危険！）\n", .{});
    // std.debug.print("value.int = {}\n", .{value.int});  // ❌ UB

    std.debug.print("\n解説:\n", .{});
    std.debug.print("- union は複数の型のいずれかを保持\n", .{});
    std.debug.print("- どのフィールドがアクティブかは手動管理\n", .{});
    std.debug.print("- 間違ったフィールドへのアクセスは未定義動作\n", .{});
    std.debug.print("- メモリサイズは最大のフィールドのサイズ\n", .{});
    std.debug.print("- サイズ: {} bytes\n", .{@sizeOf(Value)});
}

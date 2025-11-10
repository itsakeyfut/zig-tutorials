//! エラー推論（anyerror）の例
//! このモジュールでは、anyerror と推論されるエラーセットの使い方を示します。

const std = @import("std");

// anyerror は全てのエラーを含む
fn mightFail() anyerror!i32 {
    return error.UnknownError;
}

// エラーセットを推論（!T）
fn autoInfer() !i32 {
    if (false) return error.Failed;
    if (false) return error.AnotherError;
    return 42;
}

// 推論されたエラーセット: error{Failed, AnotherError}

pub fn run() void {
    std.debug.print("\n--- エラー推論（anyerror） ---\n", .{});

    // anyerror の例
    const result1 = mightFail() catch |err| blk: {
        std.debug.print("anyerror caught: {}\n", .{err});
        break :blk 0;
    };
    std.debug.print("mightFail result: {}\n", .{result1});

    // エラーセット推論の例
    const result2 = autoInfer() catch |err| blk: {
        std.debug.print("Inferred error caught: {}\n", .{err});
        break :blk 0;
    };
    std.debug.print("autoInfer result: {}\n", .{result2});

    std.debug.print("\n解説:\n", .{});
    std.debug.print("- anyerror は全てのエラーを含む特殊な型\n", .{});
    std.debug.print("- !T 形式でエラーセットを推論可能\n", .{});
    std.debug.print("- 推論されたエラーセットはコンパイル時に決定される\n", .{});
}

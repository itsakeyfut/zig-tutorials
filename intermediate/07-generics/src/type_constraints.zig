//! 型制約の実現
//! このモジュールでは、@hasDeclや@hasFieldを使った型制約を学びます。

const std = @import("std");

// 型が特定のメソッドを持つことを要求
fn printable(comptime T: type) bool {
    return @hasDecl(T, "print");
}

fn callPrint(value: anytype) void {
    comptime {
        if (!printable(@TypeOf(value))) {
            @compileError("Type must have a 'print' method");
        }
    }
    value.print();
}

// 型が特定のフィールドを持つことを確認
fn hasIdField(comptime T: type) bool {
    return @hasField(T, "id");
}

fn printId(value: anytype) void {
    comptime {
        if (!hasIdField(@TypeOf(value))) {
            @compileError("Type must have an 'id' field");
        }
    }
    std.debug.print("ID: {}\n", .{value.id});
}

// 数値型かどうかをチェック
fn isNumeric(comptime T: type) bool {
    return switch (@typeInfo(T)) {
        .int, .float, .comptime_int, .comptime_float => true,
        else => false,
    };
}

fn addNumeric(a: anytype, b: anytype) @TypeOf(a, b) {
    comptime {
        if (!isNumeric(@TypeOf(a))) {
            @compileError("Type must be numeric");
        }
    }
    return a + b;
}

// printメソッドを持つ構造体
const PrintableInt = struct {
    value: i32,

    pub fn print(self: PrintableInt) void {
        std.debug.print("Value: {}\n", .{self.value});
    }
};

const PrintableString = struct {
    text: []const u8,

    pub fn print(self: PrintableString) void {
        std.debug.print("Text: {s}\n", .{self.text});
    }
};

// idフィールドを持つ構造体
const User = struct {
    id: u32,
    name: []const u8,
};

const Product = struct {
    id: u32,
    price: f64,
};

// 型情報を利用した関数
fn describeType(comptime T: type) void {
    const info = @typeInfo(T);
    std.debug.print("\nType: {}\n", .{T});

    switch (info) {
        .int => |int_info| {
            std.debug.print("  Kind: Integer\n", .{});
            std.debug.print("  Signedness: {}\n", .{int_info.signedness});
            std.debug.print("  Bits: {}\n", .{int_info.bits});
        },
        .float => |float_info| {
            std.debug.print("  Kind: Float\n", .{});
            std.debug.print("  Bits: {}\n", .{float_info.bits});
        },
        .@"struct" => {
            std.debug.print("  Kind: Struct\n", .{});
        },
        else => {
            std.debug.print("  Kind: Other\n", .{});
        },
    }
}

pub fn run() void {
    std.debug.print("\n--- 型制約の実現 ---\n", .{});

    std.debug.print("\n1. printable制約（printメソッドを要求）:\n", .{});
    const p1 = PrintableInt{ .value = 42 };
    const p2 = PrintableString{ .text = "Hello" };

    callPrint(p1);
    callPrint(p2);

    // コンパイルエラー: 'print' メソッドがない
    // callPrint(42);

    std.debug.print("\n2. idフィールド制約:\n", .{});
    const user = User{ .id = 1, .name = "Alice" };
    const product = Product{ .id = 100, .price = 99.99 };

    printId(user);
    printId(product);

    // コンパイルエラー: 'id' フィールドがない
    // const value = 42;
    // printId(value);

    std.debug.print("\n3. 数値型制約:\n", .{});
    std.debug.print("addNumeric(10, 20) = {}\n", .{addNumeric(10, 20)});
    std.debug.print("addNumeric(1.5, 2.5) = {d:.1}\n", .{addNumeric(1.5, 2.5)});

    // コンパイルエラー: 数値型でない
    // addNumeric("hello", "world");

    std.debug.print("\n4. 型情報の表示:\n", .{});
    describeType(i32);
    describeType(f64);
    describeType(User);

    std.debug.print("\n5. 型チェックの実行時情報:\n", .{});
    std.debug.print("i32 is numeric: {}\n", .{isNumeric(i32)});
    std.debug.print("f64 is numeric: {}\n", .{isNumeric(f64)});
    std.debug.print("bool is numeric: {}\n", .{isNumeric(bool)});
    std.debug.print("User has id field: {}\n", .{hasIdField(User)});
    std.debug.print("User has print method: {}\n", .{printable(User)});
    std.debug.print("PrintableInt has print method: {}\n", .{printable(PrintableInt)});

    std.debug.print("\n解説:\n", .{});
    std.debug.print("- @hasDecl で宣言の存在をチェック\n", .{});
    std.debug.print("- @hasField でフィールドの存在をチェック\n", .{});
    std.debug.print("- @typeInfo で型の詳細情報を取得\n", .{});
    std.debug.print("- @compileError でコンパイル時にエラーを出す\n", .{});
    std.debug.print("- Rustのトレイト境界より柔軟だが型安全性は低い\n", .{});
}

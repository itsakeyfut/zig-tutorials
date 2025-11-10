# 7. ジェネリクス

このチュートリアルでは、Zigのジェネリクス（総称型プログラミング）について学びます。

## 学習内容

1. **anytypeによる型推論** - 呼び出し時に型を推論
2. **comptime typeパラメータ** - 明示的な型パラメータ
3. **型制約の実現** - `@hasDecl`や`@hasField`による型チェック
4. **ジェネリック構造体** - 型を返す関数によるジェネリック実装

## ビルドと実行

```bash
zig build run
```

## 1. anytypeによる型推論

### 基本的な使い方

```zig
fn max(a: anytype, b: anytype) @TypeOf(a, b) {
    return if (a > b) a else b;
}

fn print(value: anytype) void {
    std.debug.print("Value: {any}\n", .{value});
}
```

### 使用例

```zig
const x = max(10, 20);           // i32
const y = max(1.5, 2.5);         // f64

print(42);        // 整数
print("hello");   // 文字列
print(true);      // bool
```

### 特徴

- `anytype`は呼び出し時に型が推論される
- `@TypeOf(a, b)`で共通の型を取得
- コンパイル時に型が決定される
- Rustの`impl Trait`に似ているが、よりシンプル

## 2. comptime typeパラメータ

### 明示的な型指定

```zig
fn swap(comptime T: type, a: *T, b: *T) void {
    const temp = a.*;
    a.* = b.*;
    b.* = temp;
}

fn sum(comptime T: type, values: []const T) T {
    var result: T = 0;
    for (values) |value| {
        result += value;
    }
    return result;
}
```

### 使用例

```zig
var x: i32 = 10;
var y: i32 = 20;
swap(i32, &x, &y);  // 型を明示的に指定

const numbers = [_]i32{ 1, 2, 3, 4, 5 };
const total = sum(i32, &numbers);
```

### 特徴

- `comptime T: type`で明示的な型パラメータ
- 呼び出し時に型を指定する必要がある
- `anytype`より明示的で読みやすい
- Rustのジェネリクス`<T>`に近い

## 3. 型制約の実現

### @hasDeclによるメソッドチェック

```zig
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
```

### @hasFieldによるフィールドチェック

```zig
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
```

### @typeInfoによる型情報の取得

```zig
fn isNumeric(comptime T: type) bool {
    return switch (@typeInfo(T)) {
        .Int, .Float => true,
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
```

### 使用例

```zig
const PrintableInt = struct {
    value: i32,
    pub fn print(self: PrintableInt) void {
        std.debug.print("Value: {}\n", .{self.value});
    }
};

const p = PrintableInt{ .value = 42 };
callPrint(p);  // OK

// callPrint(42);  // コンパイルエラー: printメソッドがない
```

## 4. ジェネリック構造体

### Stack（スタック）

```zig
fn Stack(comptime T: type) type {
    return struct {
        items: std.ArrayList(T),

        pub fn init(allocator: std.mem.Allocator) @This() {
            return .{
                .items = std.ArrayList(T).init(allocator),
            };
        }

        pub fn deinit(self: *@This()) void {
            self.items.deinit();
        }

        pub fn push(self: *@This(), item: T) !void {
            try self.items.append(item);
        }

        pub fn pop(self: *@This()) ?T {
            if (self.items.items.len == 0) return null;
            return self.items.pop();
        }
    };
}
```

### 使用例

```zig
var stack = Stack(i32).init(allocator);
defer stack.deinit();

try stack.push(10);
try stack.push(20);
try stack.push(30);

while (stack.pop()) |value| {
    std.debug.print("Popped: {}\n", .{value});
}
```

### Result型（RustのResult相当）

```zig
fn Result(comptime T: type, comptime E: type) type {
    return union(enum) {
        ok: T,
        err: E,

        pub fn isOk(self: @This()) bool {
            return switch (self) {
                .ok => true,
                .err => false,
            };
        }

        pub fn unwrap(self: @This()) T {
            return switch (self) {
                .ok => |value| value,
                .err => @panic("called unwrap on an error value"),
            };
        }

        pub fn unwrapOr(self: @This(), default: T) T {
            return switch (self) {
                .ok => |value| value,
                .err => default,
            };
        }
    };
}
```

### 使用例

```zig
const ok_result = Result(i32, []const u8){ .ok = 42 };
const err_result = Result(i32, []const u8){ .err = "error occurred" };

std.debug.print("Value: {}\n", .{ok_result.unwrap()});
std.debug.print("Default: {}\n", .{err_result.unwrapOr(0)});
```

## Rustとの比較

### Zigのanytype

```zig
fn max(a: anytype, b: anytype) @TypeOf(a, b) {
    return if (a > b) a else b;
}
```

### Rustの対応コード

```rust
fn max<T: PartialOrd>(a: T, b: T) -> T {
    if a > b { a } else { b }
}
```

### Zigのcomptime type

```zig
fn swap(comptime T: type, a: *T, b: *T) void {
    const temp = a.*;
    a.* = b.*;
    b.* = temp;
}
```

### Rustの対応コード

```rust
fn swap<T>(a: &mut T, b: &mut T) {
    std::mem::swap(a, b);
}
```

### Zigの型制約

```zig
fn callPrint(value: anytype) void {
    comptime {
        if (!@hasDecl(@TypeOf(value), "print")) {
            @compileError("Type must have a 'print' method");
        }
    }
    value.print();
}
```

### Rustのトレイト境界

```rust
trait Printable {
    fn print(&self);
}

fn call_print<T: Printable>(value: &T) {
    value.print();
}
```

### Zigのジェネリック構造体

```zig
fn Stack(comptime T: type) type {
    return struct {
        items: std.ArrayList(T),
        // ...
    };
}

var stack = Stack(i32).init(allocator);
```

### Rustのジェネリック構造体

```rust
struct Stack<T> {
    items: Vec<T>,
}

impl<T> Stack<T> {
    fn new() -> Self {
        Stack { items: Vec::new() }
    }
}

let mut stack = Stack::<i32>::new();
```

## 重要な違い

### 型パラメータの指定方法

| 特徴 | Zig | Rust |
|------|-----|------|
| **暗黙的な型推論** | `anytype` | `impl Trait` |
| **明示的な型パラメータ** | `comptime T: type` | `<T>` |
| **型制約** | `@hasDecl`, `@hasField`, `@typeInfo` | トレイト境界 `T: Trait` |
| **構造体の定義** | `fn Name(comptime T: type) type` | `struct Name<T>` |

### 型制約の表現力

**Zig:**
- `@hasDecl`でメソッドの存在をチェック
- `@hasField`でフィールドの存在をチェック
- `@typeInfo`で型の詳細情報を取得
- コンパイル時に`@compileError`でエラーを出す
- 柔軟だが、型安全性はRustより低い

**Rust:**
- トレイト境界で型の振る舞いを明示的に定義
- コンパイラが自動的に型チェック
- より厳格で型安全
- トレイトの実装が必要

### コンパイル時評価

**Zig:**
- `comptime`ブロックでコンパイル時に実行
- 型もコンパイル時に生成される
- 非常に強力で柔軟

**Rust:**
- `const fn`やマクロを使用
- Zigほど柔軟ではない
- より安全で予測可能

## 学習ポイント

- `anytype`で型推論（暗黙的）
- `comptime T: type`で明示的な型パラメータ
- `@hasDecl`でメソッドの存在をチェック
- `@hasField`でフィールドの存在をチェック
- `@typeInfo`で型の詳細情報を取得
- `@compileError`でコンパイル時エラー
- `fn Name(comptime T: type) type`でジェネリック構造体
- `@This()`で自己参照型を取得
- Rustのトレイトより柔軟だが、型安全性は低い
- Zigのジェネリクスはコンパイル時に全て展開される

## ファイル構成

```
src/
├── anytype_inference.zig   # anytypeによる型推論
├── comptime_type.zig       # comptime typeパラメータ
├── type_constraints.zig    # 型制約の実現
├── generic_structures.zig  # ジェネリック構造体
└── main.zig                # メインプログラム
```

## 次のステップ

- より複雑なジェネリック構造体を実装する
- 型制約を組み合わせて使用する
- パフォーマンスへの影響を理解する
- メタプログラミングとの組み合わせを学ぶ

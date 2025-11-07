# 06. エラーハンドリング

このチュートリアルでは、Zigにおけるエラーハンドリングの仕組みについて学びます。

## サンプルファイル

### 1. src/error_set_example.zig - エラーセット

エラーセットの定義と、エラーユニオンの使い方を学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- エラーセットの定義
- エラーユニオン（`!T` 型）
- エラーを返す関数の定義
- `catch` によるエラーハンドリング

**コード例:**
```zig
// エラーセットの定義
const MathError = error{
    DivisionByZero,
    Overflow,
    NegativeValue,
};

// エラーユニオン（Rustの Result<T, E> 相当）
fn divide(a: i32, b: i32) MathError!i32 {
    if (b == 0) return error.DivisionByZero;
    return @divTrunc(a, b);
}

pub fn main() void {
    const result = divide(10, 2) catch |err| {
        std.debug.print("Error: {}\n", .{err});
        return;
    };

    std.debug.print("Result: {}\n", .{result});
}
```

### 2. src/try_catch_example.zig - try と catch

`try` によるエラー伝播と、`catch` による詳細なエラーハンドリングを学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- `try` によるエラー伝播（Rustの `?` 演算子）
- `catch` によるエラーハンドリング
- switchを使った特定のエラーの処理
- エラーの種類に応じた処理の分岐

**コード例:**
```zig
const FileError = error{
    FileNotFound,
    PermissionDenied,
};

fn readFile(path: []const u8) FileError![]const u8 {
    if (std.mem.eql(u8, path, "missing.txt")) {
        return error.FileNotFound;
    }
    return "file contents";
}

fn processFile(path: []const u8) FileError!void {
    // try でエラーを伝播（Rustの ? 演算子）
    const contents = try readFile(path);
    std.debug.print("Contents: {s}\n", .{contents});
}

pub fn main() void {
    // catch でエラーをハンドル
    processFile("data.txt") catch |err| {
        std.debug.print("Failed to process file: {}\n", .{err});
    };

    // 特定のエラーをキャッチ
    const result = readFile("missing.txt") catch |err| switch (err) {
        error.FileNotFound => {
            std.debug.print("File not found\n", .{});
            return;
        },
        error.PermissionDenied => {
            std.debug.print("Permission denied\n", .{});
            return;
        },
    };
}
```

### 3. src/anyerror_example.zig - anyerror と推論

任意のエラーを扱う `anyerror` と、エラーセットの推論について学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- `anyerror` による任意のエラーの処理
- `!T` によるエラーセットの自動推論
- 複数の関数からのエラー伝播
- エラーセットの合成

**コード例:**
```zig
// 任意のエラーを返せる
fn mightFail() anyerror!i32 {
    return error.SomethingWentWrong;
}

// エラーセットを推論
fn autoInferError() !i32 {
    if (false) return error.Failed;
    return 42;
}
```

## Rustとの比較

### Result vs エラーユニオン

**Rust:**
```rust
fn divide(a: i32, b: i32) -> Result<i32, String> {
    if b == 0 {
        return Err("Division by zero".to_string());
    }
    Ok(a / b)
}

fn process() -> Result<i32, String> {
    let result = divide(10, 0)?;  // ? でエラー伝播
    Ok(result)
}
```

**Zig:**
```zig
fn divide(a: i32, b: i32) !i32 {
    if (b == 0) return error.DivisionByZero;
    return @divTrunc(a, b);
}

fn process() !i32 {
    const result = try divide(10, 0);  // try でエラー伝播
    return result;
}
```

**主な違い:**
- Zigは `!T` でエラーユニオンを表現（Rustの `Result<T, E>`）
- Zigの `try` は Rustの `?` に相当
- Zigの `catch` は Rustの `match` や `unwrap_or_else` に相当
- Zigのエラーは軽量（enumとして扱われる）

## 学習ポイント

- `error` キーワードでエラー値を定義
- `!T` はエラーユニオン（`T` または `error`）
- `try` でエラーを伝播（Rustの `?`）
- `catch` でエラーをハンドル
- `anyerror` で任意のエラーを扱う
- Rustの `Result` より軽量で高速

## よくあるコンパイルエラー

### エラー1: expected type 'i32', found 'error{DivisionByZero}!i32'

```
error: expected type 'i32', found 'error{DivisionByZero}!i32'
```

**原因:** エラーユニオンを `try` や `catch` なしで使用している

**対処:** `try` を付けてエラーを伝播するか、`catch` でハンドルする

```zig
// エラー
const result: i32 = divide(10, 2);

// 正しい（tryで伝播）
const result = try divide(10, 2);

// 正しい（catchでハンドル）
const result = divide(10, 2) catch 0;
```

### エラー2: error is discarded

```
error: error is discarded
```

**原因:** エラーユニオンを返す関数の戻り値を無視している

**対処:** `try` を付けるか、`_ = ` で明示的に無視する

```zig
// エラー
processFile("data.txt");

// 正しい（tryで伝播）
try processFile("data.txt");

// 正しい（catchでハンドル）
processFile("data.txt") catch {};

// 正しい（明示的に無視）
_ = processFile("data.txt");
```

### エラー3: unreachable code

```
error: unreachable code
```

**原因:** `return` 後にコードが続いている、または `catch` 内で必ず `return` している

**対処:** 到達不可能なコードを削除する

```zig
// エラー
const result = divide(10, 0) catch |err| {
    std.debug.print("Error: {}\n", .{err});
    return;
};
std.debug.print("Result: {}\n", .{result}); // 到達不可能

// 正しい（returnを削除）
const result = divide(10, 0) catch |err| {
    std.debug.print("Error: {}\n", .{err});
    0 // デフォルト値を返す
};
std.debug.print("Result: {}\n", .{result});
```

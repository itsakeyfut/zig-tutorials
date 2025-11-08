# 13. テスト

このチュートリアルでは、Zigにおけるテストの書き方と実行方法について学びます。

## サンプルファイル

### 1. src/basic_test.zig - 基本的なテスト

`test` ブロックを使った基本的なテストの書き方を学びます。

**実行方法:**
```bash
# プログラムとして実行
zig build run

# テストを実行
zig test src/basic_test.zig
```

**学習内容:**
- `test` ブロックの基本
- `std.testing.expectEqual` によるアサーション
- 正の数と負の数のテスト

**コード例:**
```zig
const std = @import("std");

fn add(a: i32, b: i32) i32 {
    return a + b;
}

test "basic addition" {
    const result = add(2, 3);
    try std.testing.expectEqual(5, result);
}

test "negative numbers" {
    const result = add(-5, 3);
    try std.testing.expectEqual(-2, result);
}
```

### 2. src/error_test.zig - エラーのテスト

エラーを返す関数のテスト方法を学びます。

**実行方法:**
```bash
# プログラムとして実行
zig build run

# テストを実行
zig test src/error_test.zig
```

**学習内容:**
- エラー型の定義
- `std.testing.expectError` によるエラーのテスト
- 正常系とエラー系の両方のテスト

**コード例:**
```zig
const MathError = error{DivisionByZero};

fn divide(a: i32, b: i32) MathError!i32 {
    if (b == 0) return error.DivisionByZero;
    return @divTrunc(a, b);
}

test "division by zero" {
    const result = divide(10, 0);
    try std.testing.expectError(error.DivisionByZero, result);
}

test "normal division" {
    const result = try divide(10, 2);
    try std.testing.expectEqual(5, result);
}
```

## テストの実行方法

### 単一ファイルのテスト
```bash
zig test src/basic_test.zig
zig test src/error_test.zig
```

### プロジェクト全体のテスト
```bash
zig build test
```

### プログラムの実行（テストの動作デモ）
```bash
zig build run
```

## Rustとの比較

### テストの書き方

**Rust:**
```rust
// Rust
#[test]
fn test_add() {
    assert_eq!(add(2, 3), 5);
}

#[test]
#[should_panic(expected = "division by zero")]
fn test_divide_by_zero() {
    divide(10, 0);
}
```

**Zig:**
```zig
// Zig
test "add" {
    try std.testing.expectEqual(5, add(2, 3));
}

test "divide by zero" {
    const result = divide(10, 0);
    try std.testing.expectError(error.DivisionByZero, result);
}
```

**主な違い:**
- Rustは `#[test]` 属性、Zigは `test` キーワード
- Rustは `assert_eq!`、Zigは `std.testing.expectEqual`
- Zigはエラーを明示的に `expectError` でテストする
- 両方ともテストに説明的な名前をつけられる

## 学習ポイント

- `test` ブロックでテストを記述
- `std.testing` モジュールでアサーション関数を提供
- `zig test` コマンドで単一ファイルのテスト実行
- `zig build test` でプロジェクト全体のテスト実行
- エラーは `expectError` でテスト可能
- テスト名は文字列で記述できる

## よくある `std.testing` の関数

### expectEqual
```zig
test "expectEqual example" {
    try std.testing.expectEqual(42, 42);
}
```
期待値と実際の値が等しいことを確認します。

### expectError
```zig
test "expectError example" {
    const result = someErrorFunction();
    try std.testing.expectError(error.SomeError, result);
}
```
関数がエラーを返すことを確認します。

### expect
```zig
test "expect example" {
    try std.testing.expect(true);
    try std.testing.expect(2 + 2 == 4);
}
```
条件が真であることを確認します。

### expectEqualStrings
```zig
test "expectEqualStrings example" {
    try std.testing.expectEqualStrings("hello", "hello");
}
```
文字列が等しいことを確認します。

## よくあるコンパイルエラー

### エラー1: test declaration must be at top level

```
error: test declaration must be at top level
```

**原因:** `test` ブロックを関数の中に記述している

**対処:** `test` ブロックはファイルのトップレベルに記述する

### エラー2: expected error, found value

```
error: expected error union type, found 'i32'
```

**原因:** エラーを返さない関数に `expectError` を使用している

**対処:** 正常な値を返す関数には `expectEqual` などを使用する

### エラー3: unused variable

```
error: unused local variable
```

**原因:** テスト内で変数を定義したが使用していない

**対処:** 変数を使用するか、`_ = variable;` で明示的に無視する

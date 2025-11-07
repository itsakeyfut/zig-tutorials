# 2. 変数宣言

このチュートリアルでは、Zigにおける変数宣言の基本を学びます。

## 概要

- `var` と `const` の使い分け
- 型推論の仕組み
- `comptime` 変数によるコンパイル時計算

## var と const

```zig
const std = @import("std");

pub fn main() void {
    // const: 不変（Rustの let）
    const x: i32 = 10;
    // x = 20;  // ❌ エラー

    // var: 可変（Rustの let mut）
    var y: i32 = 10;
    y = 20;  // ✅ OK

    std.debug.print("x = {}, y = {}\n", .{x, y});
}
```

**ポイント:**
- `const`: 値を変更できない不変の変数
- `var`: 値を変更できる可変の変数
- デフォルトで `const` を使用し、必要な場合のみ `var` を使う

## 型推論

```zig
pub fn main() void {
    // 型推論（Rustと同様）
    const x = 10;        // i32 と推論
    const pi = 3.14;     // f64 と推論
    const flag = true;   // bool

    // 明示的な型
    const y: u8 = 255;
    const z: f32 = 1.5;
}
```

**ポイント:**
- Zigは値から型を推論できる
- 必要に応じて明示的に型を指定可能
- 整数リテラルは `i32`、浮動小数点リテラルは `f64` がデフォルト

## comptime変数（コンパイル時定数）

```zig
pub fn main() void {
    // コンパイル時に計算される
    const result = comptime fibonacci(10);
    std.debug.print("fibonacci(10) = {}\n", .{result});
}

fn fibonacci(n: comptime_int) comptime_int {
    if (n <= 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}
```

**ポイント:**
- `comptime` キーワードでコンパイル時に評価される
- フィボナッチ数列のような計算もコンパイル時に実行可能
- 実行時のオーバーヘッドがゼロ
- **注意**: `comptime const` は冗長なので、`const` と `comptime` を分けて使用

## Rustとの比較

```rust
// Rust
let x = 10;           // 不変
let mut y = 10;       // 可変
const MAX: i32 = 100; // コンパイル時定数
```

```zig
// Zig
const x: i32 = 10;        // 不変
var y: i32 = 10;          // 可変
const MAX = 100;          // コンパイル時定数（constは既にコンパイル時定数）
```

## 学習ポイント

1. **`const` がデフォルト** - Rustと同じ思想で、デフォルトは不変
2. **`var` は最小限に** - 可変変数は本当に必要な場合のみ使用
3. **`comptime` の活用** - コンパイル時に計算を完了させてパフォーマンス向上

## よくあるコンパイルエラー

### エラー: cannot assign to constant

```zig
const x = 10;
x = 20;  // ❌ エラー
```

**原因:** `const` 変数に再代入しようとしている

**対処法:** 変数を `var` に変更する

```zig
var x = 10;
x = 20;  // ✅ OK
```

### エラー: 'comptime const' is redundant

```zig
comptime const x = 10;  // ❌ エラー
```

**原因:** `comptime const` は冗長

**対処法:** `const` を使うか、初期化式に `comptime` を使用

```zig
const x = 10;                   // ✅ OK
const result = comptime fib(5); // ✅ OK
```

## 実行方法

```bash
# ビルドして実行
zig build run

# または直接実行
zig run src/main.zig
```

## 期待される出力

```
=== Zigの変数宣言 ===

1. var と const の基本
  x = 10, y = 20

2. 型推論
  inferred_int = 10 (型: i32)
  pi = 3.14 (型: f64)
  flag = true (型: bool)
  explicit_u8 = 255 (型: u8)
  explicit_f32 = 1.5 (型: f32)

3. comptime変数
  fibonacci(10) = 55 (コンパイル時に計算)
```

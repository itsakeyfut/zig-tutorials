# 11. comptime入門

このチュートリアルでは、Zigにおけるcomptime（コンパイル時計算）の基本について学びます。

## サンプルファイル

### 1. src/comptime_variable.zig - comptime変数

コンパイル時に計算される変数の使い方を学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- comptime変数の宣言と使用
- inline forループ
- コンパイル時の計算

**コード例:**
```zig
pub fn main() void {
    // コンパイル時に計算
    comptime var x = 0;
    inline for (0..5) |i| {
        x += i;
    }

    std.debug.print("Sum: {}\n", .{x});  // 10
}
```

**ポイント:**
- `comptime var` でコンパイル時に評価される変数を定義
- `inline for` はコンパイル時に展開されるループ
- 計算結果（10）は実行時ではなくコンパイル時に確定

### 2. src/generic_function.zig - ジェネリック関数

型パラメータを使った汎用的な関数の作り方を学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- comptime型パラメータ
- ジェネリック関数の定義
- 複数の型での関数の使用

**コード例:**
```zig
fn max(comptime T: type, a: T, b: T) T {
    return if (a > b) a else b;
}

pub fn main() void {
    const x = max(i32, 10, 20);
    const y = max(f32, 1.5, 2.5);

    std.debug.print("max(10, 20) = {}\n", .{x});
    std.debug.print("max(1.5, 2.5) = {}\n", .{y});
}
```

**ポイント:**
- `comptime T: type` で型パラメータを受け取る
- 同じ関数が異なる型で動作する
- コンパイル時に各型ごとのコードが生成される

## Rustとの比較

### ジェネリクスの構文

**Rust:**
```rust
// Rust: ジェネリクス
fn max<T: PartialOrd>(a: T, b: T) -> T {
    if a > b { a } else { b }
}

let x = max(10, 20);
let y = max(1.5, 2.5);
```

**Zig:**
```zig
// Zig: comptime型パラメータ
fn max(comptime T: type, a: T, b: T) T {
    return if (a > b) a else b;
}

const x = max(i32, 10, 20);
const y = max(f32, 1.5, 2.5);
```

**主な違い:**
- Rustは型パラメータを `<T>` で記述
- Zigは `comptime T: type` で明示的に記述
- Rustは型推論で型を省略可能
- Zigは型を明示的に渡す必要がある
- Rustはトレイト境界（`PartialOrd`）で制約を表現
- Zigは型の能力をコンパイル時にチェック

### コンパイル時計算

**Rust:**
```rust
// Rust: const fn
const fn sum_range() -> i32 {
    let mut x = 0;
    let mut i = 0;
    while i < 5 {
        x += i;
        i += 1;
    }
    x
}

const RESULT: i32 = sum_range();
```

**Zig:**
```zig
// Zig: comptime
comptime var x = 0;
inline for (0..5) |i| {
    x += i;
}
// x は コンパイル時に 10 として確定
```

**主な違い:**
- Rustは `const fn` でコンパイル時関数を定義
- Zigは `comptime` でコンパイル時評価を明示
- Zigの `inline for` はコンパイル時に展開される
- Rustはより制約が厳しい（const fnで使える機能が限定的）

## 学習ポイント

- `comptime` でコンパイル時計算を実現
- ジェネリクスは `comptime` で実現
- `inline for` はコンパイル時に展開されるループ
- コンパイル時に型チェックが行われる
- 詳細はProfessional編で

## よくあるコンパイルエラー

### エラー1: unable to evaluate constant expression

```
error: unable to evaluate constant expression
```

**原因:** comptime変数に実行時の値を代入しようとしている

**対処:** comptime変数にはコンパイル時に確定できる値のみ代入する

**例:**
```zig
// ❌ エラー
var runtime_value: i32 = 10;
comptime var x = runtime_value;  // 実行時の値

// ✅ 正しい
comptime var x = 10;  // コンパイル時定数
```

### エラー2: type mismatch

```
error: expected type 'i32', found 'f32'
```

**原因:** ジェネリック関数に異なる型の引数を渡している

**対処:** すべての引数を同じ型にする

**例:**
```zig
// ❌ エラー
const result = max(i32, 10, 20.5);  // 20.5 は f32

// ✅ 正しい
const result = max(i32, 10, 20);
```

### エラー3: inline loop requires comptime bounds

```
error: inline loop requires comptime bounds
```

**原因:** `inline for` の範囲が実行時にしか決まらない

**対処:** コンパイル時に確定する範囲を使用する

**例:**
```zig
// ❌ エラー
var n: usize = 5;
inline for (0..n) |i| { }  // n は実行時の値

// ✅ 正しい
inline for (0..5) |i| { }  // 5 はコンパイル時定数
```

## 次のステップ

comptimeの基本を理解したら、以下のトピックに進むことができます：

- より高度なcomptime機能（Professional編）
- 型リフレクション
- コンパイル時コード生成
- メタプログラミング

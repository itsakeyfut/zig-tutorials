# 12. 組み込み関数（基礎）

このチュートリアルでは、Zigにおける組み込み関数（Built-in Functions）について学びます。

組み込み関数は `@` で始まり、コンパイラが提供する特別な機能です。

## サンプルファイル

### 1. src/as_example.zig - @as（型変換）

明示的な型変換の方法を学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- @asによる明示的な型指定
- @floatFromIntによる整数から浮動小数点への変換
- 型安全性を保ちながらの変換

**コード例:**
```zig
pub fn main() void {
    const x: i32 = 10;
    const y = @as(f32, @floatFromInt(x));

    std.debug.print("x = {}, y = {}\n", .{x, y});
}
```

**ポイント:**
- `@as(型, 値)` で明示的に型を指定
- `@floatFromInt()` で整数を浮動小数点に変換
- 型変換は明示的に行う必要がある

### 2. src/intcast_example.zig - @intCast（整数キャスト）

整数型間のキャストについて学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- 異なるサイズの整数型間の変換
- @intCastの使い方
- 範囲外の値に対する動作

**コード例:**
```zig
pub fn main() void {
    const x: i32 = 1000;
    const y: i16 = @intCast(x);

    std.debug.print("y = {}\n", .{y});
}
```

**ポイント:**
- `@intCast()` で整数型を変換
- デバッグモードでは範囲外の値でパニックする
- リリースモードでは値が切り詰められる

**注意:**
```zig
// デバッグモードでパニック
const x: i32 = 100000;
const y: i16 = @intCast(x);  // i16の範囲外（-32768 ~ 32767）
```

### 3. src/typeof_example.zig - @TypeOf（型取得）

変数やリテラルの型を取得する方法を学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- @TypeOfで型情報を取得
- 型推論の確認
- メタプログラミングの基礎

**コード例:**
```zig
pub fn main() void {
    const x = 10;
    const y = 3.14;

    std.debug.print("Type of x: {}\n", .{@TypeOf(x)});
    std.debug.print("Type of y: {}\n", .{@TypeOf(y)});
}
```

**ポイント:**
- `@TypeOf(値)` で値の型を取得
- コンパイル時に型情報を扱える
- ジェネリック関数で活用できる

## Rustとの比較

### 型変換の構文

**Rust:**
```rust
// Rust: as キーワード
let x: i32 = 10;
let y = x as f32;

// 整数キャスト
let a: i32 = 1000;
let b = a as i16;

// 型情報の取得
use std::any::type_name;
println!("{}", type_name::<i32>());
```

**Zig:**
```zig
// Zig: 組み込み関数
const x: i32 = 10;
const y = @as(f32, @floatFromInt(x));

// 整数キャスト
const a: i32 = 1000;
const b: i16 = @intCast(a);

// 型情報の取得
std.debug.print("{}\n", .{@TypeOf(x)});
```

**主な違い:**
- Rustは `as` キーワードで型変換
- Zigは組み込み関数（`@` で始まる）を使用
- Rustは整数と浮動小数点の変換も `as` で可能
- Zigは変換の種類によって異なる関数を使う（`@floatFromInt`, `@intFromFloat` など）
- Zigの方が変換の意図が明確

### 型安全性

**Rust:**
```rust
// Rustは範囲外の値を暗黙的に処理
let x: i32 = 100000;
let y = x as i16;  // 警告は出るが、値は切り詰められる
```

**Zig:**
```zig
// Zigはデバッグモードで範囲チェック
const x: i32 = 100000;
const y: i16 = @intCast(x);  // デバッグモードでパニック
```

**主な違い:**
- Zigはデバッグモードで厳格な範囲チェック
- Rustは基本的に切り詰めるが警告を出す
- Zigの方が開発時にバグを見つけやすい

## よく使う組み込み関数

### 型変換系

| 関数 | 用途 |
|------|------|
| `@as(型, 値)` | 明示的な型指定 |
| `@intCast(値)` | 整数型のキャスト |
| `@floatCast(値)` | 浮動小数点型のキャスト |
| `@intFromFloat(値)` | 浮動小数点を整数に変換 |
| `@floatFromInt(値)` | 整数を浮動小数点に変換 |

### 型情報系

| 関数 | 用途 |
|------|------|
| `@TypeOf(値)` | 値の型を取得 |
| `@sizeOf(型)` | 型のサイズ（バイト）を取得 |
| `@alignOf(型)` | 型のアラインメントを取得 |

## 学習ポイント

- `@` で始まる組み込み関数
- `@as` で明示的な型変換
- `@intCast` は範囲外の値でパニック（デバッグモード）
- `@TypeOf` で型情報を取得
- 詳細はドキュメント参照

## よくあるコンパイルエラー

### エラー1: expected type 'i16', found 'i32'

```
error: expected type 'i16', found 'i32'
```

**原因:** 暗黙的な型変換ができない

**対処:** `@intCast` を使って明示的に変換する

**例:**
```zig
// ❌ エラー
const x: i32 = 1000;
const y: i16 = x;

// ✅ 正しい
const x: i32 = 1000;
const y: i16 = @intCast(x);
```

### エラー2: integer value 100000 cannot be coerced to type 'i16'

```
error: integer value 100000 cannot be coerced to type 'i16'
```

**原因:** コンパイル時に範囲外の値を検出

**対処:** 値を範囲内に収めるか、より大きな型を使用する

**例:**
```zig
// ❌ エラー（コンパイル時定数）
const y: i16 = 100000;

// ✅ 正しい（範囲内の値）
const y: i16 = 1000;

// ✅ または大きな型を使用
const y: i32 = 100000;
```

### エラー3: runtime cast to 'i16' from 'i32' which overflowed

```
thread ... panic: integer cast truncated bits
```

**原因:** 実行時に範囲外の値を `@intCast` で変換しようとした

**対処:** デバッグして値が範囲内に収まるようにする、または適切な型を使用する

**例:**
```zig
// ❌ デバッグモードでパニック
var x: i32 = 100000;
const y: i16 = @intCast(x);  // i16の範囲外

// ✅ 範囲チェックを追加
var x: i32 = 100000;
if (x >= std.math.minInt(i16) and x <= std.math.maxInt(i16)) {
    const y: i16 = @intCast(x);
} else {
    // エラー処理
}
```

## 次のステップ

組み込み関数の基本を理解したら、以下のトピックに進むことができます：

- より高度な組み込み関数（Professional編）
- ポインタ操作系の組み込み関数（`@ptrCast`, `@alignCast`）
- ビット操作系の組み込み関数（`@clz`, `@ctz`）
- アトミック操作系の組み込み関数（`@atomicLoad`, `@atomicStore`）

## 参考リンク

- [Zig Language Reference - Builtin Functions](https://ziglang.org/documentation/master/#Builtin-Functions)

# 06. comptimeの実践

このチュートリアルでは、Zigのcomptime機能の実践的な使い方について学びます。

## サンプルファイル

### 1. src/comptime_basics.zig - comptime変数と関数

コンパイル時計算の基本を学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- comptime ブロック
- コンパイル時関数
- フィボナッチ数列の計算
- 階乗の計算

**コード例:**
```zig
// コンパイル時に計算
comptime {
    var sum: i32 = 0;
    var i: i32 = 0;
    while (i < 10) : (i += 1) {
        sum += i;
    }
    std.debug.assert(sum == 45);
}

// コンパイル時関数
fn fibonacci(n: comptime_int) comptime_int {
    if (n <= 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

pub fn main() void {
    // コンパイル時に計算（実行時コストゼロ）
    const fib10 = comptime fibonacci(10);
    std.debug.print("fibonacci(10) = {}\n", .{fib10});
}
```

### 2. src/inline_loops.zig - inline for/while

inline ループによるアンロールを学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- inline for によるループアンロール
- 型のイテレーション
- タプルのイテレーション
- inline while

**コード例:**
```zig
pub fn main() void {
    // inline for: ループをアンロール
    inline for (0..5) |i| {
        std.debug.print("{} ", .{i});
    }
    std.debug.print("\n", .{});

    // 配列の各要素に対して実行
    const types = [_]type{ i8, i16, i32, i64 };
    inline for (types) |T| {
        std.debug.print("Size of {}: {}\n", .{T, @sizeOf(T)});
    }
}
```

### 3. src/type_generation.zig - 型生成

型を返す関数（ジェネリクス）を学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- 型を返す関数
- ジェネリック構造体
- @This() の使用
- Option型の実装

**コード例:**
```zig
// 型を返す関数
fn Pair(comptime T: type) type {
    return struct {
        first: T,
        second: T,

        pub fn init(first: T, second: T) @This() {
            return .{ .first = first, .second = second };
        }

        pub fn swap(self: *@This()) void {
            const temp = self.first;
            self.first = self.second;
            self.second = temp;
        }
    };
}

pub fn main() void {
    var pair_int = Pair(i32).init(10, 20);
    std.debug.print("Before: ({}, {})\n", .{pair_int.first, pair_int.second});

    pair_int.swap();
    std.debug.print("After: ({}, {})\n", .{pair_int.first, pair_int.second});
}
```

### 4. src/comptime_execution.zig - コンパイル時実行の活用

コンパイル時実行の実践的な活用方法を学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- 文字列長のコンパイル時計算
- 配列のコンパイル時生成
- 文字列の逆転
- 素数の生成

**コード例:**
```zig
// 文字列の長さをコンパイル時に計算
fn compileTimeStrLen(comptime str: []const u8) comptime_int {
    return str.len;
}

// 配列を生成
fn generateArray(comptime size: usize, comptime value: i32) [size]i32 {
    var array: [size]i32 = undefined;
    for (&array) |*item| {
        item.* = value;
    }
    return array;
}

pub fn main() void {
    // コンパイル時に長さを計算
    const len = comptime compileTimeStrLen("Hello, Zig!");
    std.debug.print("Length: {}\n", .{len});

    // コンパイル時に配列を生成
    const array = comptime generateArray(5, 42);
    std.debug.print("Array: {any}\n", .{array});
}
```

## comptimeの特徴

| 機能 | 説明 | 実行時コスト |
|-----|------|------------|
| comptime 変数 | コンパイル時に値を計算 | ゼロ |
| comptime 関数 | コンパイル時に実行される関数 | ゼロ |
| inline for | ループをアンロール | ゼロ（展開される） |
| 型生成 | 型を返す関数でジェネリクスを実現 | ゼロ |

## Rustのマクロとの比較

### マクロ vs comptime関数

**Rust:**
```rust
// マクロ
macro_rules! create_array {
    ($size:expr, $val:expr) => {
        [$val; $size]
    };
}

let array = create_array!(5, 42);
```

**Zig:**
```zig
// comptime関数
fn generateArray(comptime size: usize, comptime value: i32) [size]i32 {
    var array: [size]i32 = undefined;
    for (&array) |*item| {
        item.* = value;
    }
    return array;
}

const array = comptime generateArray(5, 42);
```

**主な違い:**
- Rust: マクロはテキスト置換
- Zig: comptime関数は通常のZigコード
- Zig: 型安全でエラーメッセージが明確
- Zig: デバッグが容易

### ジェネリクス

**Rust:**
```rust
struct Pair<T> {
    first: T,
    second: T,
}

impl<T> Pair<T> {
    fn new(first: T, second: T) -> Self {
        Pair { first, second }
    }
}

let pair = Pair::new(10, 20);
```

**Zig:**
```zig
fn Pair(comptime T: type) type {
    return struct {
        first: T,
        second: T,

        pub fn init(first: T, second: T) @This() {
            return .{ .first = first, .second = second };
        }
    };
}

const pair = Pair(i32).init(10, 20);
```

**主な違い:**
- Rust: 特別な構文 `<T>`
- Zig: 通常の関数として実装
- Zig: 型も値として扱える
- 両方とも型安全

### const 関数

**Rust:**
```rust
const fn fibonacci(n: u32) -> u32 {
    if n <= 1 { n } else { fibonacci(n - 1) + fibonacci(n - 2) }
}

const FIB10: u32 = fibonacci(10);
```

**Zig:**
```zig
fn fibonacci(n: comptime_int) comptime_int {
    if (n <= 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

const fib10 = comptime fibonacci(10);
```

**主な違い:**
- Rust: `const fn` キーワード（制限あり）
- Zig: comptime でほぼ全てのコードが実行可能
- Zig: より強力で柔軟

## 学習ポイント

- `comptime` でコンパイル時に実行
- 実行時コストはゼロ（定数として埋め込まれる）
- `inline` でループアンロール
- 型を生成する関数でジェネリクスを実現
- Rustのマクロより強力で型安全
- 通常のZigコードとして記述できる
- デバッグが容易

## よくあるコンパイルエラー

### エラー1: unable to evaluate constant expression

```
error: unable to evaluate constant expression
```

**原因:** コンパイル時に評価できない式を comptime で使用している

**対処:** コンパイル時に評価可能な式のみを使用する

```zig
// ❌ 実行時の値
fn bad() void {
    var x: i32 = 10;
    const y = comptime x + 5;  // エラー
}

// ✅ コンパイル時の値
fn good() void {
    const x: i32 = 10;
    const y = comptime x + 5;  // OK
}
```

### エラー2: comptime parameter must be comptime-known

```
error: parameter must be comptime-known
```

**原因:** comptime パラメータに実行時の値を渡している

**対処:** コンパイル時定数を渡す

```zig
fn generateArray(comptime size: usize) [size]i32 { ... }

// ❌ 実行時の値
fn bad() void {
    var size: usize = 5;
    const arr = generateArray(size);  // エラー
}

// ✅ コンパイル時定数
fn good() void {
    const size: usize = 5;
    const arr = generateArray(size);  // OK
}
```

### エラー3: expected type 'type', found '...'

```
error: expected type 'type', found '...'
```

**原因:** 型パラメータに型以外の値を渡している

**対処:** 型を渡す

```zig
fn Pair(comptime T: type) type { ... }

// ❌ 値を渡している
const BadPair = Pair(42);  // エラー

// ✅ 型を渡す
const GoodPair = Pair(i32);  // OK
```

### エラー4: cannot store runtime value in comptime variable

```
error: cannot store runtime value in comptime variable
```

**原因:** 実行時の値をcomptime変数に代入しようとしている

**対処:** comptime変数にはコンパイル時定数のみを代入する

```zig
// ❌ 実行時の値
fn bad() void {
    var x: i32 = 10;
    comptime var y = x;  // エラー
}

// ✅ コンパイル時定数
fn good() void {
    const x: i32 = 10;
    comptime var y = x;  // OK
}
```

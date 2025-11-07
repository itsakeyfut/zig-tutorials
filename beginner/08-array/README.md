# 08. 配列とスライス

このチュートリアルでは、Zigの配列（`[N]T`）とスライス（`[]T`）について学びます。

## サンプルファイル

### 1. src/array_basic.zig - 配列の基本

配列の宣言、型推論、アクセス、長さの取得、繰り返し初期化について学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- 配列の宣言（`[N]T`）
- 型推論（`[_]T`）
- 要素へのアクセス
- 配列の長さ（`.len`）
- 繰り返し初期化（`** N`）

**コード例:**
```zig
pub fn main() void {
    // 配列の宣言
    const array1 = [5]i32{ 1, 2, 3, 4, 5 };

    // 型推論（[_] で要素数を推論）
    const array2 = [_]i32{ 10, 20, 30 };

    // 要素にアクセス
    std.debug.print("array1[0] = {}\n", .{array1[0]});

    // 長さ
    std.debug.print("Length: {}\n", .{array1.len});

    // 繰り返し初期化
    const zeros = [_]i32{0} ** 10;  // [0, 0, 0, ..., 0]
}
```

### 2. src/slice_basic.zig - スライスの基本

スライスの作成、部分スライス、範囲指定について学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- 配列全体のスライス
- 部分スライス（`[start..end]`）
- 開始のみ指定（`[start..]`）
- 終了のみ指定（`[0..end]`）
- スライスの反復処理

**コード例:**
```zig
pub fn main() void {
    const array = [_]i32{ 1, 2, 3, 4, 5 };

    // 配列全体のスライス
    const slice1: []const i32 = &array;

    // 部分スライス
    const slice2 = array[1..4];  // [2, 3, 4]

    // 開始のみ指定
    const slice3 = array[2..];   // [3, 4, 5]

    for (slice2) |item| {
        std.debug.print("{}\n", .{item});
    }
}
```

### 3. src/string_slice.zig - 文字列（スライス）

文字列リテラル、比較、部分文字列、UTF-8エンコーディングについて学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- 文字列リテラル（`[]const u8`）
- 型推論
- 文字列の長さ
- 文字列の比較（`std.mem.eql`）
- 部分文字列（スライス）
- UTF-8エンコーディング

**コード例:**
```zig
pub fn main() void {
    // 文字列リテラル（[]const u8）
    const str1: []const u8 = "Hello, Zig!";

    // 型推論
    const str2 = "Hello, World!";

    // 文字列の長さ
    std.debug.print("Length: {}\n", .{str1.len});

    // 文字列の比較
    if (std.mem.eql(u8, str1, str2)) {
        std.debug.print("Equal\n", .{});
    } else {
        std.debug.print("Not equal\n", .{});
    }

    // 部分文字列
    const substr = str1[0..5];  // "Hello"
    std.debug.print("{s}\n", .{substr});
}
```

**重要な注意点:**
- Zigには `String` 型がない
- 文字列は `[]const u8`（バイト配列のスライス）
- UTF-8エンコードされたバイト列
- `{s}` フォーマット指定子を使う

### 4. src/mutable_slice.zig - 可変スライス

可変スライスの作成、値の変更、constとの違いについて学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- 可変スライスの作成
- スライスを通じた値の変更
- 元の配列への影響
- `[]const T` と `[]T` の違い

**コード例:**
```zig
pub fn main() void {
    var array = [_]i32{ 1, 2, 3, 4, 5 };

    // 可変スライス
    const slice: []i32 = &array;

    slice[0] = 10;
    slice[1] = 20;

    for (slice) |item| {
        std.debug.print("{}\n", .{item});
    }
}
```

**重要な注意点:**
- `[]const T`: 読み取り専用スライス
- `[]T`: 読み書き可能スライス
- スライスは配列のビュー（コピーではない）
- スライスの変更は元の配列に影響する

## Rustとの比較

### 配列とスライス

**Rust:**
```rust
// 配列
let array: [i32; 5] = [1, 2, 3, 4, 5];

// スライス
let slice: &[i32] = &array[1..4];

// 可変スライス
let mut array = [1, 2, 3, 4, 5];
let slice: &mut [i32] = &mut array;
slice[0] = 10;

// 文字列
let str: &str = "Hello";
```

**Zig:**
```zig
// 配列
const array = [5]i32{ 1, 2, 3, 4, 5 };

// スライス
const slice: []const i32 = array[1..4];

// 可変スライス
var array = [_]i32{ 1, 2, 3, 4, 5 };
const slice: []i32 = &array;
slice[0] = 10;

// 文字列
const str: []const u8 = "Hello";
```

**主な違い:**
- Rustの `[T; N]` は Zigでは `[N]T`（順序が逆）
- Rustの `&[T]` は Zigでは `[]const T`
- Rustの `&mut [T]` は Zigでは `[]T`
- Rustの `&str` は Zigでは `[]const u8`
- Zigには `String` 型がない（常にバイト列）

## 学習ポイント

- **配列**: `[N]T`（固定サイズ、コンパイル時にサイズが決定）
- **スライス**: `[]T`（可変サイズ、実行時にサイズが決定）
- **文字列**: `[]const u8`（UTF-8エンコードされたバイト列）
- **型推論**: `[_]T` で要素数を自動推論
- **スライスの範囲**: `[start..end]`、`[start..]`、`[0..end]`
- **繰り返し初期化**: `[_]T{value} ** count`
- **不変スライス**: `[]const T`
- **可変スライス**: `[]T`
- Zigには `String` 型がない

## よくあるコンパイルエラー

### エラー1: array access of non-array type

```
error: array access of non-array type '[]const i32'
```

**原因:** スライスに対して配列の範囲外アクセスを試みている

**対処:** インデックスが範囲内であることを確認する

```zig
// エラー
const slice: []const i32 = &array;
const value = slice[10];  // 範囲外

// 正しい
if (10 < slice.len) {
    const value = slice[10];
}
```

### エラー2: expected type '[N]T', found '[]const T'

```
error: expected type '[5]i32', found '[]const i32'
```

**原因:** 配列が期待されているのに、スライスを渡している

**対処:** 型を一致させる

```zig
fn takesArray(array: [5]i32) void {
    // ...
}

const array = [5]i32{ 1, 2, 3, 4, 5 };
const slice: []const i32 = &array;

// エラー
takesArray(slice);

// 正しい
takesArray(array);
```

### エラー3: cannot assign to constant

```
error: cannot assign to constant
```

**原因:** `[]const T` スライスに対して値を変更しようとしている

**対処:** `[]T` 可変スライスを使う

```zig
var array = [_]i32{ 1, 2, 3, 4, 5 };

// エラー
const const_slice: []const i32 = &array;
const_slice[0] = 10;  // cannot assign to constant

// 正しい
const mut_slice: []i32 = &array;
mut_slice[0] = 10;
```

### エラー4: sentinel mismatch

```
error: sentinel mismatch: expected 'null', found 'undefined'
```

**原因:** 文字列リテラルとバイト配列の型の不一致

**対処:** 適切な型を使う

```zig
// エラー（センチネル終端の不一致）
const str: [11]u8 = "Hello, Zig!";

// 正しい（スライスとして扱う）
const str: []const u8 = "Hello, Zig!";

// または配列として明示的に
const str = "Hello, Zig!".*;
```

### エラー5: expected type expression, found '..'

```
error: expected type expression, found '..'
```

**原因:** `[..end]` 構文を使おうとしている（Zigではサポートされていない）

**対処:** `[0..end]` を使う

```zig
const array = [_]i32{ 1, 2, 3, 4, 5 };

// エラー
const slice = array[..3];

// 正しい
const slice = array[0..3];
```

## ベストプラクティス

1. **配列のサイズ推論**: `[_]T` を使って要素数を自動推論させる
2. **不変がデフォルト**: `[]const T` を優先し、必要な場合のみ `[]T` を使う
3. **文字列は `[]const u8`**: Zigには `String` 型がないことを理解する
4. **スライスは範囲チェック**: インデックスアクセス前に `.len` で確認
5. **UTF-8を意識**: 文字列はバイト列なので、文字数とバイト数は異なる
6. **スライスはビュー**: コピーではないため、元の配列への変更に注意
7. **文字列フォーマット**: `{s}` を使って文字列を出力する
8. **配列の初期化**: 繰り返し初期化には `** N` を使う

## 実践的な例

### 配列の走査

```zig
const array = [_]i32{ 1, 2, 3, 4, 5 };

// インデックス付き
for (array, 0..) |item, i| {
    std.debug.print("[{}] = {}\n", .{ i, item });
}

// 値のみ
for (array) |item| {
    std.debug.print("{}\n", .{item});
}
```

### スライスの比較

```zig
const a = [_]i32{ 1, 2, 3 };
const b = [_]i32{ 1, 2, 3 };

if (std.mem.eql(i32, &a, &b)) {
    std.debug.print("Equal\n", .{});
}
```

### 文字列の結合（スライス）

```zig
// Zigには文字列結合の組み込み機能がない
// アロケータを使う必要がある（後のチュートリアルで説明）

const str1 = "Hello, ";
const str2 = "Zig!";

// スライスで結合できない（コンパイル時のみ可能）
// const combined = str1 ++ str2;  // コンパイル時のみ
```

### 配列のコピー

```zig
const src = [_]i32{ 1, 2, 3, 4, 5 };
var dst: [5]i32 = undefined;

// std.mem.copy を使う
std.mem.copy(i32, &dst, &src);

// または手動でコピー
for (src, 0..) |item, i| {
    dst[i] = item;
}
```

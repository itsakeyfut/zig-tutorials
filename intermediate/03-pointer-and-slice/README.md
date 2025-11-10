# 03. ポインタとスライス

このチュートリアルでは、Zigにおけるポインタとスライスの使い方について学びます。

## サンプルファイル

### 1. src/single_item_pointer.zig - シングルアイテムポインタ

単一の値を指すポインタの使い方を学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- ポインタの作成（`&x`）
- 参照外し（`ptr.*`）
- 変更可能なポインタ（`*T`）
- 読み取り専用ポインタ（`*const T`）

**コード例:**
```zig
var x: i32 = 42;

// ポインタの作成
const ptr: *i32 = &x;
const const_ptr: *const i32 = &x;

// 参照外し
std.debug.print("Value: {}\n", .{ptr.*});

// ポインタ経由で変更
ptr.* = 100;
std.debug.print("New value: {}\n", .{x});

// const ポインタは変更不可
// const_ptr.* = 200;  // ❌ エラー
```

### 2. src/multi_item_pointer.zig - マルチアイテムポインタ

複数の要素を指すポインタ（長さ情報なし）の使い方を学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- マルチアイテムポインタ（`[*]T`）
- インデックスアクセス
- ポインタ演算
- 長さ情報の手動管理

**コード例:**
```zig
const array = [_]i32{ 1, 2, 3, 4, 5 };

// マルチアイテムポインタ（長さ情報なし）
const ptr: [*]const i32 = &array;

// インデックスでアクセス
std.debug.print("ptr[0] = {}\n", .{ptr[0]});
std.debug.print("ptr[1] = {}\n", .{ptr[1]});

// 長さは自分で管理する必要がある
for (0..array.len) |i| {
    std.debug.print("ptr[{}] = {}\n", .{i, ptr[i]});
}
```

### 3. src/slice_internals.zig - スライスの内部構造

スライスがポインタと長さで構成されていることを学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- スライス = ポインタ + 長さ
- `slice.ptr` と `slice.len`
- 境界チェック
- サブスライスの作成

**コード例:**
```zig
const array = [_]i32{ 1, 2, 3, 4, 5 };

// スライス = ポインタ + 長さ
const slice: []const i32 = &array;

// スライスの構造
std.debug.print("ptr: {*}\n", .{slice.ptr});
std.debug.print("len: {}\n", .{slice.len});

// スライスからポインタを取得
const ptr: [*]const i32 = slice.ptr;
std.debug.print("ptr[0] = {}\n", .{ptr[0]});
```

### 4. src/pointer_slice_conversion.zig - ポインタとスライスの変換

ポインタとスライスの間の変換方法を学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- 配列 → スライス
- スライス → ポインタ
- ポインタ → スライス
- シングルアイテムポインタ → スライス

**コード例:**
```zig
var array = [_]i32{ 1, 2, 3, 4, 5 };

// 配列 → スライス
const slice: []i32 = &array;

// スライス → ポインタ
const ptr: [*]i32 = slice.ptr;

// ポインタ → スライス（長さを指定）
const new_slice: []i32 = ptr[0..5];

// シングルアイテムポインタ → スライス（長さ1）
var single: i32 = 42;
const single_ptr: *i32 = &single;
const single_slice: []i32 = single_ptr[0..1];

std.debug.print("single_slice[0] = {}\n", .{single_slice[0]});
```

### 5. src/pointer_practical.zig - ポインタの実践例

ポインタとスライスを実際の関数で使う例を学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- 関数外の値の変更
- 配列の操作
- スライスを返す関数
- 実用的なパターン

**コード例:**
```zig
// 関数外の値を変更
fn increment(ptr: *i32) void {
    ptr.* += 1;
}

// 配列を操作
fn fillArray(array: []i32, value: i32) void {
    for (array) |*item| {
        item.* = value;
    }
}

// スライスを返す
fn getSubslice(data: []const u8, start: usize, end: usize) []const u8 {
    return data[start..end];
}

pub fn main() void {
    var x: i32 = 10;
    increment(&x);
    std.debug.print("x = {}\n", .{x});  // 11

    var array = [_]i32{0} ** 5;
    fillArray(&array, 42);
    std.debug.print("array = {any}\n", .{array});  // [42, 42, 42, 42, 42]

    const data = "Hello, Zig!";
    const sub = getSubslice(data, 0, 5);
    std.debug.print("sub = {s}\n", .{sub});  // "Hello"
}
```

## ポインタの種類まとめ

| 型 | 説明 | 長さ情報 | 境界チェック |
|---|------|----------|-------------|
| `*T` | シングルアイテムポインタ | なし | なし |
| `*const T` | 読み取り専用シングルポインタ | なし | なし |
| `[*]T` | マルチアイテムポインタ | なし | なし |
| `[]T` | スライス | あり | あり |
| `[]const T` | 読み取り専用スライス | あり | あり |

## Rustとの比較

### ポインタの参照外し

**Rust:**
```rust
// Rust: 借用（自動参照外し）
fn increment(x: &mut i32) {
    *x += 1;
}

let mut x = 10;
increment(&mut x);
```

**Zig:**
```zig
// Zig: ポインタ（明示的参照外し）
fn increment(ptr: *i32) void {
    ptr.* += 1;
}

var x: i32 = 10;
increment(&x);
```

**主な違い:**
- Rust: 借用システムによる安全性保証
- Zig: より低レベルで明示的
- Rust: `*x` で参照外し
- Zig: `ptr.*` で参照外し

### スライス

**Rust:**
```rust
// Rust: スライス
let array = [1, 2, 3, 4, 5];
let slice: &[i32] = &array[1..4];
println!("{:?}", slice);
```

**Zig:**
```zig
// Zig: スライス
const array = [_]i32{ 1, 2, 3, 4, 5 };
const slice: []const i32 = array[1..4];
std.debug.print("{any}\n", .{slice});
```

**主な違い:**
- 両方ともポインタ + 長さで構成
- Rust: 借用チェッカーによる安全性
- Zig: 手動管理だが境界チェックあり
- 構文はほぼ同じ

### ポインタの安全性

**Rust:**
```rust
// Rustの借用規則
let mut x = 10;
let r1 = &x;       // OK
let r2 = &x;       // OK（複数の不変参照）
// let r3 = &mut x; // ❌ エラー（不変参照がある時に可変参照は不可）
```

**Zig:**
```zig
// Zigは借用チェックなし
var x: i32 = 10;
const r1: *const i32 = &x;  // OK
const r2: *const i32 = &x;  // OK
const r3: *i32 = &x;        // OK（コンパイラは警告しない）
// プログラマが安全性を保証する必要がある
```

**主な違い:**
- Rust: コンパイル時に借用規則を強制
- Zig: プログラマの責任（より低レベル）
- Zig: 柔軟だが注意が必要

## 学習ポイント

- `*T`: シングルアイテムポインタ
- `[*]T`: マルチアイテムポインタ（長さなし）
- `[]T`: スライス（ポインタ + 長さ）
- ポインタは明示的な参照外し（`.*`）が必要
- スライスは境界チェックがある
- Rustの借用より低レベルで柔軟
- `for (array) |*item|` で要素のポインタを取得

## よくあるコンパイルエラー

### エラー1: expected type '*i32', found 'i32'

```
error: expected type '*i32', found 'i32'
```

**原因:** ポインタが必要な場所に値を渡している

**対処:** `&` を使ってポインタを作成する

```zig
var x: i32 = 42;
increment(&x);  // ✅ 正しい
// increment(x);   // ❌ エラー
```

### エラー2: cannot assign to constant

```
error: cannot assign to constant
```

**原因:** `*const T` ポインタで値を変更しようとしている

**対処:** 変更可能な `*T` ポインタを使用する

```zig
var x: i32 = 42;
const ptr: *i32 = &x;        // ✅ 変更可能
ptr.* = 100;

const const_ptr: *const i32 = &x;  // 読み取り専用
// const_ptr.* = 100;  // ❌ エラー
```

### エラー3: index out of bounds

**原因:** スライスの範囲外にアクセスしている

**対処:** インデックスがスライスの長さ内であることを確認する

```zig
const array = [_]i32{ 1, 2, 3 };
const slice: []const i32 = &array;
std.debug.print("{}\n", .{slice[0]});  // ✅ OK
// std.debug.print("{}\n", .{slice[5]});  // ❌ 実行時エラー
```

### エラー4: expected type '[]const u8', found '*const [5:0]u8'

**原因:** 配列ポインタとスライスの型が一致していない

**対処:** `&` を使って配列をスライスに変換する

```zig
const array = [_]u8{ 1, 2, 3, 4, 5 };
const slice: []const u8 = &array;  // ✅ 正しい
```

# 07. Optional型

このチュートリアルでは、ZigのOptional型（`?T`）について学びます。

## サンプルファイル

### 1. src/basic_optional.zig - Optional型の基本

Optional型の基本的な使い方と、`orelse`、`if`によるパターンマッチングを学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- Optional型（`?T`）の定義
- `null` の扱い
- `orelse` によるデフォルト値の指定
- `if` によるパターンマッチング
- `null` チェック

**コード例:**
```zig
// Optional型（Rustの Option<T> 相当）
fn find(items: []const i32, target: i32) ?usize {
    for (items, 0..) |item, i| {
        if (item == target) return i;
    }
    return null;
}

pub fn main() void {
    const numbers = [_]i32{ 10, 20, 30, 40, 50 };

    // orelse でデフォルト値
    const index1 = find(&numbers, 30) orelse 999;
    std.debug.print("Index: {}\n", .{index1});  // 2

    const index2 = find(&numbers, 99) orelse 999;
    std.debug.print("Index: {}\n", .{index2});  // 999

    // if でパターンマッチ
    if (find(&numbers, 20)) |idx| {
        std.debug.print("Found at index {}\n", .{idx});
    } else {
        std.debug.print("Not found\n", .{});
    }
}
```

### 2. src/unwrap_example.zig - .? による強制アンラップ

`.?` による強制アンラップの使い方と、その危険性について学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- `.?` による強制アンラップ
- アンラップの危険性（nullの場合はpanic）
- 安全な代替手段（`orelse`、`if`）
- 式でのアンラップ

**コード例:**
```zig
pub fn main() void {
    const maybe_value: ?i32 = 42;

    // .? で強制アンラップ（nullならpanicのような挙動）
    const value = maybe_value.?;
    std.debug.print("Value: {}\n", .{value});

    // nullの場合は実行時エラー
    // const none: ?i32 = null;
    // const bad = none.?;  // ❌ panic
}
```

**重要な注意点:**
- `.?` は値が確実に存在する場合のみ使用する
- 可能な限り `orelse` や `if` を使う
- nullの場合は実行時にpanicする

### 3. src/struct_optional.zig - 構造体でのOptional型

構造体のフィールドとしてのOptional型の使い方を学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- 構造体フィールドとしてのOptional型
- Optionalフィールドの初期化
- Optional型を返す関数
- 実践的なユースケース

**コード例:**
```zig
const User = struct {
    name: []const u8,
    email: ?[]const u8,  // emailはオプショナル
};

fn getUserEmail(user: User) []const u8 {
    return user.email orelse "no-email@example.com";
}

pub fn main() void {
    const user1 = User{
        .name = "Alice",
        .email = "alice@example.com",
    };

    const user2 = User{
        .name = "Bob",
        .email = null,
    };

    std.debug.print("{s}: {s}\n", .{user1.name, getUserEmail(user1)});
    std.debug.print("{s}: {s}\n", .{user2.name, getUserEmail(user2)});
}
```

## Rustとの比較

### Option vs Optional

**Rust:**
```rust
fn find(items: &[i32], target: i32) -> Option<usize> {
    items.iter().position(|&x| x == target)
}

// unwrap_or でデフォルト値
let index = find(&numbers, 30).unwrap_or(999);

// if let でパターンマッチ
if let Some(idx) = find(&numbers, 20) {
    println!("Found at {}", idx);
}
```

**Zig:**
```zig
fn find(items: []const i32, target: i32) ?usize {
    for (items, 0..) |item, i| {
        if (item == target) return i;
    }
    return null;
}

// orelse でデフォルト値
const index = find(&numbers, 30) orelse 999;

// if でパターンマッチ
if (find(&numbers, 20)) |idx| {
    std.debug.print("Found at {}\n", .{idx});
}
```

**主な違い:**
- Rustの `Option<T>` は Zigでは `?T`
- Rustの `unwrap_or()` は Zigでは `orelse`
- Rustの `if let Some(x) = ...` は Zigでは `if (...) |x|`
- Rustの `unwrap()` は Zigでは `.?`
- どちらも同じ概念を扱うが、構文が異なる

## 学習ポイント

- `?T` は `T` または `null` を表す
- `orelse` でデフォルト値を指定
- `.?` で強制アンラップ（危険、避けるべき）
- `if` でパターンマッチング
- 構造体のフィールドにOptional型を使える
- Rustの `Option<T>` より簡潔な構文

## よくあるコンパイルエラー

### エラー1: expected type '[]const u8', found '?[]const u8'

```
error: expected type '[]const u8', found '?[]const u8'
```

**原因:** Optional型を直接使おうとしている

**対処:** `orelse` でデフォルト値を指定するか、`.?` でアンラップする

```zig
// エラー
const email: []const u8 = user.email;

// 正しい（orelse）
const email: []const u8 = user.email orelse "default@example.com";

// 正しい（値が確実にある場合のみ .?）
const email: []const u8 = user.email.?;

// 正しい（if）
if (user.email) |email| {
    std.debug.print("Email: {s}\n", .{email});
}
```

### エラー2: unable to unwrap null

```
error: unable to unwrap null
```

**原因:** `.?` で null をアンラップしようとした（実行時エラー）

**対処:** `orelse` や `if` を使う

```zig
// 実行時エラー
const value: ?i32 = null;
const unwrapped = value.?;  // panic!

// 正しい（orelse）
const unwrapped = value orelse 0;

// 正しい（if）
if (value) |v| {
    std.debug.print("Value: {}\n", .{v});
} else {
    std.debug.print("Value is null\n", .{});
}
```

### エラー3: expected type '?i32', found 'i32'

```
error: expected type '?i32', found 'i32'
```

**原因:** Optional型が期待されているのに、通常の値を渡している

**対処:** 値をOptional型に変換する

```zig
fn takesOptional(value: ?i32) void {
    // ...
}

// エラー
takesOptional(42);

// 正しい（明示的にOptionalに変換）
const opt_value: ?i32 = 42;
takesOptional(opt_value);

// または直接代入
takesOptional(@as(?i32, 42));
```

## ベストプラクティス

1. **可能な限り `orelse` を使う**: `.?` よりも安全
2. **`if` でパターンマッチング**: 値の存在チェックと取り出しを同時に行う
3. **`.?` は避ける**: 値が確実にある場合のみ使用
4. **構造体のOptionalフィールド**: デフォルト値が必要な場合に便利
5. **関数の戻り値**: 値が存在しない可能性がある場合は `?T` を返す

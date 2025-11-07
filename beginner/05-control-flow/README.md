# 05. 制御構文

このチュートリアルでは、Zigにおける制御構文（if、while、for、switch）について学びます。

## サンプルファイル

### 1. src/if_example.zig - if文（式として扱える）

if文の基本的な使い方と、式としての使用方法を学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- 基本的なif文
- if式（Rustと同じように値を返す）
- else if チェーン
- 式としてのif（三項演算子の代わり）

**コード例:**
```zig
const x = 10;

// if 文
if (x > 5) {
    std.debug.print("x is greater than 5\n", .{});
} else {
    std.debug.print("x is not greater than 5\n", .{});
}

// if 式（Rustと同じ）
const result = if (x > 5) "big" else "small";
std.debug.print("x is {s}\n", .{result});

// else if
if (x < 0) {
    std.debug.print("negative\n", .{});
} else if (x == 0) {
    std.debug.print("zero\n", .{});
} else {
    std.debug.print("positive\n", .{});
}
```

### 2. src/while_example.zig - whileループ

whileループの基本的な使い方とcontinue式について学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- 基本的なwhileループ
- continue式付きwhile（後置インクリメント）
- ループカウンタの管理

**コード例:**
```zig
var i: i32 = 0;

while (i < 5) {
    std.debug.print("{}\n", .{i});
    i += 1;
}

// continue式付き
i = 0;
while (i < 5) : (i += 1) {
    std.debug.print("{}\n", .{i});
}
```

### 3. src/for_example.zig - forループ

配列やスライス、範囲のイテレーション方法を学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- 配列要素のイテレート
- インデックス付きイテレート
- 範囲（range）のイテレート
- forループの構文

**コード例:**
```zig
const items = [_]i32{ 1, 2, 3, 4, 5 };

// 要素のイテレート
for (items) |item| {
    std.debug.print("{}\n", .{item});
}

// インデックス付き
for (items, 0..) |item, i| {
    std.debug.print("[{}] = {}\n", .{i, item});
}

// 範囲（0..5 で 0 から 4 まで）
for (0..5) |i| {
    std.debug.print("{}\n", .{i});
}
```

### 4. src/switch_example.zig - switch（Rustのmatch相当）

パターンマッチングと網羅性チェックについて学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- switch式の基本
- 複数の値のマッチング
- 範囲マッチング
- 網羅性チェック

**コード例:**
```zig
const value = 2;

// switch 式
const result = switch (value) {
    1 => "one",
    2 => "two",
    3 => "three",
    else => "other",
};

std.debug.print("value is {s}\n", .{result});

// 複数の値
const category = switch (value) {
    1, 2, 3 => "small",
    4, 5, 6 => "medium",
    else => "large",
};

// 範囲
const range_result = switch (value) {
    0...9 => "single digit",
    10...99 => "double digit",
    else => "large",
};
```

## Rustとの比較

### switch vs match

**Rust:**
```rust
// Rust: match
let result = match value {
    1 => "one",
    2 => "two",
    _ => "other",
};
```

**Zig:**
```zig
// Zig: switch
const result = switch (value) {
    1 => "one",
    2 => "two",
    else => "other",
};
```

**主な違い:**
- Rustの `_` は Zigでは `else`
- 両方とも網羅性チェックがある
- 両方とも式として使える

## 学習ポイント

- `if` と `switch` は式として使える
- `for` はイテレータではなく配列/スライス専用
- `switch` は網羅性チェックあり（Rustと同じ）
- `else` で残りのパターンをキャッチ
- whileの `:()` 構文でcontinue式を記述できる

## よくあるコンパイルエラー

### エラー1: switch must handle all possibilities

```
error: switch must handle all possibilities
```

**原因:** `switch` で全パターンを網羅していない

**対処:** `else` 節を追加してすべてのケースを処理する

### エラー2: unreachable else prong

```
error: unreachable else prong; all cases already handled
```

**原因:** すべてのケースを列挙した後に `else` を追加している

**対処:** `else` 節を削除する

### エラー3: expected type 'i32', found 'comptime_int'

**原因:** 範囲指定で型が推論できない

**対処:** 明示的に型を指定する

# 8. 動的データ構造（ArrayList）

このチュートリアルでは、Zigの動的データ構造について学びます。

## 学習内容

1. **ArrayList** - 動的配列（Rustの`Vec`相当）
2. **HashMap** - ハッシュマップ（Rustの`HashMap`相当）
3. **アロケータの実践** - メモリ管理のパターン
4. **カスタムデータ構造** - ArrayListを使った独自の構造

## ビルドと実行

```bash
zig build run
```

## 1. ArrayList

### 基本的な使い方

```zig
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
defer _ = gpa.deinit();
const allocator = gpa.allocator();

var list = std.ArrayList(i32).init(allocator);
defer list.deinit();

// 要素の追加
try list.append(10);
try list.append(20);
try list.append(30);

// 要素へのアクセス
std.debug.print("Length: {}\n", .{list.items.len});
for (list.items, 0..) |item, i| {
    std.debug.print("[{}] = {}\n", .{i, item});
}
```

### 主な操作

| 操作 | メソッド | 説明 |
|------|----------|------|
| 追加 | `append(item)` | 末尾に要素を追加 |
| 複数追加 | `appendSlice(slice)` | 複数の要素を追加 |
| 削除 | `pop()` | 末尾から削除 |
| 挿入 | `insert(index, item)` | 指定位置に挿入 |
| 削除 | `orderedRemove(index)` | 指定位置から削除（順序維持） |
| クリア | `clearRetainingCapacity()` | 全削除（容量維持） |
| 容量確保 | `ensureTotalCapacity(n)` | 指定容量を確保 |

### アクセス

```zig
// items フィールドでスライスとしてアクセス
for (list.items) |item| {
    std.debug.print("{}\n", .{item});
}

// インデックスアクセス
const first = list.items[0];
```

## 2. HashMap

### StringHashMapの使用

```zig
var map = std.StringHashMap(i32).init(allocator);
defer map.deinit();

// 要素の追加
try map.put("alice", 30);
try map.put("bob", 25);
try map.put("charlie", 35);

// 要素の取得
if (map.get("alice")) |age| {
    std.debug.print("Alice is {} years old\n", .{age});
}

// 要素の存在確認
if (map.contains("bob")) {
    std.debug.print("Bob exists\n", .{});
}
```

### イテレート

```zig
var iter = map.iterator();
while (iter.next()) |entry| {
    std.debug.print("{s}: {}\n", .{entry.key_ptr.*, entry.value_ptr.*});
}
```

### AutoHashMapの使用

```zig
// 任意の型をキーとして使用
var int_map = std.AutoHashMap(i32, []const u8).init(allocator);
defer int_map.deinit();

try int_map.put(1, "one");
try int_map.put(2, "two");
```

### カスタムキー

```zig
const Point = struct {
    x: i32,
    y: i32,
};

var point_map = std.HashMap(Point, []const u8, struct {
    pub fn hash(_: @This(), key: Point) u64 {
        // カスタムハッシュ関数
    }
    pub fn eql(_: @This(), a: Point, b: Point) bool {
        return a.x == b.x and a.y == b.y;
    }
}, std.hash_map.default_max_load_percentage).init(allocator);
```

## 3. アロケータの実践

### 関数にアロケータを渡す

```zig
fn processData(allocator: std.mem.Allocator) !void {
    var list = std.ArrayList([]const u8).init(allocator);
    defer list.deinit();

    try list.append("hello");
    try list.append("world");
    try list.append("zig");

    for (list.items) |item| {
        std.debug.print("{s}\n", .{item});
    }
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    try processData(allocator);
}
```

### ArenaAllocatorで一括管理

```zig
pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();  // 全てまとめて解放

    const allocator = arena.allocator();

    // 個々の deinit() が不要
    var list1 = std.ArrayList(i32).init(allocator);
    var list2 = std.ArrayList([]const u8).init(allocator);
    var map = std.StringHashMap(i32).init(allocator);

    // arena.deinit() で全て解放される
}
```

### FixedBufferAllocator

```zig
var buffer: [1024]u8 = undefined;
var fba = std.heap.FixedBufferAllocator.init(&buffer);
const allocator = fba.allocator();

var list = std.ArrayList(i32).init(allocator);
defer list.deinit();

try list.append(1);
try list.append(2);
```

## 4. カスタムデータ構造

### Queue（キュー）

```zig
const Queue = struct {
    items: std.ArrayList(i32),

    pub fn init(allocator: std.mem.Allocator) Queue {
        return Queue{
            .items = std.ArrayList(i32).init(allocator),
        };
    }

    pub fn deinit(self: *Queue) void {
        self.items.deinit();
    }

    pub fn enqueue(self: *Queue, value: i32) !void {
        try self.items.append(value);
    }

    pub fn dequeue(self: *Queue) ?i32 {
        if (self.items.items.len == 0) return null;
        return self.items.orderedRemove(0);
    }

    pub fn isEmpty(self: Queue) bool {
        return self.items.items.len == 0;
    }
};
```

### Stack（スタック）

```zig
const Stack = struct {
    items: std.ArrayList(i32),

    pub fn push(self: *Stack, value: i32) !void {
        try self.items.append(value);
    }

    pub fn pop(self: *Stack) ?i32 {
        if (self.items.items.len == 0) return null;
        return self.items.pop();
    }
};
```

## Rustとの比較

### 動的配列

**Zig:**

```zig
var list = std.ArrayList(i32).init(allocator);
defer list.deinit();

try list.append(10);
std.debug.print("Length: {}\n", .{list.items.len});
```

**Rust:**

```rust
let mut vec = Vec::new();
vec.push(10);
println!("Length: {}", vec.len());
```

### ハッシュマップ

**Zig:**

```zig
var map = std.StringHashMap(i32).init(allocator);
defer map.deinit();

try map.put("alice", 30);
if (map.get("alice")) |age| {
    std.debug.print("Age: {}\n", .{age});
}
```

**Rust:**

```rust
use std::collections::HashMap;

let mut map = HashMap::new();
map.insert("alice", 30);
if let Some(&age) = map.get("alice") {
    println!("Age: {}", age);
}
```

### メモリ管理

**Zig:**

```zig
// 明示的なアロケータ
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
defer _ = gpa.deinit();
const allocator = gpa.allocator();

var list = std.ArrayList(i32).init(allocator);
defer list.deinit();
```

**Rust:**

```rust
// 所有権で自動管理
let mut vec = Vec::new();
// Drop trait で自動的に解放される
```

## 重要な違い

### アロケータ

| 特徴 | Zig | Rust |
|------|-----|------|
| **メモリ管理** | 明示的なアロケータ | 所有権システム |
| **初期化** | `init(allocator)` | `new()` |
| **解放** | `defer deinit()` | Drop trait（自動） |
| **柔軟性** | アロケータを選択可能 | 組み込み |

### データ構造の初期化

**Zig:**
- アロケータを明示的に渡す
- `init(allocator)` で初期化
- `defer deinit()` で解放

**Rust:**
- デフォルトのアロケータを使用
- `new()` や `Vec::new()` で初期化
- スコープを抜けると自動解放

### エラー処理

**Zig:**
- `try` でエラーを伝播
- メモリ不足などは明示的にエラー

**Rust:**
- `Result` 型でエラー処理
- `unwrap()` や `?` でエラー伝播

## 学習ポイント

- `ArrayList` は動的配列（Rustの`Vec`相当）
- `StringHashMap` / `AutoHashMap` でハッシュマップ
- 全ての動的データ構造にアロケータが必要
- `defer deinit()` で確実にメモリを解放
- `ArenaAllocator` で一括管理すると便利
- カスタムデータ構造は `ArrayList` を使って構築
- Rustは所有権で自動管理、Zigは明示的管理
- Zigのアロケータは柔軟で選択可能
- `items` フィールドでスライスとしてアクセス
- Rustの `Vec` や `HashMap` と同等の機能

## ファイル構成

```
src/
├── arraylist_basics.zig    # ArrayListの基本操作
├── hashmap_basics.zig      # HashMapの基本操作
├── allocator_practice.zig  # アロケータの実践パターン
├── custom_structures.zig   # カスタムデータ構造（Queue、Stack等）
└── main.zig                # メインプログラム
```

## 次のステップ

- より複雑なデータ構造を実装する
- 異なるアロケータのパフォーマンスを比較する
- エラーハンドリングとメモリ管理を組み合わせる
- ジェネリックなデータ構造を作成する

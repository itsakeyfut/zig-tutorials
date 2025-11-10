# 04. ユニオンとタグ付きユニオン

このチュートリアルでは、Zigにおけるユニオンとタグ付きユニオンの使い方について学びます。

## サンプルファイル

### 1. src/basic_union.zig - 基本的なユニオン

タグなしユニオンの使い方を学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- ユニオンの基本
- フィールドの手動管理
- 未定義動作の危険性
- メモリサイズ

**コード例:**
```zig
// 通常のユニオン（タグなし）
const Value = union {
    int: i32,
    float: f64,
    boolean: bool,
};

pub fn main() void {
    var value = Value{ .int = 42 };

    // どのフィールドがアクティブかはプログラマが管理
    std.debug.print("int: {}\n", .{value.int});

    // 別のフィールドに変更
    value = Value{ .float = 3.14 };
    std.debug.print("float: {}\n", .{value.float});

    // 間違ったフィールドにアクセスすると未定義動作
    // std.debug.print("int: {}\n", .{value.int});  // ❌ UB
}
```

### 2. src/tagged_union.zig - タグ付きユニオン

タグ付きユニオン（Rustのenum相当）の使い方を学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- タグ付きユニオンの基本
- `union(enum)` 構文
- switch でのパターンマッチング
- タグの取得

**コード例:**
```zig
// タグ付きユニオン
const Result = union(enum) {
    ok: i32,
    err: []const u8,

    pub fn isOk(self: Result) bool {
        return switch (self) {
            .ok => true,
            .err => false,
        };
    }
};

pub fn main() void {
    const success = Result{ .ok = 42 };
    const failure = Result{ .err = "Something went wrong" };

    // switch でパターンマッチング
    switch (success) {
        .ok => |value| std.debug.print("Success: {}\n", .{value}),
        .err => |msg| std.debug.print("Error: {s}\n", .{msg}),
    }

    std.debug.print("success.isOk() = {}\n", .{success.isOk()});
}
```

### 3. src/complex_union.zig - 複雑なタグ付きユニオン

より複雑なタグ付きユニオンの使い方を学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- データを持たないバリアント
- 構造体を含むバリアント
- メソッドの定義
- 実践的なパターン

**コード例:**
```zig
const Message = union(enum) {
    quit,
    move: struct { x: i32, y: i32 },
    write: []const u8,
    change_color: struct { r: u8, g: u8, b: u8 },

    pub fn handle(self: Message) void {
        switch (self) {
            .quit => std.debug.print("Quitting\n", .{}),
            .move => |pos| std.debug.print("Moving to ({}, {})\n", .{pos.x, pos.y}),
            .write => |text| std.debug.print("Writing: {s}\n", .{text}),
            .change_color => |color| std.debug.print("Color: RGB({}, {}, {})\n", .{color.r, color.g, color.b}),
        }
    }
};

pub fn main() void {
    const messages = [_]Message{
        Message.quit,
        Message{ .move = .{ .x = 10, .y = 20 } },
        Message{ .write = "Hello" },
        Message{ .change_color = .{ .r = 255, .g = 0, .b = 0 } },
    };

    for (messages) |msg| {
        msg.handle();
    }
}
```

## ユニオンの種類

| 種類 | 構文 | タグ管理 | 安全性 | 用途 |
|-----|------|---------|--------|------|
| 通常のユニオン | `union { ... }` | 手動 | 低い | 低レベル操作 |
| タグ付きユニオン | `union(enum) { ... }` | 自動 | 高い | 一般的な用途 |

## Rustとの比較

### enum の定義

**Rust:**
```rust
enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
    ChangeColor(u8, u8, u8),
}

impl Message {
    fn handle(&self) {
        match self {
            Message::Quit => println!("Quitting"),
            Message::Move { x, y } => println!("Moving to ({}, {})", x, y),
            Message::Write(text) => println!("Writing: {}", text),
            Message::ChangeColor(r, g, b) => println!("Color: RGB({}, {}, {})", r, g, b),
        }
    }
}
```

**Zig:**
```zig
const Message = union(enum) {
    quit,
    move: struct { x: i32, y: i32 },
    write: []const u8,
    change_color: struct { r: u8, g: u8, b: u8 },

    pub fn handle(self: Message) void {
        switch (self) {
            .quit => std.debug.print("Quitting\n", .{}),
            .move => |pos| std.debug.print("Moving to ({}, {})\n", .{pos.x, pos.y}),
            .write => |text| std.debug.print("Writing: {s}\n", .{text}),
            .change_color => |color| std.debug.print("Color: RGB({}, {}, {})\n", .{color.r, color.g, color.b}),
        }
    }
};
```

**主な違い:**
- Rust: `enum` キーワード
- Zig: `union(enum)` キーワード
- Rust: `match` でパターンマッチング
- Zig: `switch` でパターンマッチング
- Rust: タプルバリアント `Write(String)`
- Zig: 名前付きフィールド `write: []const u8`

### パターンマッチング

**Rust:**
```rust
match result {
    Ok(value) => println!("Success: {}", value),
    Err(msg) => println!("Error: {}", msg),
}
```

**Zig:**
```zig
switch (result) {
    .ok => |value| std.debug.print("Success: {}\n", .{value}),
    .err => |msg| std.debug.print("Error: {s}\n", .{msg}),
}
```

**主な違い:**
- Rust: `match` 式
- Zig: `switch` 式
- Rust: `=>` で値を束縛
- Zig: `|variable|` で値を取り出す
- 両方とも網羅性チェックあり

### Option/Result 型

**Rust:**
```rust
// Option<T>
enum Option<T> {
    Some(T),
    None,
}

// Result<T, E>
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

**Zig:**
```zig
// Option<T> に相当
fn Optional(comptime T: type) type {
    return union(enum) {
        some: T,
        none,
    };
}

// Result<T, E> に相当
fn Result(comptime T: type, comptime E: type) type {
    return union(enum) {
        ok: T,
        err: E,
    };
}
```

**主な違い:**
- Rust: 標準ライブラリで提供
- Zig: 自分で定義するか、エラーユニオン (`!T`) を使う
- Zig: エラー処理は専用の構文がある

## 学習ポイント

- `union` は複数の型のいずれかを保持
- タグなしユニオンはどのフィールドがアクティブかを手動管理
- `union(enum)` でタグ付きユニオンを作成
- `switch` でパターンマッチング（網羅性チェックあり）
- `|variable|` で値を取り出す
- Rustの `enum` とほぼ同等の機能
- メソッドを定義して共通の振る舞いを実装可能
- データを持たないバリアントも定義可能

## よくあるコンパイルエラー

### エラー1: accessing inactive union field

```
error: accessing inactive union field
```

**原因:** タグなしユニオンで間違ったフィールドにアクセスしている

**対処:** タグ付きユニオン `union(enum)` を使用するか、正しいフィールドにアクセスする

```zig
// ❌ タグなしユニオン（危険）
const Value = union {
    int: i32,
    float: f64,
};

// ✅ タグ付きユニオン（安全）
const Value = union(enum) {
    int: i32,
    float: f64,
};
```

### エラー2: switch must handle all cases

```
error: switch must handle all possible values
```

**原因:** switch でユニオンの全てのバリアントを処理していない

**対処:** 全てのバリアントを処理するか、`else` 節を追加する

```zig
switch (message) {
    .quit => {},
    .move => |pos| {},
    .write => |text| {},
    .change_color => |color| {},  // 全てのバリアントを処理
}

// または else を使用
switch (message) {
    .quit => {},
    else => {},
}
```

### エラー3: expected type 'union(enum)', found 'union'

```
error: expected type 'union(enum)', found 'union'
```

**原因:** タグ付きユニオンが必要な場所でタグなしユニオンを使用している

**対処:** `union(enum)` を使用する

```zig
// ❌ タグなし
const Value = union {
    int: i32,
    float: f64,
};

// ✅ タグ付き
const Value = union(enum) {
    int: i32,
    float: f64,
};
```

### エラー4: cannot capture payload of '...' which does not have a payload

```
error: cannot capture payload of 'quit' which does not have a payload
```

**原因:** データを持たないバリアントで値を取り出そうとしている

**対処:** データを持たないバリアントでは値の取り出しを行わない

```zig
switch (message) {
    .quit => {},  // ✅ データなし
    // .quit => |data| {},  // ❌ エラー
    .move => |pos| {},  // ✅ データあり
}
```

# 5. enum（列挙型）

このチュートリアルでは、Zigの`enum`（列挙型）について学びます。

## 学習内容

1. **enumの基本** - 名前付き定数の集合とメソッド定義
2. **整数値の割り当て** - enumに整数値を割り当てる方法
3. **switchでの使用** - enumの網羅的なパターンマッチング

## ビルドと実行

```bash
zig build run
```

## 1. enumの基本

### 基本的な定義

```zig
const Direction = enum {
    north,
    south,
    east,
    west,
};
```

### メソッドの定義

```zig
const Direction = enum {
    north,
    south,
    east,
    west,

    pub fn opposite(self: Direction) Direction {
        return switch (self) {
            .north => .south,
            .south => .north,
            .east => .west,
            .west => .east,
        };
    }
};
```

### 使用例

```zig
const dir = Direction.north;
std.debug.print("Direction: {}\n", .{dir});          // north
std.debug.print("Opposite: {}\n", .{dir.opposite()}); // south
```

## 2. 整数値の割り当て

### 型指定と値の割り当て

```zig
const StatusCode = enum(u16) {
    ok = 200,
    created = 201,
    bad_request = 400,
    not_found = 404,
    internal_error = 500,
};
```

### 変換関数

#### enum → 整数

```zig
const code = StatusCode.ok;
const value: u16 = @intFromEnum(code);  // 200
```

#### 整数 → enum

```zig
const from_int = @as(StatusCode, @enumFromInt(404));  // not_found
```

### 実用例

```zig
pub fn isSuccess(self: StatusCode) bool {
    const value = @intFromEnum(self);
    return value >= 200 and value < 300;
}

pub fn isClientError(self: StatusCode) bool {
    const value = @intFromEnum(self);
    return value >= 400 and value < 500;
}
```

## 3. switchでの使用

### 基本的なswitch

```zig
const Color = enum {
    red,
    green,
    blue,
    yellow,
};

pub fn toRGB(self: Color) struct { r: u8, g: u8, b: u8 } {
    return switch (self) {
        .red => .{ .r = 255, .g = 0, .b = 0 },
        .green => .{ .r = 0, .g = 255, .b = 0 },
        .blue => .{ .r = 0, .g = 0, .b = 255 },
        .yellow => .{ .r = 255, .g = 255, .b = 0 },
    };
}
```

### ネストしたswitch

```zig
pub fn mixWith(self: Color, other: Color) ?Color {
    return switch (self) {
        .red => switch (other) {
            .red => .red,
            .green => .yellow,
            .blue => null,
            .yellow => .yellow,
        },
        .green => switch (other) {
            .red => .yellow,
            .green => .green,
            .blue => null,
            .yellow => .yellow,
        },
        // ...
    };
}
```

### switch式として使用

```zig
const current_season = Season.summer;
const activity = switch (current_season) {
    .spring => "花見",
    .summer => "海水浴",
    .autumn => "紅葉狩り",
    .winter => "スキー",
};
```

## Rustとの比較

### Zigのenum

```zig
const Direction = enum {
    north,
    south,
    east,
    west,

    pub fn opposite(self: Direction) Direction {
        return switch (self) {
            .north => .south,
            .south => .north,
            .east => .west,
            .west => .east,
        };
    }
};
```

### Rustの対応コード

```rust
enum Direction {
    North,
    South,
    East,
    West,
}

impl Direction {
    fn opposite(&self) -> Direction {
        match self {
            Direction::North => Direction::South,
            Direction::South => Direction::North,
            Direction::East => Direction::West,
            Direction::West => Direction::East,
        }
    }
}
```

### 整数値を持つenum

**Zig:**

```zig
const StatusCode = enum(u16) {
    ok = 200,
    created = 201,
    bad_request = 400,
    not_found = 404,
    internal_error = 500,
};

// enum → 整数
const value: u16 = @intFromEnum(StatusCode.ok);

// 整数 → enum
const code = @as(StatusCode, @enumFromInt(404));
```

**Rust:**

```rust
#[repr(u16)]
enum StatusCode {
    Ok = 200,
    Created = 201,
    BadRequest = 400,
    NotFound = 404,
    InternalError = 500,
}

// enum → 整数
let value = StatusCode::Ok as u16;

// 整数 → enum (unsafeまたはライブラリを使用)
let code = StatusCode::try_from(404).unwrap();
```

## 重要な違い

### データを持つenum

| 特徴 | Zig | Rust |
|------|-----|------|
| **シンプルなenum** | `enum { a, b, c }` | `enum { A, B, C }` |
| **データ付きenum** | `union(enum)` を使用 | `enum { A(i32), B(String) }` |
| **整数値の割り当て** | `enum(u16) { a = 1 }` | `#[repr(u16)] enum { A = 1 }` |
| **メソッド定義** | `pub fn method(self: T)` | `impl T { fn method(&self) }` |

### switchの網羅性チェック

**Zig:**

```zig
// コンパイル時に全ケースの網羅が必須
const result = switch (direction) {
    .north => "北",
    .south => "南",
    .east => "東",
    .west => "西",
    // すべてのケースを網羅しないとコンパイルエラー
};
```

**Rust:**

```rust
// matchで全ケースの網羅が必須
let result = match direction {
    Direction::North => "北",
    Direction::South => "南",
    Direction::East => "東",
    Direction::West => "西",
    // すべてのケースを網羅しないとコンパイルエラー
};
```

## 学習ポイント

- `enum`は名前付き定数の集合
- `enum(T)`で整数型を指定できる
- `@intFromEnum`でenumから整数値を取得
- `@enumFromInt`で整数からenumを作成
- `switch`で網羅性がコンパイル時にチェックされる
- メソッドを定義可能
- Zigの`enum`はシンプル（データを持つ場合は`union(enum)`を使用）
- Rustの`enum`はより強力（データとバリアントを持てる）

## ファイル構成

```
src/
├── enum_basics.zig    # enumの基本的な使い方
├── enum_integer.zig   # 整数値の割り当てと変換
├── enum_switch.zig    # switchでの使用パターン
└── main.zig           # メインプログラム
```

## 次のステップ

- `union(enum)`を使ったタグ付きユニオン（tagged union）を学ぶ
- より複雑なパターンマッチングを実装する
- エラーセットとenumの組み合わせを理解する

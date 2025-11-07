# 09. 構造体

このチュートリアルでは、Zigの構造体（`struct`）について学びます。

## サンプルファイル

### 1. src/basic_struct.zig - 基本的な構造体

構造体の定義、初期化、メソッドの作成について学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- 構造体の定義
- init関数による初期化
- 直接初期化
- メソッド（構造体内の関数）
- `@This()` による型参照

**コード例:**
```zig
const std = @import("std");

const Point = struct {
    x: f32,
    y: f32,

    // メソッド（実は関数）
    pub fn init(x: f32, y: f32) Point {
        return Point{ .x = x, .y = y };
    }

    pub fn distance(self: Point) f32 {
        return @sqrt(self.x * self.x + self.y * self.y);
    }

    pub fn add(self: Point, other: Point) Point {
        return Point{
            .x = self.x + other.x,
            .y = self.y + other.y,
        };
    }
};

pub fn main() void {
    const p1 = Point.init(3.0, 4.0);
    const p2 = Point{ .x = 1.0, .y = 2.0 };

    std.debug.print("Distance: {}\n", .{p1.distance()});

    const p3 = p1.add(p2);
    std.debug.print("Sum: ({}, {})\n", .{p3.x, p3.y});
}
```

**重要な注意点:**
- メソッドは構造体内に定義された関数
- `self` は明示的なパラメータ（Rustの `&self` に相当）
- `@This()` で現在の構造体型を参照できる
- 構造体名の繰り返しを避けるために便利

### 2. src/default_values.zig - デフォルト値

構造体フィールドのデフォルト値の設定と使用方法を学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- フィールドのデフォルト値
- デフォルト値の部分的な上書き
- 空の初期化子（`{}`）
- 実践的なConfig構造体

**コード例:**
```zig
const Config = struct {
    host: []const u8 = "localhost",
    port: u16 = 8080,
    timeout: u32 = 30,
};

pub fn main() void {
    // デフォルト値を使う
    const config1 = Config{};

    // 一部だけ指定
    const config2 = Config{
        .port = 3000,
    };

    std.debug.print("{}:{}\n", .{config1.host, config1.port});
    std.debug.print("{}:{}\n", .{config2.host, config2.port});
}
```

**重要な注意点:**
- デフォルト値は構造体定義時に指定
- `Config{}` で全デフォルト値を使用
- 一部のフィールドのみ指定可能
- 未指定のフィールドはデフォルト値が使われる

### 3. src/nested_struct.zig - ネストした構造体

構造体の中に構造体を含める方法と、Optional型との組み合わせを学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- ネストした構造体の定義
- ネストしたフィールドへのアクセス
- 深くネストした構造体
- Optional型を含む構造体

**コード例:**
```zig
const Address = struct {
    street: []const u8,
    city: []const u8,
};

const Person = struct {
    name: []const u8,
    age: u32,
    address: Address,
};

pub fn main() void {
    const person = Person{
        .name = "Alice",
        .age = 30,
        .address = Address{
            .street = "123 Main St",
            .city = "Springfield",
        },
    };

    std.debug.print("{s} lives in {s}\n", .{person.name, person.address.city});
}
```

**重要な注意点:**
- 構造体は他の構造体を含むことができる
- `.` でネストしたフィールドにアクセス
- Optional型 (`?T`) と組み合わせ可能
- 深い階層も問題なく扱える

## Rustとの比較

### 構造体の定義とメソッド

**Rust:**
```rust
struct Point {
    x: f32,
    y: f32,
}

impl Point {
    fn new(x: f32, y: f32) -> Self {
        Point { x, y }
    }

    fn distance(&self) -> f32 {
        (self.x * self.x + self.y * self.y).sqrt()
    }

    fn add(&self, other: &Point) -> Point {
        Point {
            x: self.x + other.x,
            y: self.y + other.y,
        }
    }
}

fn main() {
    let p1 = Point::new(3.0, 4.0);
    let p2 = Point { x: 1.0, y: 2.0 };
    println!("{}", p1.distance());
}
```

**Zig:**
```zig
const Point = struct {
    x: f32,
    y: f32,

    pub fn init(x: f32, y: f32) Point {
        return Point{ .x = x, .y = y };
    }

    pub fn distance(self: Point) f32 {
        return @sqrt(self.x * self.x + self.y * self.y);
    }

    pub fn add(self: Point, other: Point) Point {
        return Point{
            .x = self.x + other.x,
            .y = self.y + other.y,
        };
    }
};

pub fn main() void {
    const p1 = Point.init(3.0, 4.0);
    const p2 = Point{ .x = 1.0, .y = 2.0 };
    std.debug.print("{}\n", .{p1.distance()});
}
```

### デフォルト値

**Rust:**
```rust
// Rustではtraitを実装する必要がある
#[derive(Default)]
struct Config {
    host: String,
    port: u16,
    timeout: u32,
}

impl Default for Config {
    fn default() -> Self {
        Config {
            host: "localhost".to_string(),
            port: 8080,
            timeout: 30,
        }
    }
}

fn main() {
    let config1 = Config::default();
    let config2 = Config {
        port: 3000,
        ..Config::default()
    };
}
```

**Zig:**
```zig
const Config = struct {
    host: []const u8 = "localhost",
    port: u16 = 8080,
    timeout: u32 = 30,
};

pub fn main() void {
    const config1 = Config{};
    const config2 = Config{
        .port = 3000,
    };
}
```

**主な違い:**
- Rustの `impl` ブロック vs Zigの構造体内関数定義
- Rustの `&self` vs Zigの明示的な `self: Point`
- Rustの `Self` vs Zigの `Point` または `@This()`
- Rustの `Default` trait vs Zigのデフォルト値構文
- Zigの方がデフォルト値の定義がシンプル
- Rustは所有権を意識する必要があるが、Zigは値渡しが基本

## 学習ポイント

- **構造体の定義**: `const Name = struct { ... };`
- **メソッド**: 構造体内に定義された関数（`pub fn`）
- **self パラメータ**: 明示的に型を指定（`self: Point`）
- **初期化**: `Point{ .x = 1.0, .y = 2.0 }`（フィールド名を明示）
- **init関数**: コンストラクタ相当（慣習的に `init` という名前）
- **@This()**: 現在の構造体型を返す組み込み関数
- **デフォルト値**: フィールド定義時に `=` で指定
- **ネスト**: 構造体は他の構造体を含むことができる
- **pub**: 外部から呼び出せるようにする修飾子

## よくあるコンパイルエラー

### エラー1: missing field in struct initialization

```
error: missing field 'x' in struct initialization
```

**原因:** 構造体の初期化時に必須フィールドが指定されていない

**対処:** すべての必須フィールドを指定するか、デフォルト値を設定する

```zig
const Point = struct {
    x: f32,
    y: f32,
};

// エラー
const p = Point{ .x = 1.0 };  // y が missing

// 正しい
const p = Point{ .x = 1.0, .y = 2.0 };

// またはデフォルト値を設定
const Point2 = struct {
    x: f32 = 0.0,
    y: f32 = 0.0,
};
const p2 = Point2{ .x = 1.0 };  // y は 0.0
```

### エラー2: expected type 'Point', found '*const Point'

```
error: expected type 'Point', found '*const Point'
```

**原因:** ポインタを渡しているが、値が期待されている

**対処:** デリファレンス (`.*`) を使うか、関数のシグネチャを変更する

```zig
fn distance(self: Point) f32 {
    return @sqrt(self.x * self.x + self.y * self.y);
}

const p = Point{ .x = 3.0, .y = 4.0 };

// エラー
const d = distance(&p);

// 正しい
const d = distance(p);

// またはポインタを受け取る関数にする
fn distancePtr(self: *const Point) f32 {
    return @sqrt(self.x * self.x + self.y * self.y);
}
const d2 = distancePtr(&p);
```

### エラー3: struct fields cannot have comptime-only types

```
error: struct fields cannot have comptime-only types
```

**原因:** コンパイル時にのみ存在する型をフィールドに使用している

**対処:** ランタイム型を使用する

```zig
// エラー
const BadStruct = struct {
    value: type,  // type はコンパイル時のみ
};

// 正しい（ジェネリックを使う場合）
fn MyStruct(comptime T: type) type {
    return struct {
        value: T,
    };
}

const IntStruct = MyStruct(i32);
const s = IntStruct{ .value = 42 };
```

### エラー4: use of undeclared identifier 'self'

```
error: use of undeclared identifier 'self'
```

**原因:** メソッド内で `self` を使用しているが、パラメータとして宣言していない

**対処:** `self` をパラメータとして明示的に宣言する

```zig
const Point = struct {
    x: f32,
    y: f32,

    // エラー
    pub fn distance() f32 {
        return @sqrt(self.x * self.x + self.y * self.y);
    }

    // 正しい
    pub fn distanceCorrect(self: Point) f32 {
        return @sqrt(self.x * self.x + self.y * self.y);
    }
};
```

### エラー5: cannot assign to constant

```
error: cannot assign to constant
```

**原因:** `const` で宣言された構造体のフィールドを変更しようとしている

**対処:** `var` で宣言するか、メソッドで新しい構造体を返す

```zig
const Point = struct {
    x: f32,
    y: f32,

    pub fn move(self: *Point, dx: f32, dy: f32) void {
        self.x += dx;
        self.y += dy;
    }
};

// エラー
const p1 = Point{ .x = 1.0, .y = 2.0 };
p1.x = 5.0;  // cannot assign to constant

// 正しい（可変）
var p2 = Point{ .x = 1.0, .y = 2.0 };
p2.x = 5.0;

// または不変で新しいインスタンスを返す
pub fn moved(self: Point, dx: f32, dy: f32) Point {
    return Point{ .x = self.x + dx, .y = self.y + dy };
}
const p3 = Point{ .x = 1.0, .y = 2.0 };
const p4 = p3.moved(1.0, 1.0);
```

## ベストプラクティス

1. **init関数を提供**: コンストラクタとして `init` 関数を定義する
2. **pub を明示**: 外部から使う関数には `pub` をつける
3. **@This() を活用**: 構造体名の繰り返しを避ける
4. **デフォルト値を設定**: オプショナルなフィールドにはデフォルト値を与える
5. **不変がデフォルト**: 変更する必要がある場合のみ `var` を使う
6. **self の型を明示**: `self: Point` または `self: *Point` を明確に
7. **値渡しとポインタ**: 小さい構造体は値渡し、大きい構造体はポインタ
8. **メソッドは構造体内**: 関連する関数は構造体内に定義する

## 実践的な例

### 構造体のコピー

```zig
const Point = struct {
    x: f32,
    y: f32,
};

const p1 = Point{ .x = 1.0, .y = 2.0 };
const p2 = p1;  // コピー（Zigは値渡し）

// p2 を変更しても p1 は変わらない
var p3 = p1;
p3.x = 10.0;
std.debug.print("p1.x = {}, p3.x = {}\n", .{p1.x, p3.x});
// 出力: p1.x = 1, p3.x = 10
```

### 可変メソッド（ポインタを使う）

```zig
const Counter = struct {
    count: u32,

    pub fn init() Counter {
        return Counter{ .count = 0 };
    }

    // ポインタを受け取って変更
    pub fn increment(self: *Counter) void {
        self.count += 1;
    }

    // 値を受け取って新しいインスタンスを返す
    pub fn incremented(self: Counter) Counter {
        return Counter{ .count = self.count + 1 };
    }
};

// 可変の場合
var counter1 = Counter.init();
counter1.increment();
std.debug.print("counter1: {}\n", .{counter1.count});  // 1

// 不変の場合
const counter2 = Counter.init();
const counter3 = counter2.incremented();
std.debug.print("counter2: {}, counter3: {}\n", .{counter2.count, counter3.count});  // 0, 1
```

### ジェネリック構造体

```zig
fn Pair(comptime T: type) type {
    return struct {
        first: T,
        second: T,

        pub fn init(first: T, second: T) @This() {
            return .{ .first = first, .second = second };
        }

        pub fn swap(self: @This()) @This() {
            return .{ .first = self.second, .second = self.first };
        }
    };
}

const IntPair = Pair(i32);
const p1 = IntPair.init(10, 20);
const p2 = p1.swap();
std.debug.print("({}, {})\n", .{p2.first, p2.second});  // (20, 10)

const StringPair = Pair([]const u8);
const s = StringPair.init("hello", "world");
```

### Builder パターン

```zig
const HttpClient = struct {
    host: []const u8,
    port: u16,
    timeout: u32,
    ssl: bool,

    pub fn init() HttpClient {
        return .{
            .host = "localhost",
            .port = 80,
            .timeout = 30,
            .ssl = false,
        };
    }

    pub fn withHost(self: HttpClient, host: []const u8) HttpClient {
        var result = self;
        result.host = host;
        return result;
    }

    pub fn withPort(self: HttpClient, port: u16) HttpClient {
        var result = self;
        result.port = port;
        return result;
    }

    pub fn withSsl(self: HttpClient, ssl: bool) HttpClient {
        var result = self;
        result.ssl = ssl;
        return result;
    }
};

const client = HttpClient.init()
    .withHost("example.com")
    .withPort(443)
    .withSsl(true);
```

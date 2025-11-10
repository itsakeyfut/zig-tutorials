# 9. パッケージとモジュール

このチュートリアルでは、Zigにおけるパッケージとモジュールの使い方を学びます。

## 学習内容

1. **@importの詳細** - モジュールのインポート方法
2. **pubによる公開制御** - 外部に公開する要素の制御
3. **パッケージ構成** - ディレクトリ階層によるモジュール管理
4. **build.zig.zon** - 依存関係の管理

## ビルドと実行

```bash
zig build run
```

## 1. @importの詳細

`@import`を使用して他のモジュールをインポートできます。

### src/math.zig

```zig
pub fn add(a: i32, b: i32) i32 {
    return a + b;
}

pub fn multiply(a: i32, b: i32) i32 {
    return a * b;
}

const PI = 3.14159;  // プライベート

pub const E = 2.71828;  // 公開
```

### src/main.zig（一部）

```zig
const std = @import("std");
const math = @import("math.zig");

pub fn main() void {
    const sum = math.add(10, 20);
    const product = math.multiply(5, 6);

    std.debug.print("Sum: {}\n", .{sum});
    std.debug.print("Product: {}\n", .{product});
    std.debug.print("E: {}\n", .{math.E});

    // math.PI は使えない（プライベート）
}
```

### インポートのルール

- `@import("ファイル名.zig")` で同じディレクトリのファイルをインポート
- `@import("ディレクトリ名/ファイル名.zig")` でサブディレクトリのファイルをインポート
- `@import("std")` で標準ライブラリをインポート
- `pub` 付きの要素のみ外部から利用可能

## 2. pubによる公開制御

`pub`キーワードを使用して、外部に公開する要素を制御できます。

### src/user.zig

```zig
const std = @import("std");

pub const User = struct {
    id: u32,
    name: []const u8,
    email: []const u8,
    password_hash: []const u8,  // プライベートフィールド

    // 公開コンストラクタ
    pub fn init(id: u32, name: []const u8, email: []const u8) User {
        return User{
            .id = id,
            .name = name,
            .email = email,
            .password_hash = "",  // 仮の値
        };
    }

    // 公開メソッド
    pub fn getName(self: User) []const u8 {
        return self.name;
    }

    // プライベートメソッド
    fn hashPassword(password: []const u8) []const u8 {
        // パスワードをハッシュ化
        return password;  // 簡略化
    }
};

// 公開関数
pub fn validateEmail(email: []const u8) bool {
    return std.mem.indexOf(u8, email, "@") != null;
}

// プライベート関数
fn internalHelper() void {
    // ...
}
```

### src/main.zig（一部）

```zig
const std = @import("std");
const user_mod = @import("user.zig");

pub fn main() void {
    const user = user_mod.User.init(1, "Alice", "alice@example.com");

    std.debug.print("Name: {s}\n", .{user.getName()});

    // user.password_hash は直接アクセスできない
    // user_mod.internalHelper() は呼べない

    if (user_mod.validateEmail("test@example.com")) {
        std.debug.print("Valid email\n", .{});
    }
}
```

### 公開制御の対象

| 要素 | pub無し | pub付き |
|------|---------|---------|
| **関数** | モジュール内のみ | 外部から利用可能 |
| **定数** | モジュール内のみ | 外部から利用可能 |
| **構造体** | モジュール内のみ | 外部から利用可能 |
| **構造体のフィールド** | 全て公開 | - |
| **構造体のメソッド** | モジュール内のみ | 外部から利用可能 |

## 3. パッケージ構成

ディレクトリ階層を使ってモジュールを整理できます。

### ディレクトリ構造

```
my-project/
├── build.zig
├── build.zig.zon
└── src/
    ├── main.zig
    ├── models/
    │   ├── user.zig
    │   └── post.zig
    ├── services/
    │   ├── auth.zig
    │   └── database.zig
    └── utils/
        └── helpers.zig
```

### src/models/user.zig

```zig
pub const User = struct {
    id: u32,
    name: []const u8,
};
```

### src/main.zig（一部）

```zig
const std = @import("std");
const User = @import("models/user.zig").User;

pub fn main() void {
    const user = User{ .id = 1, .name = "Alice" };
    std.debug.print("User: {s}\n", .{user.name});
}
```

### パッケージ構成のベストプラクティス

- 機能ごとにディレクトリを分ける
- `models/` - データ構造の定義
- `services/` - ビジネスロジック
- `utils/` - ユーティリティ関数
- ディレクトリ構成は自由に設計可能

## 4. build.zig.zon（依存関係）

外部パッケージの依存関係を管理します。

### build.zig.zon

```zig
.{
    .name = "my-project",
    .version = "0.1.0",
    .dependencies = .{
        .@"some-package" = .{
            .url = "https://github.com/user/some-package/archive/main.tar.gz",
            .hash = "1220...",
        },
    },
}
```

### build.zig

```zig
const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "my-project",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    // 依存パッケージを追加
    const some_package = b.dependency("some-package", .{
        .target = target,
        .optimize = optimize,
    });
    exe.root_module.addImport("some-package", some_package.module("some-package"));

    b.installArtifact(exe);
}
```

### 依存関係の追加手順

1. `build.zig.zon` の `dependencies` に追加
2. `zig fetch <URL>` でハッシュを取得
3. `build.zig` で `b.dependency()` を使用
4. `addImport()` でモジュールに追加

## Rustとの比較

### モジュールシステム

**Zig:**

```zig
// math.zig
pub fn add(a: i32, b: i32) i32 {
    return a + b;
}

// main.zig
const math = @import("math.zig");

pub fn main() void {
    const result = math.add(1, 2);
}
```

**Rust:**

```rust
// math.rs
pub fn add(a: i32, b: i32) -> i32 {
    a + b
}

// main.rs
mod math;

fn main() {
    let result = math::add(1, 2);
}
```

### 公開制御

**Zig:**

```zig
pub fn public_function() void {}  // 公開
fn private_function() void {}      // プライベート

pub const PUBLIC = 42;             // 公開
const PRIVATE = 42;                // プライベート
```

**Rust:**

```rust
pub fn public_function() {}        // 公開
fn private_function() {}           // プライベート

pub const PUBLIC: i32 = 42;        // 公開
const PRIVATE: i32 = 42;           // プライベート
```

### パッケージ管理

**Zig:**

```zig
// build.zig.zon
.{
    .dependencies = .{
        .@"some-package" = .{
            .url = "...",
            .hash = "...",
        },
    },
}
```

**Rust:**

```toml
# Cargo.toml
[dependencies]
some-package = "1.0"
```

## 重要な違い

### モジュールシステム

| 特徴 | Zig | Rust |
|------|-----|------|
| **インポート** | `@import("file.zig")` | `mod file;` |
| **パス指定** | ファイルパス直接指定 | モジュールツリー |
| **公開制御** | `pub` キーワード | `pub` キーワード |
| **ディレクトリ構造** | 自由 | `mod.rs` / `lib.rs` の規約 |

### 依存管理

**Zig:**
- `build.zig.zon` で管理
- URL とハッシュで指定
- 明示的なセキュリティチェック

**Rust:**
- `Cargo.toml` で管理
- バージョン番号で指定
- crates.io のレジストリ

## 学習ポイント

- `@import` でモジュールをインポート
- `pub` で公開制御
- ディレクトリ構成は自由
- `build.zig.zon` で依存管理
- Zigはファイルパスベース、Rustはモジュールツリーベース
- 構造体のフィールドは全て公開（メソッドで制御）
- プライベート要素は外部からアクセス不可

## ファイル構成

```
src/
├── main.zig          # メインプログラム
├── math.zig          # @importの基本例
├── user.zig          # pubによる公開制御の例
├── root.zig          # ライブラリのルートファイル
└── models/
    └── user.zig      # パッケージ構成の例
```

## 次のステップ

- より複雑なパッケージ構成を設計する
- 外部パッケージを利用してみる
- カスタムライブラリを作成する
- モジュール間の依存関係を管理する

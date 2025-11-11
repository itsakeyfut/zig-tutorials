# 10. よく使う標準ライブラリ

このチュートリアルでは、Zigの標準ライブラリの中でよく使われる機能（メモリ操作、ファイル操作、JSON処理）について学びます。

## サンプルファイル

### 1. src/mem_operations.zig - std.mem（メモリ操作）

メモリのコピー、比較、文字列の検索・分割・トリムなどの操作を学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- `@memcpy` でメモリのコピー
- `std.mem.eql` でメモリの比較
- `std.mem.indexOf` で文字列検索
- `std.mem.splitSequence` で文字列分割
- `std.mem.trim` で文字列のトリム

**コード例:**
```zig
// メモリのコピー
var src = [_]u8{ 1, 2, 3, 4, 5 };
var dst: [5]u8 = undefined;
@memcpy(&dst, &src);

// メモリの比較
const equal = std.mem.eql(u8, &src, &dst);
std.debug.print("Equal: {}\n", .{equal});

// 文字列の検索
const text = "Hello, Zig!";
if (std.mem.indexOf(u8, text, "Zig")) |index| {
    std.debug.print("Found at index {}\n", .{index});
}

// 文字列の分割
var iter = std.mem.splitSequence(u8, text, ", ");
while (iter.next()) |part| {
    std.debug.print("Part: {s}\n", .{part});
}

// トリム
const whitespace = "  hello  ";
const trimmed = std.mem.trim(u8, whitespace, " ");
std.debug.print("Trimmed: '{s}'\n", .{trimmed});
```

### 2. src/fs_operations.zig - std.fs（ファイル操作）

ファイルの読み書き、ディレクトリの作成・削除などの操作を学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- `std.fs.cwd().createFile` でファイル作成
- `file.writeAll` でファイル書き込み
- `std.fs.cwd().readFileAlloc` でファイル読み込み
- `std.fs.cwd().makeDir` でディレクトリ作成
- `std.fs.cwd().deleteDir` / `deleteFile` で削除

**コード例:**
```zig
// ファイルの書き込み
const file = try std.fs.cwd().createFile("test.txt", .{});
defer file.close();

try file.writeAll("Hello, Zig!\n");
try file.writeAll("This is a test.\n");

// ファイルの読み込み
const content = try std.fs.cwd().readFileAlloc(
    allocator,
    "test.txt",
    1024 * 1024,  // 最大サイズ
);
defer allocator.free(content);

std.debug.print("Content:\n{s}\n", .{content});

// ディレクトリの作成
try std.fs.cwd().makeDir("test_dir");

// ディレクトリの削除
try std.fs.cwd().deleteDir("test_dir");

// ファイルの削除
try std.fs.cwd().deleteFile("test.txt");
```

### 3. src/json_operations.zig - std.json（JSON処理）

JSONのシリアライズとデシリアライズ（パース）を学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- 構造体の定義とJSON変換
- `std.json.stringify` でJSONシリアライズ
- `std.json.parseFromSlice` でJSONデシリアライズ
- `ArrayList` をバッファとして使用

**コード例:**
```zig
const User = struct {
    id: u32,
    name: []const u8,
    email: []const u8,
    active: bool,
};

// JSONのシリアライズ
const user = User{
    .id = 1,
    .name = "Alice",
    .email = "alice@example.com",
    .active = true,
};

var buffer = std.ArrayList(u8).init(allocator);
defer buffer.deinit();

try std.json.stringify(user, .{}, buffer.writer());

std.debug.print("JSON: {s}\n", .{buffer.items});

// JSONのデシリアライズ
const json_text =
    \\{
    \\  "id": 2,
    \\  "name": "Bob",
    \\  "email": "bob@example.com",
    \\  "active": false
    \\}
;

const parsed = try std.json.parseFromSlice(
    User,
    allocator,
    json_text,
    .{},
);
defer parsed.deinit();

std.debug.print("Parsed: {s}\n", .{parsed.value.name});
```

### 4. src/cli_tool.zig - 実践的な例：CLIツール

コマンドライン引数を処理し、ファイルの行数と文字数をカウントするツールを作成します。

**実行方法:**
```bash
zig build run-cli -- <filename>
```

**使用例:**
```bash
zig build run-cli -- ../README.md
```

**学習内容:**
- `std.process.argsAlloc` でコマンドライン引数取得
- `std.process.argsFree` で引数の解放
- ファイル読み込みとエラーハンドリング
- 文字列の走査とカウント

**コード例:**
```zig
// コマンドライン引数を取得
const args = try std.process.argsAlloc(allocator);
defer std.process.argsFree(allocator, args);

if (args.len < 2) {
    std.debug.print("Usage: {s} <filename>\n", .{args[0]});
    return;
}

const filename = args[1];

// ファイルを読み込み
const content = std.fs.cwd().readFileAlloc(
    allocator,
    filename,
    1024 * 1024,
) catch |err| {
    std.debug.print("Error reading file: {}\n", .{err});
    return;
};
defer allocator.free(content);

// 行数と文字数をカウント
var line_count: usize = 0;
const char_count: usize = content.len;

for (content) |c| {
    if (c == '\n') line_count += 1;
}

std.debug.print("Lines: {}\n", .{line_count});
std.debug.print("Characters: {}\n", .{char_count});
```

## Rustとの比較

### メモリ操作

**Rust:**
```rust
// メモリのコピー
let src = [1u8, 2, 3, 4, 5];
let mut dst = [0u8; 5];
dst.copy_from_slice(&src);

// メモリの比較
assert_eq!(src, dst);

// 文字列の検索
let text = "Hello, Rust!";
if let Some(index) = text.find("Rust") {
    println!("Found at index {}", index);
}

// 文字列の分割
for part in text.split(", ") {
    println!("Part: {}", part);
}

// トリム
let whitespace = "  hello  ";
let trimmed = whitespace.trim();
println!("Trimmed: '{}'", trimmed);
```

**Zig:**
```zig
// メモリのコピー
var src = [_]u8{ 1, 2, 3, 4, 5 };
var dst: [5]u8 = undefined;
@memcpy(&dst, &src);

// メモリの比較
const equal = std.mem.eql(u8, &src, &dst);

// 文字列の検索
const text = "Hello, Zig!";
if (std.mem.indexOf(u8, text, "Zig")) |index| {
    std.debug.print("Found at index {}\n", .{index});
}

// 文字列の分割
var iter = std.mem.splitSequence(u8, text, ", ");
while (iter.next()) |part| {
    std.debug.print("Part: {s}\n", .{part});
}

// トリム
const whitespace = "  hello  ";
const trimmed = std.mem.trim(u8, whitespace, " ");
```

**主な違い:**
- Rust: メソッドチェーンが豊富で、型に対するメソッドが多い
- Zig: 関数ベースのアプローチで、明示的に型を指定
- Rust: イテレータが強力で関数型プログラミングスタイル
- Zig: より低レベルで制御が明示的

### ファイル操作

**Rust:**
```rust
use std::fs;
use std::io::Write;

// ファイルの書き込み
let mut file = fs::File::create("test.txt")?;
file.write_all(b"Hello, Rust!\n")?;

// ファイルの読み込み
let content = fs::read_to_string("test.txt")?;
println!("Content:\n{}", content);

// ディレクトリの作成
fs::create_dir("test_dir")?;

// ファイルの削除
fs::remove_file("test.txt")?;

// ディレクトリの削除
fs::remove_dir("test_dir")?;
```

**Zig:**
```zig
// ファイルの書き込み
const file = try std.fs.cwd().createFile("test.txt", .{});
defer file.close();
try file.writeAll("Hello, Zig!\n");

// ファイルの読み込み
const content = try std.fs.cwd().readFileAlloc(
    allocator,
    "test.txt",
    1024 * 1024,
);
defer allocator.free(content);

// ディレクトリの作成
try std.fs.cwd().makeDir("test_dir");

// ファイルの削除
try std.fs.cwd().deleteFile("test.txt");

// ディレクトリの削除
try std.fs.cwd().deleteDir("test_dir");
```

**主な違い:**
- Rust: RAIIで自動的にファイルがクローズされる
- Zig: `defer` で明示的にクローズを管理
- Rust: `?` 演算子でエラーを伝播
- Zig: `try` でエラーを伝播
- Zig: アロケータを明示的に渡す必要がある

### JSON処理

**Rust:**
```rust
use serde::{Serialize, Deserialize};

#[derive(Serialize, Deserialize)]
struct User {
    id: u32,
    name: String,
    email: String,
    active: bool,
}

// JSONのシリアライズ
let user = User {
    id: 1,
    name: "Alice".to_string(),
    email: "alice@example.com".to_string(),
    active: true,
};

let json = serde_json::to_string(&user)?;
println!("JSON: {}", json);

// JSONのデシリアライズ
let json_text = r#"{
    "id": 2,
    "name": "Bob",
    "email": "bob@example.com",
    "active": false
}"#;

let parsed: User = serde_json::from_str(json_text)?;
println!("Parsed: {}", parsed.name);
```

**Zig:**
```zig
const User = struct {
    id: u32,
    name: []const u8,
    email: []const u8,
    active: bool,
};

// JSONのシリアライズ
const user = User{
    .id = 1,
    .name = "Alice",
    .email = "alice@example.com",
    .active = true,
};

var buffer = std.ArrayList(u8).init(allocator);
defer buffer.deinit();

try std.json.stringify(user, .{}, buffer.writer());

// JSONのデシリアライズ
const json_text =
    \\{
    \\  "id": 2,
    \\  "name": "Bob",
    \\  "email": "bob@example.com",
    \\  "active": false
    \\}
;

const parsed = try std.json.parseFromSlice(
    User,
    allocator,
    json_text,
    .{},
);
defer parsed.deinit();
```

**主な違い:**
- Rust: `serde` クレートを使用（外部依存）
- Zig: 標準ライブラリに組み込み
- Rust: マクロによる自動実装（`Serialize`, `Deserialize`）
- Zig: 構造体の定義のみで自動的に対応
- Zig: アロケータの明示的な管理が必要

## 学習ポイント

- `std.mem` でメモリ操作や文字列操作を行う
- `std.fs` でファイルやディレクトリを操作する
- `std.json` でJSON処理を行う
- 標準ライブラリは豊富で、多くの機能が組み込まれている
- アロケータを明示的に渡すことでメモリ管理を制御
- `defer` を使ってリソースを確実に解放
- イテレータパターンで文字列を効率的に処理

## よくあるコンパイルエラー

### エラー1: undefined symbol

```
error: use of undeclared identifier 'std'
```

**原因:** `const std = @import("std");` の記述がない

**対処:** ファイルの先頭に `const std = @import("std");` を追加

### エラー2: local variable is never mutated

```
error: local variable is never mutated
    var count: usize = 0;
        ^~~~~
note: consider using 'const'
```

**原因:** `var` で宣言したが、値を変更していない

**対処:** `const` に変更するか、値を変更するコードを追加

### エラー3: expected type 'X', found 'Y'

**原因:** 型が一致していない（例: `[]const u8` と `[]u8`）

**対処:** 適切な型に変換するか、関数のシグネチャを修正

### エラー4: use of undefined value

```
error: use of undefined value
    var dst: [5]u8 = undefined;
                     ^~~~~~~~~
```

**原因:** `undefined` で初期化された値を、初期化前に使用している

**対処:** 使用前に適切に初期化する（例: `@memcpy` でコピー）

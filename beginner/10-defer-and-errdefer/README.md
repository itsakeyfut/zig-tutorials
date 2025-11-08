# 10. defer と errdefer

このチュートリアルでは、Zigにおけるリソース管理の要である`defer`と`errdefer`について学びます。

## サンプルファイル

### 1. src/defer_basic.zig - deferの基本

`defer`の基本的な使い方と実行順序を学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- deferの基本構文
- スコープ終了時の実行
- 実行順序の理解

**コード例:**
```zig
const std = @import("std");

pub fn main() !void {
    std.debug.print("Start\n", .{});

    defer std.debug.print("End\n", .{});

    std.debug.print("Middle\n", .{});

    // 出力順序:
    // Start
    // Middle
    // End
}
```

### 2. src/resource_management.zig - リソース管理

`defer`を使ったメモリやリソースの確実な解放方法を学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- メモリの確保と解放
- エラー発生時の挙動
- リソースリークの防止

**コード例:**
```zig
const std = @import("std");

fn processFile(allocator: std.mem.Allocator, path: []const u8) !void {
    // メモリ確保
    const buffer = try allocator.alloc(u8, 1024);
    defer allocator.free(buffer);  // スコープ終了時に解放

    std.debug.print("Processing {s}\n", .{path});

    // エラーが起きても defer は実行される
    if (std.mem.eql(u8, path, "bad.txt")) {
        return error.BadFile;
    }

    // 正常終了時も defer は実行される
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    processFile(allocator, "good.txt") catch |err| {
        std.debug.print("Error: {}\n", .{err});
    };
}
```

### 3. src/errdefer_example.zig - errdefer（エラー時のみ実行）

エラー時のみ実行される`errdefer`の使い方を学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- errdeferの基本構文
- deferとの違い
- エラーハンドリングパターン
- 成功時と失敗時の処理分岐

**コード例:**
```zig
const std = @import("std");

fn allocateAndProcess(allocator: std.mem.Allocator) ![]u8 {
    const buffer = try allocator.alloc(u8, 1024);
    errdefer allocator.free(buffer);  // エラー時のみ解放

    // 何か処理
    if (false) return error.ProcessingFailed;

    // 成功時は buffer を返す（解放しない）
    return buffer;
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    const buffer = try allocateAndProcess(allocator);
    defer allocator.free(buffer);

    std.debug.print("Success\n", .{});
}
```

### 4. src/multiple_defer.zig - 複数のdefer

複数の`defer`が使用された際の実行順序（LIFO）を学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- 複数のdefer文の扱い
- LIFO（後入れ先出し）順の実行
- スタック的な挙動

**コード例:**
```zig
pub fn main() void {
    defer std.debug.print("1\n", .{});
    defer std.debug.print("2\n", .{});
    defer std.debug.print("3\n", .{});

    std.debug.print("Start\n", .{});

    // 出力順序（LIFO）:
    // Start
    // 3
    // 2
    // 1
}
```

## Rustとの比較

### Dropトレイト vs defer

**Rust:**
```rust
// Rust: Drop トレイト（暗黙的）
{
    let _file = File::open("file.txt")?;
    // スコープ終了時に自動でクローズ
}
```

**Zig:**
```zig
// Zig: defer（明示的）
{
    const file = try std.fs.cwd().openFile("file.txt", .{});
    defer file.close();  // 明示的に遅延実行
}
```

**主な違い:**
- RustはDropトレイトで暗黙的にクリーンアップ
- Zigは`defer`で明示的にクリーンアップを記述
- Zigの方がクリーンアップコードが見えやすい
- どちらもスコープ終了時に確実に実行される

### エラーハンドリング

**Rust:**
```rust
// Rustではスコープガード的なパターンを使う
let resource = acquire_resource()?;
// Drop実装で自動的にクリーンアップ
```

**Zig:**
```zig
// Zigでは明示的にerrdefer
const resource = try acquireResource();
errdefer releaseResource(resource);
// エラー時のみクリーンアップ
```

## 学習ポイント

- `defer`はスコープ終了時に実行される
- `errdefer`はエラー時のみ実行される
- 複数の`defer`はLIFO順（後入れ先出し）で実行される
- RustのDropトレイトより明示的
- メモリリークを防ぐための重要な機能
- エラーハンドリングとリソース管理を分離できる

## よくあるパターン

### パターン1: メモリ確保と解放

```zig
fn doSomething(allocator: std.mem.Allocator) !void {
    const data = try allocator.alloc(u8, 100);
    defer allocator.free(data);

    // dataを使った処理
}
```

### パターン2: 複数リソースの管理

```zig
fn processFiles(allocator: std.mem.Allocator) !void {
    const file1 = try std.fs.cwd().openFile("file1.txt", .{});
    defer file1.close();

    const file2 = try std.fs.cwd().openFile("file2.txt", .{});
    defer file2.close();

    // ファイルを使った処理
    // file2が先に閉じられ、その後file1が閉じられる（LIFO）
}
```

### パターン3: エラー時のロールバック

```zig
fn createResource(allocator: std.mem.Allocator) !*Resource {
    const resource = try allocator.create(Resource);
    errdefer allocator.destroy(resource);

    try resource.init();
    errdefer resource.deinit();

    // 初期化が成功したら返す
    return resource;
}
```

## よくあるミス

### ミス1: deferの位置

```zig
// ❌ 間違い: リソース確保前にdefer
defer allocator.free(buffer);
const buffer = try allocator.alloc(u8, 100);  // bufferがまだ定義されていない
```

```zig
// ✅ 正しい: リソース確保後にdefer
const buffer = try allocator.alloc(u8, 100);
defer allocator.free(buffer);
```

### ミス2: errdefer vs defer の使い分け

```zig
// ❌ 間違い: 成功時もリソースを解放してしまう
fn createBuffer(allocator: std.mem.Allocator) ![]u8 {
    const buffer = try allocator.alloc(u8, 100);
    defer allocator.free(buffer);  // 常に解放される！
    return buffer;  // 解放されたメモリを返してしまう
}
```

```zig
// ✅ 正しい: エラー時のみ解放
fn createBuffer(allocator: std.mem.Allocator) ![]u8 {
    const buffer = try allocator.alloc(u8, 100);
    errdefer allocator.free(buffer);  // エラー時のみ解放
    return buffer;  // 成功時はbufferを返す
}
```

### ミス3: LIFOを考慮しない

```zig
// ⚠️ 注意: 依存関係がある場合はLIFOを意識
const file = try std.fs.cwd().openFile("file.txt", .{});
defer file.close();

const buffer = try allocator.alloc(u8, 100);
defer allocator.free(buffer);

// bufferが先に解放され、その後fileが閉じられる
```

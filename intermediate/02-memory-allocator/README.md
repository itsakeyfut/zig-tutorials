# 02. メモリアロケータの概念

このチュートリアルでは、Zigにおけるメモリアロケータの概念と使い方について学びます。

## サンプルファイル

### 1. src/allocator_basics.zig - アロケータの基本

なぜアロケータが必要なのか、そして基本的な使い方を学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- Zigにはガーベージコレクタがない
- 暗黙的なメモリ管理がない
- グローバルアロケータがない
- 明示的にアロケータを渡す必要性
- 基本的なメモリ確保と解放

**コード例:**
```zig
const std = @import("std");

pub fn main() !void {
    // アロケータを明示的に選択
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    // メモリ確保
    const buffer = try allocator.alloc(u8, 1024);
    defer allocator.free(buffer);

    std.debug.print("Allocated {} bytes\n", .{buffer.len});
}
```

### 2. src/allocator_types.zig - 標準アロケータの種類

Zigが提供する主要なアロケータの種類とそれぞれの特徴を学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- page_allocator（システムアロケータ）
- GeneralPurposeAllocator（汎用アロケータ）
- ArenaAllocator（アリーナアロケータ）
- FixedBufferAllocator（固定バッファアロケータ）

**コード例:**
```zig
// 1. page_allocator（システムアロケータ）
// - 直接OSからメモリを取得
// - 遅いが、シンプル
const page_alloc = std.heap.page_allocator;

// 2. GeneralPurposeAllocator（汎用アロケータ）
// - メモリリークを検出
// - デバッグに最適
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
defer {
    const leaked = gpa.deinit();
    if (leaked == .leak) {
        std.debug.print("Memory leak detected!\n", .{});
    }
}

// 3. ArenaAllocator（アリーナアロケータ）
// - まとめて解放
// - 一時的なメモリに最適
var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
defer arena.deinit();  // 全てまとめて解放

// 4. FixedBufferAllocator（固定バッファアロケータ）
// - スタック上のバッファを使用
// - OSコールなし
var buffer: [1024]u8 = undefined;
var fba = std.heap.FixedBufferAllocator.init(&buffer);
```

### 3. src/allocator_patterns.zig - アロケータの渡し方

アロケータを関数や構造体に渡す一般的なパターンを学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- 関数へのアロケータの渡し方
- 構造体でのアロケータの保持
- メモリ管理のベストプラクティス

**コード例:**
```zig
// パターン1: 関数にアロケータを渡す
fn processData(allocator: std.mem.Allocator, size: usize) ![]u8 {
    const buffer = try allocator.alloc(u8, size);
    // 処理...
    return buffer;
}

// パターン2: 構造体にアロケータを保持
const DataProcessor = struct {
    allocator: std.mem.Allocator,
    buffer: []u8,

    pub fn init(allocator: std.mem.Allocator, size: usize) !DataProcessor {
        const buffer = try allocator.alloc(u8, size);
        return DataProcessor{
            .allocator = allocator,
            .buffer = buffer,
        };
    }

    pub fn deinit(self: *DataProcessor) void {
        self.allocator.free(self.buffer);
    }

    pub fn process(self: *DataProcessor) void {
        std.debug.print("Processing {} bytes\n", .{self.buffer.len});
    }
};
```

## std.mem.Allocator インターフェース

`std.mem.Allocator` は構造体として実装されており、Rustのトレイトに相当します。

```zig
pub const Allocator = struct {
    ptr: *anyopaque,
    vtable: *const VTable,

    pub const VTable = struct {
        alloc: *const fn(ctx: *anyopaque, len: usize, ptr_align: u8, ret_addr: usize) ?[*]u8,
        resize: *const fn(ctx: *anyopaque, buf: []u8, buf_align: u8, new_len: usize, ret_addr: usize) bool,
        free: *const fn(ctx: *anyopaque, buf: []u8, buf_align: u8, ret_addr: usize) void,
    };

    // 使いやすいラッパー関数
    pub fn alloc(self: Allocator, comptime T: type, n: usize) ![]T { ... }
    pub fn free(self: Allocator, memory: anytype) void { ... }
};
```

## アロケータの選び方

| アロケータ | 特徴 | 適した用途 |
|----------|------|-----------|
| page_allocator | シンプル、遅い | プロトタイピング |
| GeneralPurposeAllocator | メモリリーク検出 | デバッグ、本番環境 |
| ArenaAllocator | まとめて解放 | 一時的なメモリ、リクエスト処理 |
| FixedBufferAllocator | 高速、サイズ固定 | 組み込み、低レイテンシ |

## Rustとの比較

### メモリ管理のアプローチ

**Rust:**
```rust
// グローバルアロケータ（暗黙的）
let vec = Vec::new();
let data = vec![1, 2, 3];
// スコープ終了でDrop trait が自動的に呼ばれる
```

**Zig:**
```zig
// 明示的アロケータ
var list = std.ArrayList(i32).init(allocator);
defer list.deinit();  // 明示的解放
```

**主な違い:**
- Rust: 所有権システムによる暗黙的な管理
- Zig: 明示的なアロケータの受け渡し
- Rust: RAII（Drop trait）
- Zig: defer/errdefer による明示的な管理

### アロケータの抽象化

**Rust:**
```rust
// Allocator API (nightly)
use std::alloc::{Allocator, Global};

fn allocate_data<A: Allocator>(alloc: A) -> Vec<u8, A> {
    Vec::with_capacity_in(1024, alloc)
}
```

**Zig:**
```zig
// std.mem.Allocator インターフェース
fn allocateData(allocator: std.mem.Allocator) ![]u8 {
    return try allocator.alloc(u8, 1024);
}
```

**主な違い:**
- Rust: トレイトベース（コンパイル時多態性）
- Zig: vtable ベース（実行時多態性だが最適化で静的化される）
- 両方とも柔軟なアロケータの切り替えが可能

## 学習ポイント

- Zigにはガーベージコレクタやグローバルアロケータがない
- アロケータは明示的に渡す必要がある
- `std.mem.Allocator` はインターフェースとして機能
- 用途に応じて最適なアロケータを選択
- ArenaAllocator は一時的なメモリ管理に便利
- `defer` で確実にメモリを解放
- Rustの所有権システムとは異なるアプローチ

## よくあるコンパイルエラー

### エラー1: expected type 'std.mem.Allocator', found '...'

```
error: expected type 'std.mem.Allocator', found 'std.heap.GeneralPurposeAllocator(...)'
```

**原因:** アロケータの型を直接渡している

**対処:** `.allocator()` メソッドを使って `std.mem.Allocator` インターフェースを取得する

```zig
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();  // これを渡す
```

### エラー2: memory leak detected

GeneralPurposeAllocator でメモリリークが検出される場合があります。

**原因:** 確保したメモリを解放していない

**対処:** `defer allocator.free()` を使って確実に解放する

### エラー3: OutOfMemory error

```
error: OutOfMemory
```

**原因:** FixedBufferAllocator で容量を超えた、または OS からのメモリ確保に失敗

**対処:** バッファサイズを増やすか、別のアロケータを使用する

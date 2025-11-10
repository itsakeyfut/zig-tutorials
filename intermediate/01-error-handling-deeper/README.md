# 01. エラー処理の深掘り

このチュートリアルでは、Zigにおける高度なエラー処理（エラーセットの組み合わせ、推論、カスタムエラー設計、errdefer）について学びます。

## サンプルファイル

### 1. src/error_sets.zig - エラーセットの組み合わせ

複数のエラーセットを `||` 演算子で結合する方法を学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- エラーセットの定義
- `||` 演算子でエラーセットを結合
- 結合したエラーセットの使用方法
- switchによるエラーハンドリング

**コード例:**
```zig
const FileError = error{
    NotFound,
    PermissionDenied,
    AlreadyExists,
};

const NetworkError = error{
    ConnectionRefused,
    Timeout,
    InvalidResponse,
};

// エラーセットを結合（|| 演算子）
const AppError = FileError || NetworkError;

fn readFromNetwork(url: []const u8) AppError![]const u8 {
    if (std.mem.eql(u8, url, "bad")) {
        return error.ConnectionRefused;
    }
    return "data";
}
```

### 2. src/error_inference.zig - エラー推論（anyerror）

`anyerror` と推論されるエラーセットの使い方を学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- `anyerror` 型の使用方法
- `!T` 形式によるエラーセットの推論
- 推論されたエラーセットの特性
- コンパイル時の型推論

**コード例:**
```zig
// anyerror は全てのエラーを含む
fn mightFail() anyerror!i32 {
    return error.UnknownError;
}

// エラーセットを推論（!T）
fn autoInfer() !i32 {
    if (false) return error.Failed;
    if (false) return error.AnotherError;
    return 42;
}
// 推論されたエラーセット: error{Failed, AnotherError}
```

### 3. src/custom_errors.zig - カスタムエラーの設計

レイヤーごとにエラーを定義し、組み合わせる方法を学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- レイヤーごとのエラー定義
- バリデーションエラーとデータベースエラーの分離
- エラーセットの組み合わせによる柔軟な設計
- `try` によるエラー伝播

**コード例:**
```zig
const DatabaseError = error{
    ConnectionFailed,
    QueryFailed,
    TransactionFailed,
};

const ValidationError = error{
    InvalidEmail,
    InvalidPassword,
    UsernameTooShort,
};

const AuthError = DatabaseError || ValidationError;

fn createUser(username: []const u8, email: []const u8) AuthError!User {
    // バリデーション（エラーは自動で伝播）
    try validateUsername(username);
    try validateEmail(email);

    // データベース操作
    // ...

    return User{ .id = 1, .username = username, .email = email };
}
```

### 4. src/errdefer_pattern.zig - errdefer の実践パターン

`errdefer` を使ったリソース管理の方法を学びます。

**実行方法:**
```bash
zig build run
```

**学習内容:**
- `errdefer` の基本的な使い方
- リソース確保時のクリーンアップパターン
- `defer` と `errdefer` の違い
- メモリリーク防止のベストプラクティス

**コード例:**
```zig
fn processWithCleanup(allocator: std.mem.Allocator) !void {
    // リソース1を確保
    const buffer1 = try allocator.alloc(u8, 1024);
    errdefer allocator.free(buffer1);  // エラー時にクリーンアップ

    // リソース2を確保
    const buffer2 = try allocator.alloc(u8, 2048);
    errdefer allocator.free(buffer2);  // エラー時にクリーンアップ

    // エラーが起きるかもしれない処理
    if (false) return error.ProcessingFailed;

    // 成功時はdeferで解放
    defer {
        allocator.free(buffer1);
        allocator.free(buffer2);
    }
}
```

## Rustとの比較

### エラー型の組み合わせ

**Rust:**
```rust
#[derive(Error, Debug)]
enum AppError {
    #[error("File error: {0}")]
    File(#[from] std::io::Error),
    #[error("Network error: {0}")]
    Network(String),
}
```

**Zig:**
```zig
const FileError = error{NotFound, PermissionDenied};
const NetworkError = error{ConnectionRefused, Timeout};
const AppError = FileError || NetworkError;
```

**主な違い:**
- Rust: `thiserror` などのクレートを使用してエラー型を定義
- Zig: 組み込みのエラーセット機能で簡潔に記述
- Zig: `||` 演算子で簡単に結合可能

### リソース管理

**Rust:**
```rust
// RAII（Drop trait）で自動クリーンアップ
let buffer = Vec::with_capacity(1024);
// スコープを抜けると自動的にdropされる
```

**Zig:**
```zig
// defer/errdefer で明示的に管理
const buffer = try allocator.alloc(u8, 1024);
errdefer allocator.free(buffer);  // エラー時のみ
defer allocator.free(buffer);     // 常に実行
```

**主な違い:**
- Rust: RAIIで暗黙的にクリーンアップ
- Zig: `defer`/`errdefer` で明示的に管理
- Zig: より細かい制御が可能

## 学習ポイント

- `||` でエラーセットを結合できる
- `anyerror` は全エラーを含む特殊な型
- `!T` 形式でエラーセットを推論可能
- レイヤーごとにエラーを定義することで責任を分離
- `errdefer` でリソース管理を安全に実装
- `defer` は成功・失敗に関わらず実行される
- `errdefer` はエラー発生時のみ実行される

## よくあるコンパイルエラー

### エラー1: error is not handled

```
error: error is discarded
```

**原因:** エラーを返す関数の結果を処理していない

**対処:** `try`, `catch`, または関数の戻り値に `!` を追加してエラーを伝播する

### エラー2: unable to resolve error union type

```
error: unable to resolve error union type
```

**原因:** エラーセットが推論できない状況でエラーを返している

**対処:** 明示的にエラーセット型を指定する

### エラー3: expected type 'X', found 'Y'

**原因:** 返すエラー型が関数のエラーセットに含まれていない

**対処:** 関数のエラーセットに必要なエラーを追加する

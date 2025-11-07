## プロジェクトの立ち上げ方

### プロジェクトを作成

次のコマンドを実行します。

```sh
zig init
```

次のようにファイルが作成されます。
```
info: created build.zig
info: created build.zig.zon
info: created src/main.zig
info: created src/root.zig
info: see `zig build --help` for a menu of options
```

次のようなプロジェクト構成になります。
```
my-project/
├── build.zig        # ビルド設定
├── build.zig.zon    # 依存関係
└── src/
    ├── main.zig     # エントリーポイント
    └── root.zig     # ライブラリルート
```

### ビルド

```sh
zig build
```

### テスト

```sh
zig build test
```

### 実行

```sh
zig build run
```

## 学習ポイント

- `const std = @import("std")` で標準ライブラリをインポート
- `pub fn main()` がエントリーポイント
- `!void` はエラーを返す可能性がある
- `try` でエラーを伝播
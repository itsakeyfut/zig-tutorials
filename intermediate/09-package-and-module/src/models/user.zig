//! パッケージ構成の例
//! このモジュールは models ディレクトリに配置され、
//! ディレクトリ階層を使ったモジュール管理を示します。

pub const User = struct {
    id: u32,
    name: []const u8,
};

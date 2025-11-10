//! pubによる公開制御の詳細例
//! このモジュールでは、構造体のフィールドやメソッドにおける公開制御を示します。
//! pubキーワードを使用して、外部から利用できるAPIを明示的に定義できます。

const std = @import("std");

pub const User = struct {
    id: u32,
    name: []const u8,
    email: []const u8,
    password_hash: []const u8, // プライベートフィールド

    // 公開コンストラクタ
    pub fn init(id: u32, name: []const u8, email: []const u8) User {
        return User{
            .id = id,
            .name = name,
            .email = email,
            .password_hash = "", // 仮の値
        };
    }

    // 公開メソッド
    pub fn getName(self: User) []const u8 {
        return self.name;
    }

    // プライベートメソッド
    fn hashPassword(password: []const u8) []const u8 {
        // パスワードをハッシュ化
        return password; // 簡略化
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

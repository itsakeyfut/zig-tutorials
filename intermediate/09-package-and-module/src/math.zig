//! @importの基本例
//! このモジュールでは、pub修飾子による公開制御の基本を示します。
//! pub付きの関数や定数は外部から利用でき、pub無しはモジュール内でのみ利用可能です。

pub fn add(a: i32, b: i32) i32 {
    return a + b;
}

pub fn multiply(a: i32, b: i32) i32 {
    return a * b;
}

const PI = 3.14159; // プライベート

pub const E = 2.71828; // 公開

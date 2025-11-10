//! 整数値の割り当て
//! このモジュールでは、enumに整数値を割り当てる方法を学びます。

const std = @import("std");

const StatusCode = enum(u16) {
    ok = 200,
    created = 201,
    bad_request = 400,
    not_found = 404,
    internal_error = 500,

    pub fn isSuccess(self: StatusCode) bool {
        const value = @intFromEnum(self);
        return value >= 200 and value < 300;
    }

    pub fn isClientError(self: StatusCode) bool {
        const value = @intFromEnum(self);
        return value >= 400 and value < 500;
    }

    pub fn isServerError(self: StatusCode) bool {
        const value = @intFromEnum(self);
        return value >= 500 and value < 600;
    }

    pub fn message(self: StatusCode) []const u8 {
        return switch (self) {
            .ok => "OK",
            .created => "Created",
            .bad_request => "Bad Request",
            .not_found => "Not Found",
            .internal_error => "Internal Server Error",
        };
    }
};

// 優先度を表すenum
const Priority = enum(u8) {
    low = 1,
    medium = 5,
    high = 10,
    critical = 20,

    pub fn compare(self: Priority, other: Priority) std.math.Order {
        const self_val = @intFromEnum(self);
        const other_val = @intFromEnum(other);
        if (self_val < other_val) return .lt;
        if (self_val > other_val) return .gt;
        return .eq;
    }
};

pub fn run() void {
    std.debug.print("\n--- 整数値の割り当て ---\n", .{});

    std.debug.print("\n1. enum → 整数への変換:\n", .{});
    const code = StatusCode.ok;
    const value: u16 = @intFromEnum(code);
    std.debug.print("Code: {}\n", .{code});
    std.debug.print("Value: {}\n", .{value});
    std.debug.print("Message: {s}\n", .{code.message()});

    std.debug.print("\n2. 整数 → enumへの変換:\n", .{});
    const from_int = @as(StatusCode, @enumFromInt(404));
    std.debug.print("Status: {}\n", .{from_int});
    std.debug.print("Message: {s}\n", .{from_int.message()});

    std.debug.print("\n3. ステータスコードの分類:\n", .{});
    const codes = [_]StatusCode{
        .ok,
        .created,
        .bad_request,
        .not_found,
        .internal_error,
    };

    for (codes) |c| {
        const status_type = if (c.isSuccess())
            "成功"
        else if (c.isClientError())
            "クライアントエラー"
        else if (c.isServerError())
            "サーバーエラー"
        else
            "その他";

        std.debug.print("{} ({}): {s}\n", .{ @intFromEnum(c), c, status_type });
    }

    std.debug.print("\n4. 優先度の比較:\n", .{});
    const p1 = Priority.medium;
    const p2 = Priority.high;

    const result = p1.compare(p2);
    const comparison = switch (result) {
        .lt => "より低い",
        .gt => "より高い",
        .eq => "同じ",
    };
    std.debug.print("{} ({}) は {} ({}) {s}\n", .{
        p1,
        @intFromEnum(p1),
        p2,
        @intFromEnum(p2),
        comparison,
    });

    std.debug.print("\n解説:\n", .{});
    std.debug.print("- enum(T) で整数型を指定\n", .{});
    std.debug.print("- @intFromEnum で整数値を取得\n", .{});
    std.debug.print("- @enumFromInt で整数からenumを作成\n", .{});
    std.debug.print("- HTTPステータスコードなどの実用例に最適\n", .{});
}

//! エラーセットの組み合わせの例
//! このモジュールでは、複数のエラーセットを || 演算子で結合する方法を示します。

const std = @import("std");

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
    if (std.mem.eql(u8, url, "missing")) {
        return error.NotFound;
    }
    return "data";
}

pub fn run() void {
    std.debug.print("\n--- エラーセットの組み合わせ ---\n", .{});

    // 正常ケース
    const result1 = readFromNetwork("good") catch |err| {
        switch (err) {
            error.NotFound => std.debug.print("File not found\n", .{}),
            error.ConnectionRefused => std.debug.print("Connection refused\n", .{}),
            error.Timeout => std.debug.print("Timeout\n", .{}),
            else => std.debug.print("Other error: {}\n", .{err}),
        }
        return;
    };
    std.debug.print("Result: {s}\n", .{result1});

    // エラーケース1: ConnectionRefused
    _ = readFromNetwork("bad") catch |err| {
        switch (err) {
            error.NotFound => std.debug.print("File not found\n", .{}),
            error.ConnectionRefused => std.debug.print("Connection refused\n", .{}),
            error.Timeout => std.debug.print("Timeout\n", .{}),
            else => std.debug.print("Other error: {}\n", .{err}),
        }
    };

    // エラーケース2: NotFound
    _ = readFromNetwork("missing") catch |err| {
        switch (err) {
            error.NotFound => std.debug.print("File not found\n", .{}),
            error.ConnectionRefused => std.debug.print("Connection refused\n", .{}),
            error.Timeout => std.debug.print("Timeout\n", .{}),
            else => std.debug.print("Other error: {}\n", .{err}),
        }
    };
}

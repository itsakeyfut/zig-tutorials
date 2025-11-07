const std = @import("std");

const FileError = error{
    FileNotFound,
    PermissionDenied,
};

fn readFile(path: []const u8) FileError![]const u8 {
    if (std.mem.eql(u8, path, "missing.txt")) {
        return error.FileNotFound;
    }
    if (std.mem.eql(u8, path, "protected.txt")) {
        return error.PermissionDenied;
    }
    return "file contents";
}

fn processFile(path: []const u8) FileError!void {
    // try でエラーを伝播（Rustの ? 演算子）
    const contents = try readFile(path);
    std.debug.print("Contents: {s}\n", .{contents});
}

pub fn run() void {
    std.debug.print("\n=== try and catch Examples ===\n", .{});

    // 成功ケース
    std.debug.print("\n1. Successful file read with try:\n", .{});
    processFile("data.txt") catch |err| {
        std.debug.print("Failed to process file: {}\n", .{err});
    };

    // エラーケース: FileNotFound
    std.debug.print("\n2. File not found:\n", .{});
    processFile("missing.txt") catch |err| {
        std.debug.print("Failed to process file: {}\n", .{err});
    };

    // 特定のエラーをキャッチ
    std.debug.print("\n3. Specific error handling with switch:\n", .{});
    const result = readFile("missing.txt") catch |err| switch (err) {
        error.FileNotFound => {
            std.debug.print("File not found - using default content\n", .{});
            return;
        },
        error.PermissionDenied => {
            std.debug.print("Permission denied - cannot access file\n", .{});
            return;
        },
    };
    std.debug.print("Content: {s}\n", .{result});
}

pub fn runPermissionDenied() void {
    std.debug.print("\n4. Permission denied error:\n", .{});
    const result = readFile("protected.txt") catch |err| switch (err) {
        error.FileNotFound => {
            std.debug.print("File not found\n", .{});
            return;
        },
        error.PermissionDenied => {
            std.debug.print("Permission denied - cannot access file\n", .{});
            return;
        },
    };
    std.debug.print("Content: {s}\n", .{result});
}

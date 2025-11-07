const std = @import("std");

const Config = struct {
    host: []const u8 = "localhost",
    port: u16 = 8080,
    timeout: u32 = 30,
};

pub fn run() void {
    std.debug.print("\n=== Default Values ===\n", .{});

    // デフォルト値を使う
    std.debug.print("\n1. Using all default values:\n", .{});
    const config1 = Config{};
    std.debug.print("config1 = Config{{}}\n", .{});
    std.debug.print("host: {s}\n", .{config1.host});
    std.debug.print("port: {}\n", .{config1.port});
    std.debug.print("timeout: {}s\n", .{config1.timeout});

    // 一部だけ指定
    std.debug.print("\n2. Overriding some default values:\n", .{});
    const config2 = Config{
        .port = 3000,
    };
    std.debug.print("config2 = Config{{ .port = 3000 }}\n", .{});
    std.debug.print("host: {s}\n", .{config2.host});
    std.debug.print("port: {}\n", .{config2.port});
    std.debug.print("timeout: {}s\n", .{config2.timeout});

    // 全て指定
    std.debug.print("\n3. Overriding all values:\n", .{});
    const config3 = Config{
        .host = "example.com",
        .port = 443,
        .timeout = 60,
    };
    std.debug.print("config3 = Config{{ .host = \"example.com\", .port = 443, .timeout = 60 }}\n", .{});
    std.debug.print("host: {s}\n", .{config3.host});
    std.debug.print("port: {}\n", .{config3.port});
    std.debug.print("timeout: {}s\n", .{config3.timeout});
}

pub fn runMoreExamples() void {
    std.debug.print("\n=== More Default Value Examples ===\n", .{});

    const Logger = struct {
        level: enum { debug, info, warn, err } = .info,
        enabled: bool = true,
        max_file_size: u32 = 1024 * 1024, // 1MB

        pub fn log(self: @This(), message: []const u8) void {
            if (!self.enabled) return;
            std.debug.print("[{s}] {s}\n", .{ @tagName(self.level), message });
        }
    };

    std.debug.print("\n1. Logger with default values:\n", .{});
    const logger1 = Logger{};
    std.debug.print("level: {s}\n", .{@tagName(logger1.level)});
    std.debug.print("enabled: {}\n", .{logger1.enabled});
    std.debug.print("max_file_size: {} bytes\n", .{logger1.max_file_size});
    logger1.log("Default logger");

    std.debug.print("\n2. Logger with custom level:\n", .{});
    const logger2 = Logger{ .level = .err };
    logger2.log("Error logger");

    std.debug.print("\n3. Disabled logger:\n", .{});
    const logger3 = Logger{ .enabled = false };
    std.debug.print("Attempting to log with disabled logger:\n", .{});
    logger3.log("This won't be printed");
    std.debug.print("(nothing printed because logger is disabled)\n", .{});
}

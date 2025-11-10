//! 型生成
//! このモジュールでは、型を返す関数（ジェネリクス）を学びます。

const std = @import("std");

// 型を返す関数
fn Pair(comptime T: type) type {
    return struct {
        first: T,
        second: T,

        pub fn init(first: T, second: T) @This() {
            return .{ .first = first, .second = second };
        }

        pub fn swap(self: *@This()) void {
            const temp = self.first;
            self.first = self.second;
            self.second = temp;
        }

        pub fn sum(self: @This()) T {
            return self.first + self.second;
        }
    };
}

// Option型（RustのOption相当）
fn Optional(comptime T: type) type {
    return union(enum) {
        some: T,
        none,

        pub fn isSome(self: @This()) bool {
            return switch (self) {
                .some => true,
                .none => false,
            };
        }

        pub fn unwrap(self: @This()) T {
            return switch (self) {
                .some => |value| value,
                .none => @panic("called unwrap on a none value"),
            };
        }
    };
}

pub fn run() void {
    std.debug.print("\n--- 型生成 ---\n", .{});

    // Pair型の使用
    std.debug.print("\n1. Pair型（ジェネリック構造体）:\n", .{});
    var pair_int = Pair(i32).init(10, 20);
    std.debug.print("Before swap: ({}, {})\n", .{ pair_int.first, pair_int.second });

    pair_int.swap();
    std.debug.print("After swap: ({}, {})\n", .{ pair_int.first, pair_int.second });
    std.debug.print("Sum: {}\n", .{pair_int.sum()});

    var pair_float = Pair(f64).init(3.14, 2.71);
    std.debug.print("\nFloat pair: ({d:.2}, {d:.2})\n", .{ pair_float.first, pair_float.second });
    std.debug.print("Sum: {d:.2}\n", .{pair_float.sum()});

    const pair_str = Pair([]const u8).init("hello", "world");
    std.debug.print("\nString pair: ({s}, {s})\n", .{ pair_str.first, pair_str.second });

    // Optional型の使用
    std.debug.print("\n2. Optional型（RustのOption相当）:\n", .{});
    const some_value = Optional(i32){ .some = 42 };
    const none_value = Optional(i32){ .none = {} };

    std.debug.print("some_value.isSome() = {}\n", .{some_value.isSome()});
    std.debug.print("some_value.unwrap() = {}\n", .{some_value.unwrap()});

    std.debug.print("none_value.isSome() = {}\n", .{none_value.isSome()});
    // none_value.unwrap() はパニックする
    // std.debug.print("none_value.unwrap() = {}\n", .{none_value.unwrap()});

    std.debug.print("\n解説:\n", .{});
    std.debug.print("- 型を返す関数でジェネリクスを実現\n", .{});
    std.debug.print("- comptime T: type パラメータで型を受け取る\n", .{});
    std.debug.print("- @This() で自己参照型を取得\n", .{});
    std.debug.print("- Rustのジェネリクスと同等の機能\n", .{});
}

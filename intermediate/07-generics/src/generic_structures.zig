//! ジェネリック構造体
//! このモジュールでは、型を返す関数によるジェネリック構造体を学びます。

const std = @import("std");

// スタック構造
fn Stack(comptime T: type) type {
    return struct {
        items: std.ArrayList(T),

        pub fn init(allocator: std.mem.Allocator) @This() {
            return .{
                .items = std.ArrayList(T).init(allocator),
            };
        }

        pub fn deinit(self: *@This()) void {
            self.items.deinit();
        }

        pub fn push(self: *@This(), item: T) !void {
            try self.items.append(item);
        }

        pub fn pop(self: *@This()) ?T {
            if (self.items.items.len == 0) return null;
            return self.items.pop();
        }

        pub fn peek(self: *const @This()) ?T {
            if (self.items.items.len == 0) return null;
            return self.items.items[self.items.items.len - 1];
        }

        pub fn len(self: *const @This()) usize {
            return self.items.items.len;
        }

        pub fn isEmpty(self: *const @This()) bool {
            return self.items.items.len == 0;
        }
    };
}

// キュー構造
fn Queue(comptime T: type) type {
    return struct {
        items: std.ArrayList(T),

        pub fn init(allocator: std.mem.Allocator) @This() {
            return .{
                .items = std.ArrayList(T).init(allocator),
            };
        }

        pub fn deinit(self: *@This()) void {
            self.items.deinit();
        }

        pub fn enqueue(self: *@This(), item: T) !void {
            try self.items.append(item);
        }

        pub fn dequeue(self: *@This()) ?T {
            if (self.items.items.len == 0) return null;
            return self.items.orderedRemove(0);
        }

        pub fn len(self: *const @This()) usize {
            return self.items.items.len;
        }
    };
}

// ペア構造
fn Pair(comptime T1: type, comptime T2: type) type {
    return struct {
        first: T1,
        second: T2,

        pub fn init(first: T1, second: T2) @This() {
            return .{
                .first = first,
                .second = second,
            };
        }
    };
}

// Result型（RustのResult相当）
fn Result(comptime T: type, comptime E: type) type {
    return union(enum) {
        ok: T,
        err: E,

        pub fn isOk(self: @This()) bool {
            return switch (self) {
                .ok => true,
                .err => false,
            };
        }

        pub fn isErr(self: @This()) bool {
            return !self.isOk();
        }

        pub fn unwrap(self: @This()) T {
            return switch (self) {
                .ok => |value| value,
                .err => @panic("called unwrap on an error value"),
            };
        }

        pub fn unwrapOr(self: @This(), default: T) T {
            return switch (self) {
                .ok => |value| value,
                .err => default,
            };
        }
    };
}

pub fn run() !void {
    std.debug.print("\n--- ジェネリック構造体 ---\n", .{});

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    std.debug.print("\n1. Stack（スタック）:\n", .{});
    var stack = Stack(i32).init(allocator);
    defer stack.deinit();

    try stack.push(10);
    try stack.push(20);
    try stack.push(30);

    std.debug.print("Stack length: {}\n", .{stack.len()});
    std.debug.print("Top item: {?}\n", .{stack.peek()});

    std.debug.print("Popping items:\n", .{});
    while (stack.pop()) |value| {
        std.debug.print("  Popped: {}\n", .{value});
    }

    std.debug.print("\n2. Queue（キュー）:\n", .{});
    var queue = Queue([]const u8).init(allocator);
    defer queue.deinit();

    try queue.enqueue("first");
    try queue.enqueue("second");
    try queue.enqueue("third");

    std.debug.print("Queue length: {}\n", .{queue.len()});
    std.debug.print("Dequeuing items:\n", .{});
    while (queue.dequeue()) |value| {
        std.debug.print("  Dequeued: {s}\n", .{value});
    }

    std.debug.print("\n3. Pair（ペア）:\n", .{});
    const pair1 = Pair(i32, f64).init(42, 3.14);
    std.debug.print("Int-Float pair: ({}, {d:.2})\n", .{ pair1.first, pair1.second });

    const pair2 = Pair([]const u8, bool).init("hello", true);
    std.debug.print("String-Bool pair: ({s}, {})\n", .{ pair2.first, pair2.second });

    std.debug.print("\n4. Result型（RustのResult相当）:\n", .{});
    const ok_result = Result(i32, []const u8){ .ok = 42 };
    const err_result = Result(i32, []const u8){ .err = "error occurred" };

    std.debug.print("ok_result.isOk() = {}\n", .{ok_result.isOk()});
    std.debug.print("ok_result.unwrap() = {}\n", .{ok_result.unwrap()});

    std.debug.print("err_result.isErr() = {}\n", .{err_result.isErr()});
    std.debug.print("err_result.unwrapOr(0) = {}\n", .{err_result.unwrapOr(0)});

    std.debug.print("\n5. 異なる型のStack:\n", .{});
    var float_stack = Stack(f64).init(allocator);
    defer float_stack.deinit();

    try float_stack.push(1.1);
    try float_stack.push(2.2);
    try float_stack.push(3.3);

    std.debug.print("Float stack:\n", .{});
    while (float_stack.pop()) |value| {
        std.debug.print("  {d:.1}\n", .{value});
    }

    std.debug.print("\n解説:\n", .{});
    std.debug.print("- fn Name(comptime T: type) type で型を返す関数\n", .{});
    std.debug.print("- @This() で自己参照型を取得\n", .{});
    std.debug.print("- Stack(i32) のように型を指定して使用\n", .{});
    std.debug.print("- Rustのジェネリック構造体と同等の機能\n", .{});
}

//! カスタムデータ構造
//! このモジュールでは、ArrayListを使ってカスタムデータ構造を作成します。

const std = @import("std");

// キュー構造
const Queue = struct {
    items: std.ArrayList(i32),

    pub fn init(allocator: std.mem.Allocator) Queue {
        return Queue{
            .items = std.ArrayList(i32).init(allocator),
        };
    }

    pub fn deinit(self: *Queue) void {
        self.items.deinit();
    }

    pub fn enqueue(self: *Queue, value: i32) !void {
        try self.items.append(value);
    }

    pub fn dequeue(self: *Queue) ?i32 {
        if (self.items.items.len == 0) return null;
        return self.items.orderedRemove(0);
    }

    pub fn isEmpty(self: Queue) bool {
        return self.items.items.len == 0;
    }

    pub fn size(self: Queue) usize {
        return self.items.items.len;
    }

    pub fn peek(self: Queue) ?i32 {
        if (self.items.items.len == 0) return null;
        return self.items.items[0];
    }
};

// スタック構造
const Stack = struct {
    items: std.ArrayList(i32),

    pub fn init(allocator: std.mem.Allocator) Stack {
        return Stack{
            .items = std.ArrayList(i32).init(allocator),
        };
    }

    pub fn deinit(self: *Stack) void {
        self.items.deinit();
    }

    pub fn push(self: *Stack, value: i32) !void {
        try self.items.append(value);
    }

    pub fn pop(self: *Stack) ?i32 {
        if (self.items.items.len == 0) return null;
        return self.items.pop();
    }

    pub fn isEmpty(self: Stack) bool {
        return self.items.items.len == 0;
    }

    pub fn size(self: Stack) usize {
        return self.items.items.len;
    }

    pub fn peek(self: Stack) ?i32 {
        if (self.items.items.len == 0) return null;
        return self.items.items[self.items.items.len - 1];
    }
};

// 優先度付きキュー（シンプル版）
const PriorityQueue = struct {
    items: std.ArrayList(Item),

    const Item = struct {
        value: i32,
        priority: i32,
    };

    pub fn init(allocator: std.mem.Allocator) PriorityQueue {
        return PriorityQueue{
            .items = std.ArrayList(Item).init(allocator),
        };
    }

    pub fn deinit(self: *PriorityQueue) void {
        self.items.deinit();
    }

    pub fn enqueue(self: *PriorityQueue, value: i32, priority: i32) !void {
        try self.items.append(.{ .value = value, .priority = priority });
        // 優先度でソート（降順）
        std.mem.sort(Item, self.items.items, {}, struct {
            fn lessThan(_: void, a: Item, b: Item) bool {
                return a.priority > b.priority;
            }
        }.lessThan);
    }

    pub fn dequeue(self: *PriorityQueue) ?i32 {
        if (self.items.items.len == 0) return null;
        return self.items.orderedRemove(0).value;
    }

    pub fn isEmpty(self: PriorityQueue) bool {
        return self.items.items.len == 0;
    }
};

// リングバッファ
const RingBuffer = struct {
    items: std.ArrayList(i32),
    capacity: usize,
    head: usize,
    tail: usize,
    count: usize,

    pub fn init(allocator: std.mem.Allocator, capacity: usize) !RingBuffer {
        var items = std.ArrayList(i32).init(allocator);
        try items.resize(capacity);
        return RingBuffer{
            .items = items,
            .capacity = capacity,
            .head = 0,
            .tail = 0,
            .count = 0,
        };
    }

    pub fn deinit(self: *RingBuffer) void {
        self.items.deinit();
    }

    pub fn push(self: *RingBuffer, value: i32) !void {
        if (self.count == self.capacity) {
            return error.BufferFull;
        }
        self.items.items[self.tail] = value;
        self.tail = (self.tail + 1) % self.capacity;
        self.count += 1;
    }

    pub fn pop(self: *RingBuffer) ?i32 {
        if (self.count == 0) return null;
        const value = self.items.items[self.head];
        self.head = (self.head + 1) % self.capacity;
        self.count -= 1;
        return value;
    }

    pub fn isFull(self: RingBuffer) bool {
        return self.count == self.capacity;
    }

    pub fn isEmpty(self: RingBuffer) bool {
        return self.count == 0;
    }
};

pub fn run() !void {
    std.debug.print("\n--- カスタムデータ構造 ---\n", .{});

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    std.debug.print("\n1. Queue（キュー）:\n", .{});
    var queue = Queue.init(allocator);
    defer queue.deinit();

    try queue.enqueue(10);
    try queue.enqueue(20);
    try queue.enqueue(30);

    std.debug.print("Queue size: {}\n", .{queue.size()});
    std.debug.print("Peek: {?}\n", .{queue.peek()});

    std.debug.print("Dequeuing:\n", .{});
    while (queue.dequeue()) |value| {
        std.debug.print("  Dequeued: {}\n", .{value});
    }

    std.debug.print("\n2. Stack（スタック）:\n", .{});
    var stack = Stack.init(allocator);
    defer stack.deinit();

    try stack.push(1);
    try stack.push(2);
    try stack.push(3);

    std.debug.print("Stack size: {}\n", .{stack.size()});
    std.debug.print("Peek: {?}\n", .{stack.peek()});

    std.debug.print("Popping:\n", .{});
    while (stack.pop()) |value| {
        std.debug.print("  Popped: {}\n", .{value});
    }

    std.debug.print("\n3. PriorityQueue（優先度付きキュー）:\n", .{});
    var pq = PriorityQueue.init(allocator);
    defer pq.deinit();

    try pq.enqueue(100, 1); // value=100, priority=1
    try pq.enqueue(200, 5); // value=200, priority=5
    try pq.enqueue(300, 3); // value=300, priority=3

    std.debug.print("Dequeuing by priority:\n", .{});
    while (pq.dequeue()) |value| {
        std.debug.print("  Dequeued: {}\n", .{value});
    }

    std.debug.print("\n4. RingBuffer（リングバッファ）:\n", .{});
    var ring = try RingBuffer.init(allocator, 5);
    defer ring.deinit();

    try ring.push(1);
    try ring.push(2);
    try ring.push(3);

    std.debug.print("Ring buffer count: {}\n", .{ring.count});
    std.debug.print("Is full: {}\n", .{ring.isFull()});

    std.debug.print("Pop 2 items:\n", .{});
    std.debug.print("  {?}\n", .{ring.pop()});
    std.debug.print("  {?}\n", .{ring.pop()});

    std.debug.print("Push 3 more items:\n", .{});
    try ring.push(4);
    try ring.push(5);
    try ring.push(6);

    std.debug.print("Pop all:\n", .{});
    while (ring.pop()) |value| {
        std.debug.print("  {}\n", .{value});
    }

    std.debug.print("\n解説:\n", .{});
    std.debug.print("- ArrayListを使ってカスタムデータ構造を作成可能\n", .{});
    std.debug.print("- Queue, Stack, PriorityQueue など\n", .{});
    std.debug.print("- init/deinit パターンでメモリ管理\n", .{});
    std.debug.print("- Rustの VecDeque や BinaryHeap と同等の機能\n", .{});
}

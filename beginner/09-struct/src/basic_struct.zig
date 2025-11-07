const std = @import("std");

const Point = struct {
    x: f32,
    y: f32,

    // メソッド（実は関数）
    pub fn init(x: f32, y: f32) Point {
        return Point{ .x = x, .y = y };
    }

    pub fn distance(self: Point) f32 {
        return @sqrt(self.x * self.x + self.y * self.y);
    }

    pub fn add(self: Point, other: Point) Point {
        return Point{
            .x = self.x + other.x,
            .y = self.y + other.y,
        };
    }
};

pub fn run() void {
    std.debug.print("\n=== Basic Struct ===\n", .{});

    // init関数を使った初期化
    std.debug.print("\n1. Using init function:\n", .{});
    const p1 = Point.init(3.0, 4.0);
    std.debug.print("p1 = Point.init(3.0, 4.0)\n", .{});
    std.debug.print("p1.x = {d:.1}, p1.y = {d:.1}\n", .{ p1.x, p1.y });

    // 直接初期化
    std.debug.print("\n2. Direct initialization:\n", .{});
    const p2 = Point{ .x = 1.0, .y = 2.0 };
    std.debug.print("p2 = Point{{ .x = 1.0, .y = 2.0 }}\n", .{});
    std.debug.print("p2.x = {d:.1}, p2.y = {d:.1}\n", .{ p2.x, p2.y });

    // メソッド呼び出し
    std.debug.print("\n3. Calling methods:\n", .{});
    const dist = p1.distance();
    std.debug.print("p1.distance() = {d:.2}\n", .{dist});

    // 構造体の演算
    std.debug.print("\n4. Struct operations:\n", .{});
    const p3 = p1.add(p2);
    std.debug.print("p3 = p1.add(p2)\n", .{});
    std.debug.print("p3: ({d:.1}, {d:.1})\n", .{ p3.x, p3.y });
}

pub fn runMoreExamples() void {
    std.debug.print("\n=== More Struct Examples ===\n", .{});

    const Rectangle = struct {
        width: f32,
        height: f32,

        pub fn init(width: f32, height: f32) @This() {
            return .{
                .width = width,
                .height = height,
            };
        }

        pub fn area(self: @This()) f32 {
            return self.width * self.height;
        }

        pub fn perimeter(self: @This()) f32 {
            return 2 * (self.width + self.height);
        }
    };

    std.debug.print("\n1. Rectangle struct:\n", .{});
    const rect = Rectangle.init(5.0, 3.0);
    std.debug.print("Rectangle{{ width: {d:.1}, height: {d:.1} }}\n", .{ rect.width, rect.height });
    std.debug.print("Area: {d:.1}\n", .{rect.area()});
    std.debug.print("Perimeter: {d:.1}\n", .{rect.perimeter()});

    std.debug.print("\n2. Using @This() for type reference:\n", .{});
    std.debug.print("@This() returns the innermost struct/union/enum type\n", .{});
    std.debug.print("Useful for avoiding repetition of struct name\n", .{});
}

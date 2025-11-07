const std = @import("std");

fn increment(x: *i32) void {
    x.* += 1;
}

fn process(slice: []const u8) void {
    std.debug.print("Length: {}\n", .{slice.len});
}

pub fn main() void {
    var x: i32 = 10;
    increment(&x); // ポインタを渡す
    std.debug.print("x = {}\n", .{x}); // 11

    const data = "Hello";
    process(data);
}

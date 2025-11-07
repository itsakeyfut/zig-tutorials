const std = @import("std");

const DivResult = struct {
    quotient: i32,
    remainder: i32,
};

fn divmod(a: i32, b: i32) DivResult {
    return DivResult{
        .quotient = @divTrunc(a, b),
        .remainder = @rem(a, b),
    };
}

pub fn main() void {
    const result = divmod(10, 3);
    std.debug.print("10 / 3 = {} 余り {}\n", .{ result.quotient, result.remainder });
}

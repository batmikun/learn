const std = @import("std");
const print = std.debug.print;
const fmt = std.fmt;

var data =
    \\forward 6
    \\down 3
    \\forward 8
    \\down 5
    \\forward 9
    \\down 2
    \\up 9
    \\down 9
    \\forward 8
    \\down 3
    \\down 8
    \\forward 2
    \\down 1
    \\up 3
    \\up 6
    \\up 9
    \\down 7
    \\up 7
    \\down 1
    \\forward 7
    \\down 7
    \\up 4
    \\down 2
    \\forward 8
    \\up 3
    \\up 1
    \\down 1
    \\down 6
    \\up 2
    \\down 5
    \\forward 4
    \\down 5
    \\down 3
    \\forward 4
    \\down 3
    \\up 8
    \\forward 1
    \\up 9
    \\forward 2
    \\up 7
    \\down 2
    \\down 9
    \\down 1
    \\down 6
    \\down 8
    \\down 6
    \\down 1
    \\down 1
    \\down 9
    \\down 9
    \\down 2
    \\forward 9
    \\down 1
    \\forward 4
    \\down 2
    \\forward 6
    \\down 8
    \\forward 4
    \\forward 8
    \\forward 4
    \\forward 4
    \\up 4
    \\up 9
    \\down 6
    \\forward 2
    \\forward 5
    \\down 2
    \\forward 1
    \\down 9
    \\forward 2
    \\down 8
    \\down 2
    \\forward 5
    \\down 7
    \\forward 7
    \\down 4
    \\up 3
    \\down 9
    \\forward 3
    \\down 7
    \\up 4
    \\down 5
    \\down 4
    \\forward 8
    \\down 2
    \\down 2
    \\forward 9
    \\down 9
    \\down 5
    \\down 1
    \\down 5
    \\forward 5
    \\down 1
    \\up 7
    \\down 2
    \\forward 7
    \\forward 6
    \\forward 5
    \\forward 4
    \\down 3
    \\forward 9
    \\up 1
    \\down 1
    \\up 8
    \\down 4
    \\down 7
    \\forward 2
    \\down 1
    \\up 9
    \\up 3
    \\down 4
    \\down 1
    \\down 9
    \\down 4
    \\forward 4
    \\forward 7
    \\down 7
    \\down 1
    \\up 6
    \\forward 8
    \\down 8
    \\forward 2
    \\down 4
    \\up 4
    \\forward 3
    \\down 1
    \\up 8
    \\up 2
    \\forward 3
    \\forward 5
    \\forward 7
    \\down 5
    \\up 2
    \\down 6
    \\forward 9
    \\forward 3
    \\down 1
    \\forward 7
    \\up 1
    \\down 4
    \\up 2
    \\forward 5
    \\down 1
    \\forward 2
    \\down 3
    \\forward 9
    \\down 1
    \\down 6
    \\down 7
    \\up 9
    \\down 5
    \\down 1
    \\forward 5
    \\forward 7
    \\down 6
    \\forward 1
    \\down 3
    \\forward 3
    \\forward 1
    \\down 7
    \\forward 9
    \\forward 7
    \\forward 4
    \\up 1
    \\down 8
    \\up 8
    \\down 3
    \\forward 9
    \\up 2
    \\down 4
    \\down 4
    \\down 3
    \\forward 7
    \\forward 3
    \\down 5
    \\up 4
    \\up 7
    \\down 6
    \\forward 2
    \\down 2
    \\down 9
    \\down 9
    \\down 7
    \\down 7
    \\forward 5
    \\forward 8
    \\up 2
    \\forward 9
    \\forward 5
    \\down 2
    \\up 6
    \\down 2
    \\up 2
    \\down 6
    \\down 3
    \\down 2
    \\down 3
    \\down 9
    \\forward 6
    \\up 9
    \\down 3
    \\forward 9
    \\forward 4
    \\forward 1
    \\down 3
    \\down 4
    \\forward 8
    \\forward 4
    \\down 7
    \\forward 9
    \\forward 2
    \\forward 9
    \\down 2
    \\down 3
    \\down 1
    \\down 6
    \\forward 5
    \\down 3
    \\forward 1
    \\down 3
    \\forward 7
    \\down 3
    \\forward 3
    \\up 2
    \\up 8
    \\down 2
    \\down 3
    \\down 7
    \\forward 6
    \\forward 7
    \\up 5
    \\forward 4
    \\forward 6
    \\down 1
    \\forward 1
    \\forward 9
    \\down 2
    \\down 8
    \\forward 6
    \\down 8
    \\down 5
    \\forward 9
    \\forward 3
    \\down 6
    \\forward 3
    \\forward 1
    \\up 7
    \\down 2
    \\down 9
    \\up 6
    \\forward 7
    \\down 9
    \\up 8
    \\forward 5
    \\forward 2
    \\forward 9
    \\down 3
    \\up 7
    \\forward 7
    \\down 4
    \\up 6
    \\up 5
    \\forward 6
    \\forward 2
    \\down 9
    \\forward 9
    \\forward 3
    \\down 4
    \\forward 5
    \\forward 4
    \\forward 4
    \\down 8
    \\forward 4
    \\forward 2
    \\up 8
    \\down 8
    \\forward 6
    \\up 4
    \\down 7
    \\forward 8
    \\up 9
    \\forward 3
    \\forward 5
    \\forward 8
    \\down 5
    \\up 6
    \\up 6
    \\down 5
    \\forward 2
    \\down 3
    \\up 1
    \\down 8
    \\forward 3
    \\down 4
    \\up 9
    \\forward 8
    \\forward 5
    \\forward 2
    \\forward 6
    \\forward 8
    \\up 5
    \\forward 5
    \\down 2
    \\down 4
    \\down 8
    \\forward 3
    \\up 9
    \\down 1
    \\down 9
    \\forward 7
    \\forward 9
    \\down 4
    \\down 2
    \\forward 3
    \\down 1
    \\forward 2
    \\down 2
    \\down 5
    \\forward 2
    \\forward 3
    \\forward 9
    \\down 2
    \\forward 3
    \\forward 9
    \\forward 6
    \\forward 7
    \\down 6
    \\forward 5
    \\up 7
    \\forward 6
    \\up 1
    \\down 7
    \\down 6
    \\down 3
    \\down 7
    \\forward 2
    \\forward 8
    \\forward 3
    \\down 3
    \\forward 7
    \\down 3
    \\up 8
    \\forward 1
    \\down 5
    \\down 9
    \\down 6
    \\forward 1
    \\forward 1
    \\down 1
    \\down 1
    \\forward 8
    \\forward 7
    \\forward 1
    \\up 2
    \\down 4
    \\up 7
    \\down 3
    \\up 8
    \\up 7
    \\forward 3
    \\up 9
    \\down 5
    \\forward 4
    \\down 6
    \\up 8
    \\forward 6
    \\forward 7
    \\down 1
    \\up 7
    \\down 9
    \\down 9
    \\up 9
    \\forward 7
    \\down 6
    \\down 4
    \\down 6
    \\down 7
    \\down 7
    \\up 7
    \\down 4
    \\up 7
    \\forward 1
    \\down 8
    \\down 3
    \\down 2
    \\forward 9
    \\up 7
    \\down 1
    \\down 2
    \\forward 1
    \\forward 5
    \\down 7
    \\up 4
    \\down 7
    \\down 4
    \\down 5
    \\up 8
    \\down 6
    \\down 2
    \\down 4
    \\up 5
    \\down 8
    \\down 3
    \\down 9
    \\forward 6
    \\forward 5
    \\down 1
    \\down 3
    \\down 2
    \\down 3
    \\forward 8
    \\forward 4
    \\forward 6
    \\forward 9
    \\up 1
    \\forward 6
    \\forward 8
    \\down 2
    \\down 1
    \\forward 4
    \\forward 2
    \\forward 3
    \\forward 2
    \\forward 5
    \\forward 2
    \\forward 7
    \\down 5
    \\forward 2
    \\forward 3
    \\forward 9
    \\down 3
    \\down 4
    \\down 7
    \\down 9
    \\down 5
    \\forward 5
    \\down 4
    \\down 8
    \\up 3
    \\forward 1
    \\forward 2
    \\forward 6
    \\up 2
    \\down 9
    \\down 8
    \\up 8
    \\up 3
    \\forward 2
    \\down 6
    \\forward 9
    \\down 3
    \\down 3
    \\forward 7
    \\down 5
    \\forward 2
    \\down 4
    \\down 1
    \\forward 1
    \\down 5
    \\up 4
    \\down 2
    \\forward 8
    \\down 9
    \\down 5
    \\up 4
    \\forward 9
    \\down 3
    \\down 8
    \\forward 8
    \\forward 9
    \\forward 3
    \\up 5
    \\forward 6
    \\down 7
    \\forward 5
    \\down 4
    \\down 9
    \\down 1
    \\up 4
    \\down 8
    \\forward 4
    \\up 4
    \\forward 4
    \\forward 8
    \\forward 3
    \\forward 6
    \\down 9
    \\forward 5
    \\up 4
    \\forward 8
    \\forward 2
    \\down 2
    \\down 1
    \\up 3
    \\forward 5
    \\down 3
    \\down 6
    \\forward 7
    \\down 8
    \\down 1
    \\forward 9
    \\down 8
    \\forward 7
    \\forward 7
    \\forward 7
    \\up 9
    \\up 5
    \\forward 5
    \\forward 2
    \\down 4
    \\up 8
    \\up 7
    \\forward 5
    \\forward 3
    \\forward 7
    \\up 1
    \\down 2
    \\up 1
    \\forward 3
    \\up 8
    \\down 3
    \\forward 1
    \\forward 5
    \\forward 2
    \\forward 5
    \\down 8
    \\up 1
    \\forward 9
    \\down 3
    \\down 7
    \\up 5
    \\down 5
    \\down 1
    \\down 4
    \\down 6
    \\up 9
    \\forward 5
    \\forward 3
    \\down 8
    \\down 7
    \\forward 3
    \\down 9
    \\forward 8
    \\down 3
    \\up 2
    \\up 7
    \\forward 3
    \\down 9
    \\down 5
    \\down 9
    \\up 6
    \\down 9
    \\down 1
    \\down 1
    \\up 4
    \\up 5
    \\up 6
    \\forward 5
    \\down 3
    \\up 1
    \\forward 9
    \\forward 8
    \\forward 8
    \\forward 3
    \\forward 5
    \\forward 8
    \\forward 1
    \\down 8
    \\up 7
    \\down 3
    \\forward 9
    \\forward 1
    \\up 8
    \\down 7
    \\up 4
    \\down 2
    \\down 5
    \\forward 3
    \\down 5
    \\forward 8
    \\forward 4
    \\down 6
    \\up 7
    \\up 7
    \\forward 8
    \\down 6
    \\down 8
    \\down 9
    \\forward 8
    \\forward 1
    \\forward 6
    \\up 2
    \\up 1
    \\up 8
    \\forward 8
    \\forward 1
    \\forward 4
    \\forward 7
    \\forward 2
    \\down 7
    \\down 8
    \\up 5
    \\up 4
    \\up 4
    \\up 7
    \\forward 3
    \\down 2
    \\up 5
    \\down 8
    \\forward 6
    \\up 9
    \\forward 1
    \\down 2
    \\forward 7
    \\down 4
    \\down 6
    \\down 3
    \\down 7
    \\down 9
    \\down 3
    \\forward 1
    \\forward 5
    \\down 2
    \\down 6
    \\up 7
    \\up 2
    \\up 3
    \\up 5
    \\forward 9
    \\down 6
    \\up 1
    \\down 1
    \\forward 3
    \\forward 5
    \\up 8
    \\forward 5
    \\forward 9
    \\up 5
    \\up 4
    \\down 6
    \\up 8
    \\down 8
    \\down 7
    \\down 2
    \\down 6
    \\up 1
    \\up 1
    \\forward 8
    \\down 4
    \\up 3
    \\down 2
    \\down 1
    \\forward 2
    \\down 4
    \\down 6
    \\forward 2
    \\up 8
    \\forward 9
    \\up 1
    \\up 4
    \\forward 2
    \\down 9
    \\down 4
    \\forward 7
    \\forward 6
    \\forward 2
    \\forward 2
    \\forward 5
    \\forward 6
    \\down 3
    \\forward 1
    \\up 9
    \\forward 2
    \\down 3
    \\down 1
    \\down 3
    \\up 9
    \\forward 5
    \\up 5
    \\up 7
    \\down 5
    \\down 4
    \\down 9
    \\down 3
    \\down 3
    \\down 9
    \\down 4
    \\down 3
    \\down 9
    \\forward 9
    \\down 1
    \\down 6
    \\down 7
    \\down 7
    \\down 5
    \\down 8
    \\down 5
    \\forward 1
    \\forward 3
    \\up 1
    \\forward 2
    \\up 5
    \\up 8
    \\down 1
    \\up 8
    \\up 6
    \\up 4
    \\up 1
    \\forward 3
    \\forward 2
    \\forward 4
    \\up 3
    \\down 6
    \\down 1
    \\down 6
    \\up 8
    \\up 7
    \\forward 8
    \\down 9
    \\down 3
    \\forward 2
    \\forward 8
    \\forward 8
    \\down 1
    \\forward 9
    \\down 2
    \\down 3
    \\down 9
    \\down 2
    \\forward 8
    \\down 2
    \\down 6
    \\forward 8
    \\forward 1
    \\up 1
    \\forward 3
    \\down 5
    \\down 6
    \\down 5
    \\down 4
    \\forward 6
    \\forward 3
    \\down 7
    \\down 8
    \\down 7
    \\up 7
    \\down 9
    \\down 8
    \\forward 6
    \\down 1
    \\forward 8
    \\forward 9
    \\up 4
    \\down 1
    \\forward 1
    \\forward 9
    \\down 4
    \\down 2
    \\forward 4
    \\down 5
    \\forward 4
    \\down 7
    \\forward 6
    \\down 3
    \\forward 3
    \\forward 2
    \\forward 7
    \\down 2
    \\forward 2
    \\down 3
    \\up 9
    \\forward 4
    \\forward 1
    \\forward 8
    \\forward 8
    \\forward 6
    \\forward 7
    \\up 8
    \\down 4
    \\up 6
    \\forward 3
    \\up 8
    \\forward 3
    \\forward 1
    \\forward 3
    \\forward 9
    \\up 2
    \\up 5
    \\forward 8
    \\forward 6
    \\forward 6
    \\forward 4
    \\down 6
    \\forward 7
    \\forward 3
    \\forward 2
    \\forward 2
    \\forward 6
    \\forward 5
    \\down 7
    \\up 1
    \\forward 5
    \\up 1
    \\up 9
    \\forward 5
    \\up 3
    \\forward 1
    \\down 2
    \\up 2
    \\down 4
    \\forward 7
    \\forward 4
    \\forward 1
    \\down 1
    \\up 4
    \\down 4
    \\up 2
    \\up 5
    \\down 5
    \\forward 7
    \\up 1
    \\down 6
    \\up 4
    \\forward 3
    \\forward 8
    \\down 6
    \\forward 4
    \\down 2
    \\down 3
    \\down 5
    \\down 4
    \\down 9
    \\up 4
    \\forward 5
    \\up 1
    \\up 2
    \\forward 7
    \\forward 2
    \\up 1
    \\down 8
    \\forward 4
    \\forward 4
    \\up 8
    \\down 3
    \\down 4
    \\up 7
    \\down 8
    \\down 6
    \\down 2
    \\down 3
    \\forward 9
    \\forward 7
    \\forward 6
    \\down 2
    \\down 7
    \\forward 5
    \\forward 2
    \\up 5
    \\down 5
    \\forward 5
    \\down 3
    \\down 1
    \\forward 4
    \\forward 3
    \\down 2
    \\up 1
    \\down 3
    \\down 5
    \\forward 6
    \\forward 5
    \\up 5
    \\down 3
    \\forward 8
    \\down 9
    \\up 4
    \\up 4
    \\down 8
    \\forward 5
    \\down 7
    \\down 3
    \\up 1
    \\down 4
    \\down 5
    \\forward 4
    \\forward 2
    \\forward 4
    \\up 9
    \\down 5
    \\forward 4
    \\forward 6
    \\forward 9
    \\forward 7
    \\forward 5
    \\forward 6
    \\up 4
    \\forward 8
    \\down 4
    \\forward 4
    \\forward 6
    \\up 8
    \\down 4
    \\forward 3
    \\down 8
    \\forward 4
    \\down 9
    \\forward 5
    \\down 4
    \\up 8
    \\forward 2
    \\down 6
    \\up 3
    \\down 5
    \\down 1
    \\down 6
    \\down 9
    \\forward 9
    \\down 1
    \\down 5
    \\up 8
    \\forward 5
    \\down 6
    \\down 9
    \\forward 1
    \\down 6
    \\down 8
    \\down 1
    \\down 2
    \\down 1
    \\forward 5
    \\up 7
    \\forward 5
    \\down 2
    \\down 4
    \\down 1
    \\forward 7
    \\down 7
    \\down 8
    \\forward 4
    \\forward 7
    \\down 2
    \\down 3
    \\forward 2
    \\up 9
    \\down 4
    \\down 5
    \\forward 4
    \\forward 4
    \\forward 6
    \\down 5
    \\forward 8
    \\down 9
    \\forward 8
    \\down 7
    \\up 7
    \\forward 9
    \\up 1
    \\forward 4
    \\up 3
    \\down 2
    \\down 4
    \\down 5
    \\forward 2
    \\forward 8
    \\up 3
    \\up 1
    \\down 1
    \\forward 7
    \\forward 9
    \\forward 6
    \\up 1
    \\down 2
    \\forward 1
    \\up 5
    \\forward 3
    \\down 7
    \\down 6
    \\forward 9
    \\forward 6
    \\forward 3
    \\forward 8
    \\down 2
    \\down 7
    \\forward 1
    \\down 6
    \\up 3
    \\down 6
    \\down 9
    \\up 2
    \\forward 8
    \\forward 1
    \\down 9
    \\forward 8
    \\forward 8
    \\down 3
    \\up 9
    \\down 6
    \\up 3
    \\forward 3
    \\forward 5
    \\forward 7
;

pub fn main() !void {
    try first_part();
    try second_part();
}

fn first_part() !void {
    var lines = std.mem.split(u8, data, "\n");

    var horizontal: u32 = 0;
    var depth: u32 = 0;
    while (lines.next()) |inst| {
        var a_inst = std.mem.split(u8, inst, " ");
        const direction = a_inst.next().?;
        const amount = a_inst.next().?;

        if (std.mem.eql(u8, direction, "forward")) {
            horizontal += try fmt.parseInt(u32, amount, 10);
        }

        if (std.mem.eql(u8, direction, "down")) {
            depth += try fmt.parseInt(u32, amount, 10);
        }

        if (std.mem.eql(u8, direction, "up")) {
            depth -= try fmt.parseInt(u32, amount, 10);
        }
    }

    print("First Part - Horizontal = {}, Depth = {}, Result = {} \n", .{ horizontal, depth, horizontal * depth });
}

fn second_part() !void {
    var lines = std.mem.split(u8, data, "\n");

    var horizontal: u32 = 0;
    var depth: u32 = 0;
    var aim: u32 = 0;
    while (lines.next()) |inst| {
        var a_inst = std.mem.split(u8, inst, " ");
        const direction = a_inst.next().?;
        const amount = a_inst.next().?;

        if (std.mem.eql(u8, direction, "forward")) {
            horizontal += try fmt.parseInt(u32, amount, 10);
            depth += aim * try fmt.parseInt(u32, amount, 10);
        }

        if (std.mem.eql(u8, direction, "down")) {
            aim += try fmt.parseInt(u32, amount, 10);
        }

        if (std.mem.eql(u8, direction, "up")) {
            aim -= try fmt.parseInt(u32, amount, 10);
        }
    }

    print("Second Part - Horizontal = {}, Depth = {}, Result = {} \n", .{ horizontal, depth, horizontal * depth });
}

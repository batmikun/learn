const std = @import("std");
const fs = std.fs;
const file = fs.File;
const stdout = std.debug;

pub fn main() !void {
    const dir = fs.cwd();
    const h_file = try dir.openFile("/Users/batmi/Personal/learn/zig/aoc/day_01/day_01.txt", .{ .mode = .read_only });
    defer h_file.close();

    // const buffer_size = try h_file.stat();
    var buffer: [660]u8 = undefined;
    _ = try h_file.read(&buffer);

    var lines = std.mem.split(u8, &buffer, "\n");

    // PART ONE
    var fuel: usize = 0;
    while (lines.next()) |line| {
        var mass = std.fmt.parseInt(usize, line, 10) catch break;
        mass = (mass / 3) - 2;
        fuel += mass;
    }
    stdout.print("Part One : {} \n", .{fuel});

    // PART TWO
    var sum2: usize = 0;
    var fuel_left = fuel;
    while (fuel_left > 6) : (fuel_left = (fuel_left / 3) - 2) {
        stdout.print("FUEL LEFT {} \n", .{fuel_left});
        sum2 += (fuel_left / 3) - 2;
    }
    stdout.print("Part Two : {} \n", .{sum2 + fuel});
}

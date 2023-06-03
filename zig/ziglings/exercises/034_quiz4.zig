//
// Quiz time. See if you can make this program work!
//
// Solve this any way you like, just be sure the output is:
//
//     my_num=42
//
const std = @import("std");

const NumError = error{IllegalNumber};

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    const my_num = getNumber(false);
    if (my_num) |n| {
        try stdout.print("my_num={}\n", .{n});
    } else |err| {
        try stdout.print("Err={}\n", .{err});
    }
}

// This function is obviously weird and non-functional. But you will not be changing it for this quiz.
fn getNumber(err: bool) NumError!u32 {
    if (err) return NumError.IllegalNumber;
    return 42;
}

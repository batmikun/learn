const std = @import("std");
const expect = @import("std").testing.expect;

// VARIABLES
// Value assignment has the following sintax:
// (const | var) identifier[: type] = value
//
// cosnt -> Inmutable Value
// var -> Mutable value
// : type may be omitted if the data type of value can be inferred
// Constants and variables must have a value. If no value is provided
// the undefined value, which coerces to any type, may be used as long
// as a type annotations is provided

pub fn variables() void {
    const constant: i32 = 5;
    _ = constant;
    var variable: u32 = 5000;
    _ = variable;

    const inferred_constant = @as(i32, 5);
    _ = inferred_constant;
    var inferred_variable = @as(u32, 5000);
    _ = inferred_variable;

    const a: i32 = undefined;
    _ = a;

    std.debug.print("Hello, {s}!\n", .{"World"});
}

// ARRAYS
// Are denoted by [N]T, where N is the number of elements
// and T is the type of thos elements.
//
// For array literals, N may be replaced by _ to infer the size of the array
// we can obtain the size of an array with the len function that can be called on arrays
pub fn arrays() void {
    const a = [5]u8{ 'h', 'b', 'h', 'a', 'r' };
    const b = [_]u8{ 'h', 'b', 'h', 'a', 'r' };
    _ = b;

    const lenght = a.len;
    _ = lenght;
}

// IF STATEMENT
// It only accepts a bool value. There is not concept of truthy or falsy values
// We can run test with zig test file-name.zig . Tests can be in the same file as the behavior
test "if statement" {
    const a = true;
    var x: u16 = 0;

    if (a) {
        x += 1;
    } else {
        x += 2;
    }

    try expect(x == 1);
}

test "if statement expression" {
    const a = true;
    var x: u16 = 0;

    x += if (a) 1 else 2;

    try expect(x == 1);
}

// While loop
// Three parts :
//          - Condtion
//          - block
//          - continue expression
test "while without continue expression" {
    var i: u8 = 2;
    while (i < 100) {
        i += 2;
    }

    try expect(i == 128);
}

test "while with a continue expression" {
    var sum: u8 = 0;
    var i: u8 = 1;

    while (i < 10) : (i += 1) {
        sum += i;
    }

    try expect(sum == 55);
}

test "while with continue or brea" {
    var sum: u8 = 0;
    var i: u8 = 1;

    while (i < 10) : (i += 1) {
        if (i == 2) continue;
        if (i != 2) break;

        sum += i;
    }

    try expect(sum == 55);
}

// FOR LOOP
// Used to iterate over arrays (and other types).
test "for" {
    const string = [_]u8{ 'a', 'b', 'c' };

    for (string, 0..) |character, index| {
        _ = character;
        _ = index;
    }

    for (string) |character| {
        _ = character;
    }

    for (string, 0..) |_, index| {
        _ = index;
    }

    for (string) |_| {}
}

// FUNCTIONS
// All fucntions arguemtns are immutable. If a copy is desired the user mus explicitily make one. Unlike variables which are snale_case, functions are camelCase.
fn addFive(x: u32) u32 {
    return x + 5;
}

test "functions" {
    const y = addFive(0);

    try expect(@TypeOf(y) == 32);
    try expect(y == 5);
}

// Recursion is allowed, when this happens the compiler is no longer able to work out the maximun stack size. This may result in unsafe behaviour - a stack overflow.
fn fibonacci(n: u16) u16 {
    if (n == 0 or n == 1) return n;

    return fibonacci(n - 1) + fibonacci(n - 2);
}

test "function recursion" {
    const x = fibonacci(10);
    try expect(x == 55);
}

// Values can be ignored by using _ in place of a variable or const declaration. This does not work at the global scope, and is useful for ignoring the values returned from functions if you do not need them
fn ignore_value() void {
    _ = fibonacci(10);
}

// Defer statement. Is used to execute a statement while exiting the curren block
// When there are multiple defers in a single block they are executed in reverse order
test "defer" {
    var x: i16 = 5;
    {
        defer x += 2; // This second
        defer x /= 2; // This executes first
        try expect(x == 5);
    }

    try expect(x == 7);
}

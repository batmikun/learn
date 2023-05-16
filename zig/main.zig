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

    for (string) |_| {}

    for (string) |character| {
        _ = character;
    }

    for (string) |_, index| {
        _ = index;
    }

    for (string) |character, index| {
        _ = character;
        _ = index;
    }
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

// ERRORS
// An error set is like an enum, where each error in the set is a value. There are no exceptions in Zig: errors are values.
const FileOpenError = error{ AccesDenied, OutOfMemory, FileNotFound };

// Error sets coerce to their supersets.
const AllocationError = error{OutOfMemory};

test "coerce error from a subset to a superset" {
    const err: FileOpenError = AllocationError.OutOfMemory;
    try expect(err == FileOpenError.OutOfMemory);
}

// An error set type and a normal type can be combined with the ! operator to form and error union type. Values of these types may be an error value, or a value of the normal type.
test "error union" {
    const maybe_error: AllocationError!u16 = 10;
    const no_error = maybe_error catch 0;

    try expect(@TypeOf(no_error) == u16);
    try expect(no_error == 10);
}

// Functions often return error unions. Here's one using a catach, where the |err| syntax receives the value of the error. This is called payload capturing, and is used similarly in many places.
fn failingFunction() error{Oops}!void {
    return error.Oops;
}

test "returning an error" {
    failingFunction() catch |err| {
        try expect(err == error.Oops);
        return;
    };
}

// try x is a shortcut for x catch |err| return err, and is commonly used in places where handling an error isn't apporpiate.
fn failFn() error{Oops}!i32 {
    try failingFunction();
    return 12;
}

test "try" {
    var v = failFn() catch |err| {
        try expect(err == error.Oops);
        return;
    };

    try expect(v == 12);
}

// errdefer works like defer, but only executing when the function is returned from with an error inside of the errdefers block
var problems: u32 = 98;

fn failFnCounter() error{Oops}!void {
    errdefer problems += 1;
    try failingFunction();
}

test "errdefer" {
    failFnCounter() catch |err| {
        try expect(err == error.Oops);
        try expect(problems == 99);
    };
}

// Error unions returned from a function can have their error sets inferred by not having an explicit error set. This inferred error set contains all possible errors which the function may return
fn createFile() !void {
    return error.AccessDenied;
}

test "inferred error set" {
    //type coercion successfully takes place
    const x: error{AccessDenied}!void = createFile();

    //Zig does not let us ignore error unions via _ = x;
    //we must unwrap it with "try", "catch", or "if" by any means
    _ = x catch {};
}

// Error sets can be merged.
const A = error{ NorDir, PathNotFound };
const B = error{ OutOfMemory, PathNotFound };
const C = A || B;

// anyerror is the global error set which due to being the superset of all error sets, can have an error from any set coerce to a value of it, Its usage should be generally avoided.

// SWITCH
// Works as both a statement and an epxression. The types of all branches must coerce to the type which is being switched upon. All possible values must have an associated branch - values cannot be left out. Cases cannot fall thruogh to other branches
test "switch statement" {
    var x: i8 = 10;
    switch (x) {
        -1...1 => {
            x = -x;
        },
    }
}

test "switch expression" {
    var x: i8 = 10;
    x = switch (x) {
        -1...1 => -x,
        10, 100 => @divExact(x, 10),
        else => x,
    };
    try expect(x == 1);
}

//RUNTIME SATEFY
// Zig provides a level of safety, where problems may be found during execution. Safety can be left on, or turned off. Zig has many cases of so-called detectable illegal behaviour, meaning that illegal beahviour with safety on. Users are strongly recommended to develop and test their software with safety on, despite its speed penalties.

// For example, runtime safety protects you from out of bounds indices.
test "out of bounds" {
    const a = [3]u8{ 1, 2, 3 };
    var index: u8 = 5;
    const b = a[index];
    _ = b;
}

// test "out of bounds"...index out of bounds
//.\tests.zig:43:14: 0x7ff698cc1b82 in test "out of bounds" (test.obj)
//    const b = a[index];

// The user may choose to disable runtime safety for the current block by using the built-in function @setRuntimeSafety
test "out of bounds, no safety" {
    @setRuntimeSafety(false);
    const a = [3]u8{ 1, 2, 3 };
    var index: u8 = 5;
    const b = a[index];
    _ = b;
}

// UNREACHABLE
// Is an assertion to the compiler that this statement will not be reached. It can be used to tell the compiler that a branch is impossible, which the optimiser can then take advantage of. Reaching an unrecheable is detectable illegal behaviour.

// As it is of the type noreturn, it is compatible with all other types. Here it coerces to u32
test "unrecheable" {
    const x: i32 = 1;
    const y: u32 = if (x == 2) 5 else unreachable;
    _ = y;
}

// test "unreachable"...reached unreachable code
//.\tests.zig:211:39: 0x7ff7e29b2049 in test "unreachable" (test.obj)
//    const y: u32 = if (x == 2) 5 else unreachable;
fn asciiToUpper(x: u8) u8 {
    return switch (x) {
        'a'...'z' => x + 'A' - 'a',
        'A'...'Z' => x,
        else => unreachable,
    };
}

test "unreachable switch" {
    try expect(asciiToUpper('a') == 'A');
    try expect(asciiToUpper('A') == 'A');
}

// POINTERS
// Normal pointers in Zig aren't allowed to have 0 or null as a value. They follow the syntax *T, where T is the child type.
// Referencing is done with &variable, and dereferencing is done with variable.*

fn increment(num: *u8) void {
    num.* += 1;
}

test "pointers" {
    var x: u8 = 1;
    increment(&x);
    try expect(x == 2);
}

// Trying to set a *T to the value 0 is detectable ilegal behaviour
test "naughty pointer" {
    var x: u16 = 0;
    var y: *u8 = @intToPtr(*u8, x);
    _ = y;
}
//test "naughty pointer"...cast causes pointer to be null
//.\tests.zig:241:18: 0x7ff69ebb22bd in test "naughty pointer" (test.obj)
//    var y: *u8 = @intToPtr(*u8, x);

// Zig also has const pointers, which cannot be used to modify the referenced data.
// Referencing a const variable will yiled a const pointer.
test "const pointer" {
    const x: u8 = 1;
    var y = &x;
    y.* += 1;
}
//error: cannot assign to constant
//    y.* += 1;

// POINTER SIZED INTEGERS
// usize and isezi are given as unsigned and signed integers which are the same size as pointers
test "usize" {
    try expect(@sizeOf(usize) == @sizeOf(*u8));
    try expect(@sizeOf(isize) == @sizeOf(*u8));
}

// MANY ITEM POINTERS
// Sometimes you may have a pointer to an unknown amount of elements. [*]T is the solution for this, which works like *T but also supports indexing syntax, pointer arithmetic, and slicing. Unlike *T, it cannot point to a type which does not have a know size. *T coerces yo [*]T

// SLICES
// Can be thought of as a pair of [*]T (the pointer to the data) and a usize (the element count). Their syntax is given as []T, with T beign the child type. Slices are used heavily throughout Zig for when you need to operate on arbitray amounts of data. Slices have the same attributes as pointers, meaning that there also exists const slices. For loops also operate over slices. String literals in Zig coerce to []const u8.
// Here the syntax x[m..n] is used to create a slice from an array. This is called slicing, and creates a slice of the elements starting at x[n] and ending at x[m-1]. This example uses a const slice as the values which the slice points to do not need to be modified.
fn total(values: []const u8) usize {
    var sum: usize = 0;
    for (values) |v| sum += v;
    return sum;
}

test "slices" {
    const array = [_]u8{ 1, 2, 3, 4, 5 };
    const slice = array[0..3];

    try expect(total(slice) == 6);
}

// When the n and m values are both known at compile time, slicing will actually produce a pointer to an array. This is not an issue as a pointer to an array *[N]T will coerce to a []T
test "slices 2" {
    var array = [_]u8{ 1, 2, 3, 4, 5 };
    var slice = array[0..];
    _ = slice;
}

// Types that may be sliced are: arrays. many pointers and slices.

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

    for (string, 0..) |_, index| {
        _ = index;
    }

    for (string, 0..) |character, index| {
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

// POINTERS MUTABILITY
// The tricky part is that the pointer's mutability (var vs const) refers
// to the ability to change what the pointer POINTS TO, not the ability
// to change the VALUE at that location!
//
//     const locked: u8 = 5;
//     var unlocked: u8 = 10;
//
//     const p1: *const u8 = &locked;
//     var   p2: *const u8 = &locked;
//
// Both p1 and p2 point to constant values which cannot change. However,
// p2 can be changed to point to something else and p1 cannot!
//
//     const p3: *u8 = &unlocked;
//     var   p4: *u8 = &unlocked;
//     const p5: *const u8 = &unlocked;
//     var   p6: *const u8 = &unlocked;
//
// Here p3 and p4 can both be used to change the value they point to but
// p3 cannot point at anything else.
// What's interesting is that p5 and p6 act like p1 and p2, but point to
// the value at "unlocked". This is what we mean when we say that we can
// make a constant reference to any value!

// POINTER SIZED INTEGERS
// usize and isezi are given as unsigned and signed integers which are the same size as pointers
test "usize" {
    try expect(@sizeOf(usize) == @sizeOf(*u8));
    try expect(@sizeOf(isize) == @sizeOf(*u8));
}

// MANY ITEM POINTERS
// Sometimes you may have a pointer to an unknown amount of elements. [*]T is the solution for this, which works like *T but also supports indexing syntax, pointer arithmetic, and slicing. Unlike *T, it cannot point to a type which does not have a know size. *T coerces yo [*]T

//
// You can also make pointers to multiple items without using a slice.
//
//     var foo: [4]u8 = [4]u8{ 1, 2, 3, 4 };
//     var foo_slice: []u8 = foo[0..];
//     var foo_ptr: [*]u8 = &foo;
//
// The difference between foo_slice and foo_ptr is that the slice has
// a known length. The pointer doesn't. It is up to YOU to keep track
// of the number of u8s foo_ptr points to!
//
pub fn manyItemPointer() void {
    // Take a good look at the array type to which we're coercing
    // the zen12 string (the REAL nature of strings will be
    // revealed when we've learned some additional features):
    const zen12: *const [21]u8 = "Memory is a resource.";
    //
    //   It would also have been valid to coerce to a slice:
    //         const zen12: []const u8 = "...";
    //
    // Now let's turn this into a "many-item pointer":
    const zen_manyptr: [*]const u8 = zen12;

    // It's okay to access zen_manyptr just like an array or slice as
    // long as you keep track of the length yourself!
    //
    // A "string" in Zig is a pointer to an array of const u8 values
    // (or a slice of const u8 values, as we saw above). So, we could
    // treat a "many-item pointer" of const u8 as a string as long as
    // we can CONVERT IT TO A SLICE. (Hint: we do know the length!)
    //
    // Please fix this line so the print statement below can print it:
    const zen12_string: []const u8 = zen_manyptr[0..21];

    // Here's the moment of truth!
    std.debug.print("{s}\n", .{zen12_string});
}
//
// Are all of these pointer types starting to get confusing?
//
//     FREE ZIG POINTER CHEATSHEET! (Using u8 as the example type.)
//   +---------------+----------------------------------------------+
//   |  u8           |  one u8                                      |
//   |  *u8          |  pointer to one u8                           |
//   |  [2]u8        |  two u8s                                     |
//   |  [*]u8        |  pointer to unknown number of u8s            |
//   |  [*]const u8  |  pointer to unknown number of immutable u8s  |
//   |  *[2]u8       |  pointer to an array of 2 u8s                |
//   |  *const [2]u8 |  pointer to an immutable array of 2 u8s      |
//   |  []u8         |  slice of u8s                                |
//   |  []const u8   |  slice of immutable u8s                      |
//   +---------------+----------------------------------------------+

// SLICES
// RIGHT BOUNDARIE IS NOT INCLUSIVE
// We've seen that passing arrays around can be awkward. Perhaps you
// remember a particularly horrendous function definition from quiz3?
// This function can only take arrays that are exactly 4 items long!
//
//     fn printPowersOfTwo(numbers: [4]u16) void { ... }
//
// That's the trouble with arrays - their size is part of the data
// type and must be hard-coded into every usage of that type. This
// digits array is a [10]u8 forever and ever:
//
//     var digits = [10]u8{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };
//
// Thankfully, Zig has slices, which let you dynamically point to a
// start item and provide a length. Here are slices of our digit
// array:
//
//     const foo = digits[0..1];  // 0
//     const bar = digits[3..9];  // 3 4 5 6 7 8
//     const baz = digits[5..9];  // 5 6 7 8
//     const all = digits[0..];   // 0 1 2 3 4 5 6 7 8 9
//
// As you can see, a slice [x..y] starts with the index of the
// first item at x and the last item at y-1. You can leave the y
// off to get "the rest of the items".
//
// The type of a slice on an array of u8 items is []u8.

// You are perhaps tempted to try slices on strings? They're arrays of
// u8 characters after all, right? Slices on strings work great.
// There's just one catch: don't forget that Zig string literals are
// immutable (const) values. So we need to change the type of slice
// from:
//
//     var foo: []u8 = "foobar"[0..3];
//
// to:
//
//     var foo: []const u8 = "foobar"[0..3];

// Slice of pointer must include end value

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

// ENUMS
// Zigs enums allow you to define types which have a restricted set of named values
const Direction = enum { north, south, east, west };

// Enums types may have specified (intefer) tag types
const Value = enum(u2) { zero, one, two };

// Enums ordinals values start at 0. They can be accessed with the buil-in function
// @enumToInt
test "enum ordinal value" {
    try expect(@enumToInt(Value.zero) == 0);
    try expect(@enumToInt(Value.one) == 1);
    try expect(@enumToInt(Value.two) == 2);
}

// Values can be overridden, with the next values continuing from there
const Value2 = enum(u32) {
    hundred = 100,
    thousand = 1000,
    million = 1000000,
    next,
};

test "set enum ordinal value" {
    try expect(@enumToInt(Value2.hundred) == 100);
    try expect(@enumToInt(Value2.thousand) == 1000);
    try expect(@enumToInt(Value2.million) == 1000000);
    try expect(@enumToInt(Value2.next) == 1000001);
}

// Methods can be given to enums. These act as namespaced functions that can be called with dot syntax
const Suit = enum {
    clubs,
    spades,
    diamonds,
    hearts,
    pub fn isClubs(self: Suit) bool {
        return self == Suit.clubs;
    }
};

test "enum method" {
    try expect(Suit.spades.isClubs() == Suit.isClubs(.spades));
}

// Enums can aslo be given var and const declarations. These act as namespaced globals, and their values are unrelated and unattached to instances of the enum type
const Mode = enum {
    var count: u32 = 0;
    on,
    off,
};

test "hmm" {
    Mode.count += 1;
    try expect(Mode.count == 1);
}

// SOMETHING ON ARRAYS AND LOOPS
// If you tried to loop over an array that has size 2 but has one item inside you get what appear to be "garbage" values. In debug mode (which is the default), Zig writes the repeating pattern "10101010" in binary (or 0xAA in hex) to all undefined locations to make them easier to spot when debugging.
test "array undefined location" {
    var arr = [2]u32{};

    arr[0] = 1;

    for (arr) |value| {
        std.debug.print("Number = {d}", .{value});
    }
}
// First loop will print:
// Number = 1
// Second loop will print:
// Number = 2863311530 = 10101010

// STRUCTS
// Most common kind of composite data type, allowing you to define types that can store a fixed set of named fields. Zig gives no guarantees about the inmemory order of fileds in a struct, or its size. Like arrays, structs are also neatly constructed with T{} syntax. Here is an example of declaring and filling a struct.
const Vec3 = struct { x: f32, y: f32, z: f32 };

test "struct usage" {
    const my_vector = Vec3{
        .x = 0,
        .y = 100,
        .z = 50,
    };

    _ = my_vector;
}

// All fields must be given a value.
test "missing struct field" {
    const my_vector = Vec3{
        .x = 0,
        .z = 50,
    };
    _ = my_vector;
}
// error: missing field: 'y'
//    const my_vector = Vec3{

// Fields may be given defaults:
const Vec4 = struct { x: f32, y: f32, z: f32 = 0, w: f32 = undefined };

test "struct defaults" {
    const my_vector = Vec4{
        .x = 25,
        .y = -50,
    };
    _ = my_vector;
}

// Like enums, structs may also contain functions and declarations.

// Structs have the unique property that when given a pointer to a struct, one level of dereferencing is done automatically when accessing fields. Notice how in this example, self.x and self.y are accessed in the swap functions without needing to dereference the self pointer
const Stuff = struct {
    x: i32,
    y: i32,
    fn swap(self: *Stuff) void {
        const tmp = self.x;
        self.x = self.y;
        self.y = tmp;
    }
};

test "automati dereference" {
    var thing = Stuff{ .x = 10, .y = 20 };
    thing.swap();
    try expect(thing.x == 20);
    try expect(thing.y == 10);
}

// 1. You can attach functions to structs (and other "type definitions"):
//
//     const Foo = struct{
//         pub fn hello() void {
//             std.debug.print("Foo says hello!\n", .{});
//         }
//     };
//
// 2. A function that is a member of a struct is "namespaced" within
//    that struct and is called by specifying the "namespace" and then
//    using the "dot syntax":
//
//     Foo.hello();
//
// 3. The NEAT feature of these functions is that if their first argument
//    is an instance of the struct (or a pointer to one) then we can use
//    the instance as the namespace instead of the type:
//
//     const Bar = struct{
//         pub fn a(self: Bar) void {}
//         pub fn b(this: *Bar, other: u8) void {}
//         pub fn c(bar: *const Bar) void {}
//     };
//
//    var bar = Bar{};
//    bar.a() // is equivalent to Bar.a(bar)
//    bar.b(3) // is equivalent to Bar.b(&bar, 3)
//    bar.c() // is equivalent to Bar.c(&bar)
//
//    Notice that the name of the parameter doesn't matter. Some use
//    self, others use a lowercase version of the type name, but feel
//    free to use whatever is most appropriate.

// UNIONS
// Allow you to define types which store one value of many possible typed fields; only one field may be active at one time
// Bare union types do not have a guaranteed memory layour. Because of this, bare unions cannot be used to reinterpret memory. Accessing a field in a union which is not active is detectable illegal behaviour.
const Result = union {
    int: i64,
    float: f64,
    bool: bool,
};

test "simple union" {
    var result = Result{ .int = 1234 };
    result.float = 12.34;
}
//test "simple union"...access of inactive union field
//.\tests.zig:342:12: 0x7ff62c89244a in test "simple union" (test.obj)
//    result.float = 12.34;

// A union lets you store different types and sizes of data at
// the same memory address. How is this possible? The compiler
// sets aside enough memory for the largest thing you might want
// to store.
//     const Foo = union {
//         small: u8,
//         medium: u32,
//         large: u64,
//     };
//
// The syntax looks just like a struct, but a Foo can only hold a
// small OR a medium OR a large value. Once a field becomes
// active, the other inactive fields cannot be accessed. To
// change active fields, assign a whole new instance:
//
//     var f = Foo{ .small = 5 };
//     f.small += 5;                  // OKAY
//     f.medium = 5432;               // ERROR!
//     f = Foo{ .medium = 5432 };     // OKAY

// Unions can save space in memory because they let you "re-use"
// a space in memory. They also provide a sort of primitive
// polymorphism. Here fooBar() can take a Foo no matter what size
// of unsigned integer it holds:
//
//     fn fooBar(f: Foo) void { ... }
//
// Oh, but how does fooBar() know which field is active? Zig has
// a neat way of keeping track, but for now, we'll just have to
// do it manually.
//
// Let's see if we can get this program working!
//

// We've just started writing a simple ecosystem simulation.
// Insects will be represented by either bees or ants. Bees store
// the number of flowers they've visited that day and ants just
// store whether or not they're still alive.
const Insect = union {
    flowers_visited: u16,
    still_alive: bool,
};

// Since we need to specify the type of insect, we'll use an
// enum (remember those?).
const AntOrBee = enum { a, b };

pub fn unions() void {
    // We'll just make one bee and one ant to test them out:
    var ant = Insect{ .still_alive = true };
    var bee = Insect{ .flowers_visited = 15 };

    std.debug.print("Insect report! ", .{});

    // Oops! We've made a mistake here.
    printInsect(ant, AntOrBee.a);
    printInsect(bee, AntOrBee.b);

    std.debug.print("\n", .{});
}

// Eccentric Doctor Zoraptera says that we can only use one
// function to print our insects. Doctor Z is small and sometimes
// inscrutable but we do not question her.
fn printInsect(insect: Insect, what_it_is: AntOrBee) void {
    switch (what_it_is) {
        .a => std.debug.print("Ant alive is: {}. ", .{insect.still_alive}),
        .b => std.debug.print("Bee visited {} flowers. ", .{insect.flowers_visited}),
    }
}

// It is really quite inconvenient having to manually keep track
// of the active field in our union, isn't it?

// Thankfully, Zig also has "tagged unions", which allow us to
// store an enum value within our union representing which field
// is active.

//     const FooTag = enum{ small, medium, large };
//
//     const Foo = union(FooTag) {
//         small: u8,
//         medium: u32,
//         large: u64,
//     };

// Now we can use a switch directly on the union to act on the
// active field:
//
//     var f = Foo{ .small = 10 };
//
//     switch (f) {
//         .small => |my_small| do_something(my_small),
//         .medium => |my_medium| do_something(my_medium),
//         .large => |my_large| do_something(my_large),
//     }

const InsectStat = enum { flowers_visited, still_alive };

const Insect2 = union(InsectStat) {
    flowers_visited: u16,
    still_alive: bool,
};

pub fn insect2() void {
    var ant = Insect{ .still_alive = true };
    var bee = Insect{ .flowers_visited = 16 };

    std.debug.print("Insect report! ", .{});

    // Could it really be as simple as just passing the union?
    printInsect2(ant);
    printInsect2(bee);

    std.debug.print("\n", .{});
}

fn printInsect2(insect: Insect2) void {
    switch (insect) {
        .still_alive => |a| std.debug.print("Ant alive is: {}. ", .{a}),
        .flowers_visited => |f| std.debug.print("Bee visited {} flowers. ", .{f}),
    }
}

// By the way, did unions remind you of optional values and errors?
// Optional values are basically "null unions" and errors use "error
// union types". Now we can add our own unions to the mix to handle
// whatever situations we might encounter:
//          union(Tag) { value: u32, toxic_ooze: void }

// With tagged unions, it gets EVEN BETTER! If you don't have a
// need for a separate enum, you can define an inferred enum with
// your union all in one place. Just use the 'enum' keyword in
// place of the tag type:
//
//     const Foo = union(enum) {
//         small: u8,
//         medium: u32,
//         large: u64,
//     };
//
// Let's convert Insect. Doctor Zoraptera has already deleted the
// explicit InsectStat enum for you!

const Insect3 = union(enum) {
    flowers_visited: u16,
    still_alive: bool,
};

pub fn insect3() void {
    var ant = Insect3{ .still_alive = true };
    var bee = Insect3{ .flowers_visited = 17 };

    std.debug.print("Insect report! ", .{});

    printInsect3(ant);
    printInsect3(bee);

    std.debug.print("\n", .{});
}

fn printInsect3(insect: Insect3) void {
    switch (insect) {
        .still_alive => |a| std.debug.print("Ant alive is: {}. ", .{a}),
        .flowers_visited => |f| std.debug.print("Bee visited {} flowers. ", .{f}),
    }
}

// Inferred enums are neat, representing the tip of the iceberg
// in the relationship between enums and unions. You can actually
// coerce a union TO an enum (which gives you the active field
// from the union as an enum). What's even wilder is that you can
// coerce an enum to a union! But don't get too excited, that
// only works when the union type is one of those weird zero-bit
// types like void!
//
// Tagged unions, as with most ideas in computer science, have a
// long history going back to the 1960s. However, they're only
// recently becoming mainstream, particularly in system-level
// programming languages. You might have also seen them called
// "variants", "sum types", or even "enums"!

// Tagged unions are unions which use an enum to detect which field is active. Here we make us of payload capturing again, to switch on the tag type of a union while also capturing the value it conatis. Here we use a pointer capture; captured values are immutable, but whit the |*value| syntax we can capture a pointer to the values instead of the values themselves. This allows us to use dereferencing to mutate the original value.
const Tag = enum { a, b, c };
const Tagged = union(Tag) { a: u8, b: f32, c: bool };

test "switch on tagged union" {
    var value = Tagged{ .b = 1.5 };
    switch (value) {
        .a => |*byte| byte.* += 1,
        .b => |*float| float.* *= 2,
        .c => |*b| b.* = !b.*,
    }
}

//The tag type of a tagged union can also be inferred. This is equivalent to the Tagged type above.
const Tagged2 = union(enum) { a: u8, b: f32, c: bool };

//void member types can have their type omitted from the syntax. Here, none is of type void.
const Tagged3 = union(enum) { a: u8, b: f32, c: bool, none };

// INTEGER RULES
// Supports hex, octal and binary integer literals.

const decimal_int: i32 = 98222;
const hex_int: u8 = 0xff;
const another_hex_int: u8 = 0xFF;
const octal_int: u16 = 0o755;
const binary_int: u8 = 0b11110000;

// Underscores may also be placed between digits as a visual separator
const one_billion: u64 = 1_000_000_000;
const binary_mask: u64 = 0b1_1111_1111;
const permissions: u64 = 0o7_5_5;
const big_address: u64 = 0xFF80_0000_0000_0000;

// "Integer widening" is allowed, which means that integers of a type may coerce to an integer of another type, providing that the new type can fir all of the values that the old type can
test "integer widening" {
    const a: u8 = 250;
    const b: u16 = a;
    const c: u32 = b;
    try expect(c == a);
}

// If you have a value stored in an integer that cannot coerce to the type you want, @intCast may be used to explicitly convert from one type to the other. If the value given is out of the range of the destination type, this is detectable illegal behaviour.
test "@intCast" {
    const x: u64 = 200;
    const y = @intCast(u8, x);
    try expect(@TypeOf(y) == u8);
}

// Integers by default are not allowed to overflow. Overflows are detectable illegal behaviour. Sometimes being able to overflow integers in a well defined manner is wanted behaviour. For this use case, Zig provides overflow operators.

// Normal Operator	Wrapping Operator
//       +	                +%
//       -	                -%
//       *	                *%
//       +=	                +%=
//       -=	                -%=
//       *=	                *%=
test "well defined overflow" {
    var a: u8 = 255;
    a +%= 1;
    try expect(a == 0);
}

// FLOATS
// Are strictly IEEE compliant unless @setFloatMode(.Optimized) is used, which is equivalent to GCC’s -ffast-math. Floats coerce to larger float types.
test "float widening" {
    const a: f16 = 0;
    const b: f32 = a;
    const c: f128 = b;
    try expect(c == @as(f128, a));
}

// Floats support multiple kinds of literal
const floating_point: f64 = 123.0E+77;
const another_float: f64 = 123.0;
const yet_another: f64 = 123.0e+77;

const hex_floating_point: f64 = 0x103.70p-5;
const another_hex_float: f64 = 0x103.70;
const yet_another_hex_float: f64 = 0x103.70P-5;

//Underscores may also be placed between digits.
const lightspeed: f64 = 299_792_458.000_000;
const nanosecond: f64 = 0.000_000_001;
const more_hex: f64 = 0x1234_5678.9ABC_CDEFp-10;

// Integers and floats may be converted using the built-in functions @intToFloat and @floatToInt. @intToFloat is always safe, whereas @floatToInt is detectable illegal behaviour if the float value cannot fit in the integer destination type.
test "int-float conversion" {
    const a: i32 = 0;
    const b = @intToFloat(f32, a);
    const c = @floatToInt(i32, b);
    try expect(c == a);
}

// LABELLED BLOCKS
// Blocks in Zig are expressions and acn be given labels, which are used to yield values. Here, we are using a label called blk. Blocks yield values, meaning that they can be used in place of a value. The value of an empty block {} is a value of the type void.

test "labelled blocks" {
    const count = blk: {
        var sum: u32 = 0;
        var i: u32 = 0;
        while (i < 10) : (i += 1) sum += 1;
        break :blk sum;
    };

    try expect(count == 45);
    try expect(@TypeOf(count) == u32);
}

// LABELLED LOOPS
// Loops can be given labels, allowing you to break and continue to outer loops.
test "nested continue" {
    var count: usize = 0;
    outer: for ([_]i32{ 1, 2, 3, 4, 5, 6, 7, 8 }) |_| {
        for ([_]i32{ 1, 2, 3, 4, 5 }) |_| {
            count += 1;
            continue :outer;
        }
    }
    try expect(count == 8);
}

// LOOPS AS EXPRESSIONS
// Like return, break accepts a value. This can be used to yield a value from a loop. Loops in Zig also have an else branch on loops, which is evaluated when the loop is not exited from with a break.

fn rangeHasNumber(begin: usize, end: usize, number: usize) bool {
    var i = begin;
    return while (i < end) : (i += 1) {
        if (i == number) {
            break true;
        }
    } else false;
}

test "while loop expression" {
    try expect(rangeHasNumber(0, 10, 3));
}

// OPTIONALS
// Use the syntax ?T and are used to store the data null, or a value of type T.
test "optional" {
    var found_index: ?usize = null;
    const data = [_]i32{ 1, 2, 3, 4, 5, 6, 7, 8, 12 };
    for (data, 0..) |v, i| {
        if (v == 10) found_index = i;
    }

    try expect(found_index == null);
}

// Optionals support the orelse expression, which acts when the optional is null. This unwraps the optional to its child type.
test "orelse" {
    var a: ?f32 = null;
    var b = a orelse 0;
    try expect(b == 0);
    try expect(@TypeOf(b) == f32);
}

// .? is a shorthand for orelse unreachable. This is used for when you know it is impossible for an optional value to be null, and using this to unwrap a null value is detectable illegal behaviour
test "orelse unrecheable" {
    const a: ?f32 = 5;
    const b = a orelse unreachable;
    const c = a.?;
    try expect(b == c);
    try expect(@TypeOf(c) == f32);
}

// Payload capturing works in many places for optionals, meaning that in the event that it is non-null we can “capture” its non-null value.

// Here we use an if optional payload capture; a and b are equivalent here. if (b) |value| captures the value of b (in the cases where b is not null), and makes it available as value. As in the union example, the captured value is immutable, but we can still use a pointer capture to modify the value stored in b.
test "if optional payload capture" {
    const a: ?i32 = 5;
    if (a != null) {
        const value = a.?;
        _ = value;
    }

    var b: ?i32 = 5;
    if (b) |*value| {
        value.* += 1;
    }

    try expect(b.? == 6);
}

// And with while:
var numbers_left: u32 = 4;
fn eventuallyNullSequence() ?u32 {
    if (numbers_left == 0) return null;
    numbers_left -= 1;
    return numbers_left;
}

test "while null capture" {
    var sum: u32 = 0;
    while (eventuallyNullSequence()) |value| {
        sum += value;
    }
    try expect(sum == 6); // 3 + 2 + 1
}

// Optionals are a lot like error union types which can either
// hold a value or an error. Likewise, the orelse statement is
// like the catch statement used to "unwrap" a value or supply
// a default value:
//
//    var maybe_bad: Error!u32 = Error.Evil;
//    var number: u32 = maybe_bad catch 0;

// Optional pointer and optional slice types do not take up any extra memory, compared to non-optional ones. This is because internally they use the 0 value of the pointer for null.

// This is how null pointers in Zig work - they must be unwrapped to a non-optional before dereferencing, which stops null pointer dereferences from happening accidentally.

// COMPTIME
// Blocks of code may be forcibly executed at compile time using the comptime keyword
test "comptime bloacks" {
    var x = comptime fibonacci(10);
    _ = x;

    var y = comptime blk: {
        break :blk fibonacci(10);
    };
    _ = y;
}

// Integer literals are of the type comptime_int. These are special in that they have no size (they cannot be used at runtime) and they have arbitrary precision. comptime_int values coerce to any integer type that can hold them. They also coerce to floats.
// Characters literals are of this type
test "comptime_int" {
    const a = 12;
    const b = a + 10;

    const c: u4 = a;
    _ = c;

    const d: f32 = b;
    _ = d;
}

// comptime_float is also available, which internally is an f128. These cannot be coerced to integers, even if they hold an integer value.

// Types in Zig are values of the type type. These are available at compile time. We have previously encountered them by checking @TypeOf and comparing with other types, but we can do more.
test "branching on types" {
    const a = 5;
    const b: if (a < 10) f32 else i32 = 5;
    _ = b;
}

// Function parameters in Zig can be tagged as being comptime. This means that the value passed to that function parameter must be known at compile time. Let’s make a function that returns a type. Notice how this function is PascalCase, as it returns a type.
fn Matrix(
    comptime T: type,
    comptime width: comptime_int,
    comptime height: comptime_int,
) type {
    return [height][width]T;
}

test "returning a type" {
    try expect(Matrix(f32, 4, 4) == [4][4]f32);
}

// We can reflect upon types using the built-in @typeInfo, which takes in a type and returns a tagged union. This tagged union type can be found in std.builtin.TypeInfo (info on how to make use of imports and std later).
fn addSmallInts(comptime T: type, a: T, b: T) T {
    return switch (@typeInfo(T)) {
        .ComptimeInt => a + b,
        .Int => |info| if (info.bits <= 16)
            a + b
        else
            @compileError("ints too large"),
        else => @compileError("only ints accepted"),
    };
}

test "typeinfo switch" {
    const x = addSmallInts(u16, 20, 30);
    try expect(@TypeOf(x) == u16);
    try expect(x == 50);
}

// We can use the @Type function to create a type from a @typeInfo. @Type is implemented for most types but is notably unimplemented for enums, unions, functions, and structs.

// Here anonymous struct syntax is used with .{}, because the T in T{} can be inferred. Anonymous structs will be covered in detail later. In this example we will get a compile error if the Int tag isn’t set.
fn GetBiggerInt(comptime T: type) type {
    return @Type(.{
        .Int = .{
            .bits = @typeInfo(T).Int.bits + 1,
            .signedness = @typeInfo(T).Int.signedness,
        },
    });
}

test "@Type" {
    try expect(GetBiggerInt(u8) == u9);
    try expect(GetBiggerInt(i31) == i32);
}

// Returning a struct type is how you make generic data structures in Zig. The usage of @This is required here, which gets the type of the innermost struct, union, or enum. Here std.mem.eql is also used which compares two slices.
fn Vec(
    comptime count: comptime_int,
    comptime T: type,
) type {
    return struct {
        data: [count]T,
        const Self = @This();

        fn abs(self: Self) Self {
            var tmp = Self{ .data = undefined };
            for (self.data, 0..) |elem, i| {
                tmp.data[i] = if (elem < 0)
                    -elem
                else
                    elem;
            }
            return tmp;
        }

        fn init(data: [count]T) Self {
            return Self{ .data = data };
        }
    };
}

const eql = @import("std").mem.eql;

test "generic vector" {
    const x = Vec(3, f32).init([_]f32{ 10, -10, 5 });
    const y = x.abs();
    try expect(eql(f32, &y.data, &[_]f32{ 10, 10, 5 }));
}

// The types of function parameters can also be inferred by using anytype in place of a type. @TypeOf can then be used on the parameter.
fn plusOne(x: anytype) @TypeOf(x) {
    return x + 1;
}

test "inferred function parameter" {
    try expect(plusOne(@as(u32, 1)) == 2);
}

// Comptime also introduces the operators ++ and ** for concatenating and repeating arrays and slices. These operators do not work at runtime.
test "++" {
    const x: [4]u8 = undefined;
    const y = x[0..];

    const a: [6]u8 = undefined;
    const b = a[0..];

    const new = y ++ b;
    try expect(new.len == 10);
}

test "**" {
    const pattern = [_]u8{ 0xCC, 0xAA };
    const memory = pattern ** 3;
    try expect(eql(u8, &memory, &[_]u8{ 0xCC, 0xAA, 0xCC, 0xAA, 0xCC, 0xAA }));
}

// NO VALUE TYPES

// Zig has at least four ways of expressing "no value":
//
// * undefined
//
//       var foo: u8 = undefined;
//
//       "undefined" should not be thought of as a value, but as a way
//       of telling the compiler that you are not assigning a value
//       _yet_. Any type may be set to undefined, but attempting
//       to read or use that value is _always_ a mistake.
//
// * null
//
//       var foo: ?u8 = null;
//
//       The "null" primitive value _is_ a value that means "no value".
//       This is typically used with optional types as with the ?u8
//       shown above. When foo equals null, that's not a value of type
//       u8. It means there is _no value_ of type u8 in foo at all!
//
// * error
//
//       var foo: MyError!u8 = BadError;
//
//       Errors are _very_ similar to nulls. They _are_ a value, but
//       they usually indicate that the "real value" you were looking
//       for does not exist. Instead, you have an error. The example
//       error union type of MyError!u8 means that foo either holds
//       a u8 value OR an error. There is _no value_ of type u8 in foo
//       when it's set to an error!
//
// * void
//
//       var foo: void = {};
//
//       "void" is a _type_, not a value. It is the most popular of the
//       Zero Bit Types (those types which take up absolutely no space
//       and have only a semantic value. When compiled to executable
//       code, zero bit types generate no code at all. The above example
//       shows a variable foo of type void which is assigned the value
//       of an empty expression. It's much more common to see void as
//       the return type of a function that returns nothing.
//
// Zig has all of these ways of expressing different types of "no value"
// because they each serve a purpose. Briefly:
//
//   * undefined - there is no value YET, this cannot be read YET
//   * null      - there is an explicit value of "no value"
//   * errors    - there is no value because something went wrong
//   * void      - there will NEVER be a value stored here

// MEMORY

// @import() adds the imported code to your own.
//All of this will be loaded into RAM when it runs. Oh, and that thing we name "const std"? That's a struct!

// Remember our old RPG Character struct? A struct is really just a
// very convenient way to deal with memory. These fields (gold,
// health, experience) are all values of a particular size. Add them
// together and you have the size of the struct as a whole.

const Character = struct {
    gold: u32 = 0,
    health: u8 = 100,
    experience: u32 = 0,
};

// Here we create a character called "the_narrator" that is a constant
// (immutable) instance of a Character struct. It is stored in your
// program as data, and like the instruction code, it is loaded into
// RAM when your program runs. The relative location of this data in
// memory is hard-coded and neither the address nor the value changes.

const the_narrator = Character{
    .gold = 12,
    .health = 99,
    .experience = 9000,
};

// This "global_wizard" character is very similar. The address for
// this data won't change, but the data itself can since this is a var
// and not a const.

var global_wizard = Character{};

// A function is instruction code at a particular address. Function
// parameters in Zig are always immutable. They are stored in "the
// stack". A stack is a type of data structure and "the stack" is a
// specific bit of RAM reserved for your program. The CPU has special
// support for adding and removing things from "the stack", so it is
// an extremely efficient place for memory storage.
//
// Also, when a function executes, the input arguments are often
// loaded into the beating heart of the CPU itself in registers.
//
// Our main() function here has no input parameters, but it will have
// a stack entry (called a "frame").

pub fn main() void {

    // Here, the "glorp" character will be allocated on the stack
    // because each instance of glorp is mutable and therefore unique
    // to the invocation of this function.

    var glorp = Character{
        .gold = 30,
    };

    // The "reward_xp" value is interesting. It's an immutable
    // value, so even though it is local, it can be put in global
    // data and shared between all invocations. But being such a
    // small value, it may also simply be inlined as a literal
    // value in your instruction code where it is used.  It's up
    // to the compiler.

    const reward_xp: u32 = 200;

    // Now let's circle back around to that "std" struct we imported
    // at the top. Since it's just a regular Zig value once it's
    // imported, we can also assign new names for its fields and
    // declarations. "debug" refers to another struct and "print" is a
    // public function namespaced within THAT struct.
    //
    // Let's assign the std.debug.print function to a const named
    // "print" so that we can use this new name later!

    const print = std.debug.print;

    // Now let's look at assigning and pointing to values in Zig.
    //
    // We'll try three different ways of making a new name to access
    // our glorp Character and change one of its values.
    //
    // "glorp_access1" is incorrectly named! We asked Zig to set aside
    // memory for another Character struct. So when we assign glorp to
    // glorp_access1 here, we're actually assigning all of the fields
    // to make a copy! Now we have two separate characters.
    //
    // You don't need to fix this. But notice what gets printed in
    // your program's output for this one compared to the other two
    // assignments below!

    var glorp_access1: Character = glorp;
    glorp_access1.gold = 111;
    print("1:{}!. ", .{glorp.gold == glorp_access1.gold});

    // NOTE:
    //
    //     If we tried to do this with a const Character instead of a
    //     var, changing the gold field would give us a compiler error
    //     because const values are immutable!
    //
    // "glorp_access2" will do what we want. It points to the original
    // glorp's address. Also remember that we get one implicit
    // dereference with struct fields, so accessing the "gold" field
    // from glorp_access2 looks just like accessing it from glorp
    // itself.

    var glorp_access2: *Character = &glorp;
    glorp_access2.gold = 222;
    print("2:{}!. ", .{glorp.gold == glorp_access2.gold});

    // "glorp_access3" is interesting. It's also a pointer, but it's a
    // const. Won't that disallow changing the gold value? No! As you
    // may recall from our earlier pointer experiments, a constant
    // pointer can't change what it's POINTING AT, but the value at
    // the address it points to is still mutable! So we CAN change it.

    const glorp_access3: *Character = &glorp;
    glorp_access3.gold = 333;
    print("3:{}!. ", .{glorp.gold == glorp_access3.gold});

    // NOTE:
    //
    //     If we tried to do this with a *const Character pointer,
    //     that would NOT work and we would get a compiler error
    //     because the VALUE becomes immutable!
    //
    // Moving along...
    //
    // Passing arguments to functions is pretty much exactly like
    // making an assignment to a const (since Zig enforces that ALL
    // function parameters are const).
    //
    // Knowing this, see if you can make levelUp() work as expected -
    // it should add the specified amount to the supplied character's
    // experience points.
    //
    print("XP before:{}, ", .{glorp.experience});

    // Fix 1 of 2 goes here:
    levelUp(&glorp, reward_xp);

    print("after:{}.\n", .{glorp.experience});
}

// Fix 2 of 2 goes here:
fn levelUp(character_access: *Character, xp: u32) void {
    character_access.experience += xp;
}

// And there's more!
//
// Data segments (allocated at compile time) and "the stack"
// (allocated at run time) aren't the only places where program data
// can be stored in memory. They're just the most efficient. Sometimes
// we don't know how much memory our program will need until the
// program is running. Also, there is a limit to the size of stack
// memory allotted to programs (often set by your operating system).
// For these occasions, we have "the heap".
//
// You can use as much heap memory as you like (within physical
// limitations, of course), but it's much less efficient to manage
// because there is no built-in CPU support for adding and removing
// items as we have with the stack. Also, depending on the type of
// allocation, your program MAY have to do expensive work to manage
// the use of heap memory. We'll learn about heap allocators later.
//
// Whew! This has been a lot of information. You'll be pleased to know
// that the next exercise gets us back to learning Zig language
// features we can use right away to do more things!

// PAYLOAD CAPTURES
// Use the syntax |value| and apear in many places, some of which we've seen alrede. Wherever they appear, they are used to "capture" the value from something.
// With if statements and optionals.
test "optional-if" {
    var maybe_num: ?usize = 10;
    if (maybe_num) |n| {
        try expect(@TypeOf(n) == usize);
        try expect(n == 10);
    } else {
        unreachable;
    }
}

// With if statements and error unions. The else with the error capture is required here
test "error union if" {
    var ent_num: error{UnknownEntity}!u32 = 5;
    if (ent_num) |entity| {
        try expect(@TypeOf(entity) == u32);
        try expect(entity == 5);
    } else |err| {
        _ = err catch {};
        unreachable;
    }
}

// With while loops and optioanls. This may have an else block.
test "while optional" {
    var i: ?u32 = 10;
    while (i) |num| : (i.? -= 1) {
        try expect(@TypeOf(num) == u32);
        if (num == 1) {
            i = null;
            break;
        }
    }

    try expect(i == null);
}

// With while loops and error unions. The else with the error capture is required here.
var numbers_left2: u32 = undefined;

fn eventuallyErrorSequence() !u32 {
    return if (numbers_left2 == 0) error.ReachedZero else blk: {
        numbers_left2 -= 1;
        break :blk numbers_left2;
    };
}

test "while error union capture" {
    var sum: u32 = 0;
    numbers_left2 = 3;

    while (eventuallyErrorSequence()) |value| {
        sum += value;
    } else |err| {
        try expect(err == error.ReachedZero);
    }
}

// For loops
test "for capture" {
    const x = [_]i8{ 1, 5, 120, -5 };
    for (x) |v| try expect(@TypeOf(v) == i8);
}

// Switch cases on tagged unions.
const Info = union(enum) {
    a: u32,
    b: []const u8,
    c,
    d: u32,
};

test "switch capture" {
    var b = Info{ .a = 10 };
    const x = switch (b) {
        .b => |str| blk: {
            try expect(@TypeOf(str) == []const u8);
            break :blk 1;
        },
        .c => 2,
        .a, .d => |num| blk: {
            try expect(@TypeOf(num) == u32);
            break :blk num * 2;
        },
    };
    try expect(x == 20);
}

// As we saw in the Union and Optional sections above, values captured with the |val| syntax are inmutable (similat tu functinos arguemnts), but we can use pointer capture to modify the original values. This captures the values as pointers that are themselves still immutable, but because the value is now a pointer, we can modify the original value by dereferencing it:
test "for with pointer capture" {
    var data = [_]u8{ 1, 2, 3 };
    for (&data) |*byte| byte.* += 1;
    try expect(eql(u8, &data, &[_]u8{ 2, 3, 4 }));
}

// INLINE LOOPS
// inline loops are unrolled, and allow some things to happen which only work at compile time. Here we use a for, but a whiole works similarly.
test "inline for" {
    const types = [_]type{ i32, f32, u8, bool };
    var sum: usize = 0;
    inline for (types) |T| sum += @sizeOf(T);
    try expect(sum == 10);
}

// Using these for performance reasons is inadvisable unless you've tested that explicitly unrolling is faster; the compilers tends to make better decesions here than you.

// OPAQUE
// opaque types in Zig have an unknow (albeit non-zero) size and alignment. Because of this these data types cannot be stored directly. These are used to mantain type safety with pointers to types that we dont have information about
const Window = opaque {};
const Button = opaque {};

extern fn show_window(*Window) callconv(.c) void;

test "opaque" {
    var main_window: *Window = undefined;
    show_window(main_window);

    var ok_button: *Button = undefined;
    show_window(ok_button);
}
//./test-c1.zig:653:17: error: expected type '*Window', found '*Button'
//    show_window(ok_button);
//                ^
//./test-c1.zig:653:17: note: pointer type child 'Button' cannot cast into pointer type child 'Window'
//    show_window(ok_button);

// Opaque types may have declarations in their definitions ( the same as structs, enumns and unions)
const Window2 = opaque {
    fn show(self: *Window2) void {
        show_window2(self);
    }
};

extern fn show_window2(*Window2) callconv(.C) void;

test "opaque with declarations" {
    var main_window: *Window2 = undefined;
    main_window.show();
}

// The typical usecase of opaque is to maintain type safety when interoperating with C code that does not expose complete type information.

// ANONYMUS STRUCTS
//The struct type may be omitted from a struct literal. These literals may coerce to other struct types.
test "anonymous struct literal" {
    const Point = struct { x: i32, y: i32 };

    var pt: Point = .{
        .x = 13,
        .y = 67,
    };
    try expect(pt.x == 13);
    try expect(pt.y == 67);
}
// Anonymous structs may be completely anonymous i.e. without being coerced to another struct type.
test "fully anonymous struct" {
    try dump(.{
        .int = @as(u32, 1234),
        .float = @as(f64, 12.34),
        .b = true,
        .s = "hi",
    });
}

fn dump(args: anytype) !void {
    try expect(args.int == 1234);
    try expect(args.float == 12.34);
    try expect(args.b);
    try expect(args.s[0] == 'h');
    try expect(args.s[1] == 'i');
}

// Anonymous structs without field names may be created, and are referred to as tuples. These have many of the properties that arrays do; tuples can be iterated over, indexed, can be used with the ++ and ** operators, and have a len field. Internally, these have numbered field names starting at "0", which may be accessed with the special syntax @"0" which acts as an escape for the syntax - things inside @"" are always recognised as identifiers.

// An inline loop must be used to iterate over the tuple here, as the type of each tuple field may differ.
test "tuple" {
    const values = .{
        @as(u32, 1234),
        @as(f64, 12.34),
        true,
        "hi",
    } ++ .{false} ** 2;
    try expect(values[0] == 1234);
    try expect(values[4] == false);
    inline for (values, 0..) |v, i| {
        if (i != 2) continue;
        try expect(v);
    }
    try expect(values.len == 6);
    try expect(values.@"3"[0] == 'h');
}

// SENTINEL TERMINATION
// Arrays, slices and many pointers may be terminated by a value of their child type. This is known as sentinel termination. These follow the syntax [N:t]T, [:t]T, and [*:t]T, where t is a value of the child type T.

// An example of a sentinel terminated array. The built-in @bitCast is used to perform an unsafe bitwise type conversion. This shows us that the last element of the array is followed by a 0 byte.
test "sentinel termination" {
    const terminated = [3:0]u8{ 3, 2, 1 };
    try expect(terminated.len == 3);
    try expect(@ptrCast(*const [4]u8, &terminated)[3] == 0);
}

//The types of string literals is *const [N:0]u8, where N is the length of the string. This allows string literals to coerce to sentinel terminated slices, and sentinel terminated many pointers. Note: string literals are UTF-8 encoded.
test "string literal" {
    try expect(@TypeOf("hello") == *const [5:0]u8);
}

// [*:0]u8 and [*:0]const u8 perfectly model C’s strings.
test "C string" {
    const c_string: [*:0]const u8 = "hello";
    var array: [5]u8 = undefined;

    var i: usize = 0;
    while (c_string[i] != 0) : (i += 1) {
        array[i] = c_string[i];
    }
}

// Sentinel terminated types coerce to their non-sentinel-terminated counterparts.
test "coercion" {
    var a: [*:0]u8 = undefined;
    const b: [*]u8 = a;
    _ = b;

    var c: [5:0]u8 = undefined;
    const d: [5]u8 = c;
    _ = d;

    var e: [:10]f32 = undefined;
    const f = e;
    _ = f;
}

// Sentinel terminated slicing is provided which can be used to create a sentinel terminated slice with the syntax x[n..m:t], where t is the terminator value. Doing this is an assertion from the programmer that the memory is terminated where it should be - getting this wrong is detectable illegal behaviour.
test "sentinel terminated slicing" {
    var x = [_:0]u8{255} ** 3;
    const y = x[0..3 :0];
    _ = y;
}

// VECTORS
// Zig provides vector types for SIMD. These are not to be conflated with vectors in a mathematical sense, or vectors like C++’s std::vector (for this, see “Arraylist” in chapter 2). Vectors may be created using the @Type built-in we used earlier, and std.meta.Vector provides a shorthand for this.

// Vectors can only have child types of booleans, integers, floats and pointers.

// Operations between vectors with the same child type and length can take place. These operations are performed on each of the values in the vector.std.meta.eql is used here to check for equality between two vectors (also useful for other types like structs).
const meta = @import("std").meta;
const Vector = meta.Vector;

test "vector add" {
    const x: Vector(4, f32) = .{ 1, -10, 20, -1 };
    const y: Vector(4, f32) = .{ 2, 10, 0, 1 };
    const z = x + y;
    try expect(meta.eql(z, Vector(4, f32){ 3, 0, 20, 0 }));
}

//Vectors are indexable.
test "vector indexing" {
    const x: Vector(4, u8) = .{ 255, 0, 255, 0 };
    try expect(x[0] == 255);
}

// The built-in function @splat may be used to construct a vector where all of the values are the same. Here we use it to multiply a vector by a scalar.
test "vector * scalar" {
    const x: Vector(3, f32) = .{ 12.5, 37.5, 2.5 };
    const y = x * @splat(3, @as(f32, 2));
    try expect(meta.eql(y, Vector(3, f32){ 25, 75, 5 }));
}

// Vectors do not have a len field like arrays, but may still be looped over. Here, std.mem.len is used as a shortcut for @typeInfo(@TypeOf(x)).Vector.len.
const len = @import("std").mem.len;

test "vector looping" {
    const x = Vector(4, u8){ 255, 0, 255, 0 };
    var sum = blk: {
        var tmp: u10 = 0;
        var i: u8 = 0;
        while (i < 4) : (i += 1) tmp += x[i];
        break :blk tmp;
    };
    try expect(sum == 510);

    //Vectors coerce to their respective arrays.
    const arr: [4]f32 = @Vector(4, f32){ 1, 2, 3, 4 };
    _ = arr;
}

//IMPORTS
//The built-in function @import takes in a file, and gives you a struct type based on that file. All declarations labelled as pub (for public) will end up in this struct type, ready for use.

//@import("std") is a special case in the compiler, and gives you access to the standard library. Other @imports will take in a file path, or a package name (more on packages in a later chapter).

// IMPORTANT THINGS

//                          u8  single item
//                         *u8  single-item pointer
//                        []u8  slice (size known at runtime)
//                       [5]u8  array of 5 u8s
//                       [*]u8  many-item pointer (zero or more)
//                 enum {a, b}  set of unique values a and b
//                error {e, f}  set of unique error values e and f
//      struct {y: u8, z: i32}  group of values y and z
// union(enum) {a: u8, b: i32}  single value either u8 or i32
//
// Values of any of the above types can be assigned as "var" or "const"
// to allow or disallow changes (mutability) via the assigned name:
//
//     const a: u8 = 5; // immutable
//       var b: u8 = 5; //   mutable
//
// We can also make error unions or optional types from any of
// the above:
//
//     var a: E!u8 = 5; // can be u8 or error from set E
//     var b: ?u8 = 5;  // can be u8 or null

// COERCION RULES

// 1. Types can always be made _more_ restrictive.
//
//    var foo: u8 = 5;
//    var p1: *u8 = &foo;
//    var p2: *const u8 = p1; // mutable to immutable
//
// 2. Numeric types can coerce to _larger_ types.
//
//    var n1: u8 = 5;
//    var n2: u16 = n1; // integer "widening"
//
//    var n3: f16 = 42.0;
//    var n4: f32 = n3; // float "widening"
//
// 3. Single-item pointers to arrays coerce to slices and
//    many-item pointers.
//
//    const arr: [3]u8 = [3]u8{5, 6, 7};
//    const s: []const u8 = &arr;  // to slice
//    const p: [*]const u8 = &arr; // to many-item pointer
//
// 4. Single-item mutable pointers can coerce to single-item
//    pointers pointing to an array of length 1. (Interesting!)
//
//    var five: u8 = 5;
//    var a_five: *[1]u8 = &five;
//
// 5. Payload types and null coerce to optionals.
//
//    var num: u8 = 5;
//    var maybe_num: ?u8 = num; // payload type
//    maybe_num = null;         // null
//
// 6. Payload types and errors coerce to error unions.
//
//    const MyError = error{Argh};
//    var char: u8 = 'x';
//    var char_or_die: MyError!u8 = char; // payload type
//    char_or_die = MyError.Argh;         // error
//
// 7. 'undefined' coerces to any type (or it wouldn't work!)
//
// 8. Compile-time numbers coerce to compatible types.
//
//    Just about every single exercise program has had an example
//    of this, but a full and proper explanation is coming your
//    way soon in the third-eye-opening subject of comptime.
//
// 9. Tagged unions coerce to the current tagged enum.
//
// 10. Enums coerce to a tagged union when that tagged field is a
//     zero-length type that has only one value (like void).
//
// 11. Zero-bit types (like void) can be coerced into single-item
//     pointers.

// USEFUL BUILTIN

// For now, we're going to complete our examination of builtins
// by exploring just THREE of Zig's MANY introspection abilities:
//
// 1. @This() type
//
// Returns the innermost struct, enum, or union that a function
// call is inside.
//
// 2. @typeInfo(comptime T: type) @import("std").builtin.TypeInfo
//
// Returns information about any type in a TypeInfo union which
// will contain different information depending on which type
// you're examining.
//
// 3. @TypeOf(...) type
//
// Returns the type common to all input parameters (each of which
// may be any expression). The type is resolved using the same
// "peer type resolution" process the compiler itself uses when
// inferring types.

// COMPTIME

// ALL numeric literals in Zig are of type comptime_int or
// comptime_float. They are of arbitrary size (as big or
// little as you need).
//
// Notice how we don't have to specify a size like "u8",
// "i32", or "f64" when we assign identifiers immutably with
// "const".
//
// When we use these identifiers in our program, the VALUES
// are inserted at compile time into the executable code. The
// IDENTIFIERS "const_int" and "const_float" don't exist in
// our compiled application!

fn Comptime() void {
    const const_int = 12345;
    const const_float = 987.654;

    std.debug.print("Immutable: {}, {d:.3}; ", .{ const_int, const_float });

    // But something changes when we assign the exact same values
    // to identifiers mutably with "var".
    //
    // The literals are STILL comptime_int and comptime_float,
    // but we wish to assign them to identifiers which are
    // mutable at runtime.
    //
    // To be mutable at runtime, these identifiers must refer to
    // areas of memory. In order to refer to areas of memory, Zig
    // must know exactly how much memory to reserve for these
    // values. Therefore, it follows that we just specify numeric
    // types with specific sizes. The comptime numbers will be
    // coerced (if they'll fit!) into your chosen runtime types.
    // For this it is necessary to specify a size, e.g. 32 bit.
    var var_int: u32 = 12345;
    var var_float: f32 = 987.654;

    // We can change what is stored at the areas set aside for
    // "var_int" and "var_float" in the running compiled program.
    var_int = 54321;
    var_float = 456.789;

    //
    // We've seen that Zig implicitly performs some evaluations at
    // compile time. But sometimes you'll want to explicitly request
    // compile time evaluation. For that, we have a new keyword:
    //
    //  .     .   .      o       .          .       *  . .     .
    //    .  *  |     .    .            .   .     .   .     * .    .
    //        --o--            comptime        *    |      ..    .
    //     *    |       *  .        .    .   .    --*--  .     *  .
    //  .     .    .    .   . . .      .        .   |   .    .  .
    //
    // When placed before a variable declaration, 'comptime'
    // guarantees that every usage of that variable will be performed
    // at compile time.
    //
    // As a simple example, compare these two statements:
    //
    //    var bar1 = 5;            // ERROR!
    //    comptime var bar2 = 5;   // OKAY!
    //
    // The first one gives us an error because Zig assumes mutable
    // identifiers (declared with 'var') will be used at runtime and
    // we have not assigned a runtime type (like u8 or f32). Trying
    // to use a comptime_int of undetermined size at runtime is
    // a MEMORY CRIME and you are UNDER ARREST.
    //
    // The second one is okay because we've told Zig that 'bar2' is
    // a compile time variable. Zig will help us ensure this is true
    // and let us know if we make a mistake.

    //
    // In this contrived example, we've decided to allocate some
    // arrays using a variable count! But something's missing...
    //
    comptime var count = 0;

    count += 1;
    var a1: [count]u8 = .{'A'} ** count;

    count += 1;
    var a2: [count]u8 = .{'B'} ** count;

    count += 1;
    var a3: [count]u8 = .{'C'} ** count;

    count += 1;
    var a4: [count]u8 = .{'D'} ** count;

    std.debug.print("{s} {s} {s} {s}\n", .{ a1, a2, a3, a4 });

    // Builtin BONUS!
    //
    // The @compileLog() builtin is like a print statement that
    // ONLY operates at compile time. The Zig compiler treats
    // @compileLog() calls as errors, so you'll want to use them
    // temporarily to debug compile time logic.
    //
    // Try uncommenting this line and playing around with it
    // (copy it, move it) to see what it does:
    // @compileLog("Count at compile time: ", count);

    // You can also put 'comptime' before a function parameter to
    // enforce that the argument passed to the function must be known
    // at compile time. We've actually been using a function like
    // this the entire time, std.debug.print():
    //
    //     fn print(comptime fmt: []const u8, args: anytype) void
    //
    // Notice that the format string parameter 'fmt' is marked as
    // 'comptime'.  One of the neat benefits of this is that the
    // format string can be checked for errors at compile time rather
    // than crashing at runtime.

    const Schooner = struct {
        const Self = @This();

        name: []const u8,
        scale: u32 = 1,
        hull_length: u32 = 143,
        bowsprit_length: u32 = 34,
        mainmast_height: u32 = 95,

        fn scaleMe(self: *Self, comptime scale: u32) void {
            var my_scale = scale;

            // We did something neat here: we've anticipated the
            // possibility of accidentally attempting to create a
            // scale of 1:0. Rather than having this result in a
            // divide-by-zero error at runtime, we've turned this
            // into a compile error.
            //
            // This is probably the correct solution most of the
            // time. But our model boat model program is very casual
            // and we just want it to "do what I mean" and keep
            // working.
            //
            // Please change this so that it sets a 0 scale to 1
            // instead.
            if (my_scale == 0) @compileError("Scale 1:0 is not valid!");

            self.scale = my_scale;
            self.hull_length /= my_scale;
            self.bowsprit_length /= my_scale;
            self.mainmast_height /= my_scale;
        }

        fn printMe(self: *Self) void {
            std.debug.print("{s} (1:{}, {} x {})\n", .{
                self.name,
                self.scale,
                self.hull_length,
                self.mainmast_height,
            });
        }
    };

    var whale = Schooner{ .name = "Whale" };
    var shark = Schooner{ .name = "Shark" };
    var minnow = Schooner{ .name = "Minnow" };

    // Hey, we can't just pass this runtime variable as an
    // argument to the scaleMe() method. What would let us do
    // that?
    comptime var scale = 0;

    scale = 32; // 1:32 scale

    minnow.scaleMe(scale);
    minnow.printMe();

    scale -= 16; // 1:16 scale

    shark.scaleMe(scale);
    shark.printMe();

    scale -= 16; // 1:0 scale (oops, but DON'T FIX THIS!)

    whale.scaleMe(scale);
    whale.printMe();

    //
    // Going deeper:
    //
    // What would happen if you DID attempt to build a model in the
    // scale of 1:0?
    //
    //    A) You're already done!
    //    B) You would suffer a mental divide-by-zero error.
    //    C) You would construct a singularity and destroy the
    //       planet.
    //
    // And how about a model in the scale of 0:1?
    //
    //    A) You're already done!
    //    B) You'd arrange nothing carefully into the form of the
    //       original nothing but infinitely larger.
    //    C) You would construct a singularity and destroy the
    //       planet.
    //
    // Answers can be found on the back of the Ziglings packaging.

}

// One of the more common uses of 'comptime' function parameters is
// passing a type to a function:
//
//     fn foo(comptime MyType: type) void { ... }
//
// In fact, types are ONLY available at compile time, so the
// 'comptime' keyword is required here.
//
// Please take a moment to put on the wizard hat which has been
// provided for you. We're about to use this ability to implement
// a generic function.

// Being able to pass types to functions at compile time lets us
// generate code that works with multiple types. But it doesn't
// help us pass VALUES of different types to a function.
//
// For that, we have the 'anytype' placeholder, which tells Zig
// to infer the actual type of a parameter at compile time.
//
//     fn foo(thing: anytype) void { ... }
//
// Then we can use builtins such as @TypeOf(), @typeInfo(),
// @typeName(), @hasDecl(), and @hasField() to determine more
// about the type that has been passed in. All of this logic will
// be performed entirely at compile time.

const Duck = struct {
    eggs: u8,
    loudness: u8,
    location_x: i32 = 0,
    location_y: i32 = 0,

    fn waddle(self: *Duck, x: i16, y: i16) void {
        self.location_x += x;
        self.location_y += y;
    }

    fn quack(self: Duck) void {
        if (self.loudness < 4) {
            std.debug.print("\"Quack.\" ", .{});
        } else {
            std.debug.print("\"QUACK!\" ", .{});
        }
    }
};

const RubberDuck = struct {
    in_bath: bool = false,
    location_x: i32 = 0,
    location_y: i32 = 0,

    fn waddle(self: *RubberDuck, x: i16, y: i16) void {
        self.location_x += x;
        self.location_y += y;
    }

    fn quack(self: RubberDuck) void {
        // Assigning an expression to '_' allows us to safely
        // "use" the value while also ignoring it.
        _ = self;
        std.debug.print("\"Squeek!\" ", .{});
    }

    fn listen(self: RubberDuck, dev_talk: []const u8) void {
        // Listen to developer talk about programming problem.
        // Silently contemplate problem. Emit helpful sound.
        _ = dev_talk;
        self.quack();
    }
};

const Duct = struct {
    diameter: u32,
    length: u32,
    galvanized: bool,
    connection: ?*Duct = null,

    fn connect(self: *Duct, other: *Duct) !void {
        if (self.diameter == other.diameter) {
            self.connection = other;
        } else {
            return DuctError.UnmatchedDiameters;
        }
    }
};

const DuctError = error{UnmatchedDiameters};

pub fn duckies() void {
    // This is a real duck!
    var ducky1 = Duck{
        .eggs = 0,
        .loudness = 3,
    };

    // This is not a real duck, but it has quack() and waddle()
    // abilities, so it's still a "duck".
    var ducky2 = RubberDuck{
        .in_bath = false,
    };

    // This is not even remotely a duck.
    var ducky3 = Duct{
        .diameter = 17,
        .length = 165,
        .galvanized = true,
    };

    std.debug.print("ducky1: {}, ", .{isADuck(ducky1)});
    std.debug.print("ducky2: {}, ", .{isADuck(ducky2)});
    std.debug.print("ducky3: {}\n", .{isADuck(ducky3)});
}

// This function has a single parameter which is inferred at
// compile time. It uses builtins @TypeOf() and @hasDecl() to
// perform duck typing ("if it walks like a duck and it quacks
// like a duck, then it must be a duck") to determine if the type
// is a "duck".
fn isADuck(possible_duck: anytype) bool {
    // We'll use @hasDecl() to determine if the type has
    // everything needed to be a "duck".
    //
    // In this example, 'has_increment' will be true if type Foo
    // has an increment() method:
    //
    //     const has_increment = @hasDecl(Foo, "increment");
    //
    // Please make sure MyType has both waddle() and quack()
    // methods:
    const MyType = @TypeOf(possible_duck);
    const walks_like_duck = @hasDecl(MyType, "waddle");
    const quacks_like_duck = @hasDecl(MyType, "quack");

    const is_duck = walks_like_duck and quacks_like_duck;

    if (is_duck) {
        // We also call the quack() method here to prove that Zig
        // allows us to perform duck actions on anything
        // sufficiently duck-like.
        //
        // Because all of the checking and inference is performed
        // at compile time, we still have complete type safety:
        // attempting to call the quack() method on a struct that
        // doesn't have it (like Duct) would result in a compile
        // error, not a runtime panic or crash!
        possible_duck.quack();
    }

    return is_duck;
}

// There have been several instances where it would have been
// nice to use loops in our programs, but we couldn't because the
// things we were trying to do could only be done at compile
// time. We ended up having to do those things MANUALLY, like
// NORMAL people. Bah! We are PROGRAMMERS! The computer should be
// doing this work.
//
// An 'inline for' is performed at compile time, allowing you to
// programatically loop through a series of items in situations
// like those mentioned above where a regular runtime 'for' loop
// wouldn't be allowed:
//
//     inline for (.{ u8, u16, u32, u64 }) |T| {
//         print("{} ", .{@typeInfo(T).Int.bits});
//     }
//
// In the above example, we're looping over a list of types,
// which are available only at compile time.
const Narcissus = struct { value: u32, name: []u8 };

pub fn narckk() void {
    std.debug.print("Narcissus has room in his heart for:", .{});

    // Last time we examined the Narcissus struct, we had to
    // manually access each of the three fields. Our 'if'
    // statement was repeated three times almost verbatim. Yuck!
    //
    // Please use an 'inline for' to implement the block below
    // for each field in the slice 'fields'!

    const fields = @typeInfo(Narcissus).Struct.fields;

    inline for (fields) |field| {
        if (field.type != void) {
            std.debug.print(" {s}", .{field.name});
        }
    }

    // Once you've got that, go back and take a look at exercise
    // 065 and compare what you've written to the abomination we
    // had there!

    std.debug.print(".\n", .{});
}

// There is also an 'inline while'. Just like 'inline for', it
// loops at compile time, allowing you to do all sorts of
// interesting things not possible at runtime. See if you can
// figure out what this rather bonkers example prints:
//
//     const foo = [3]*const [5]u8{ "~{s}~", "<{s}>", "d{s}b" };
//     comptime var i = 0;
//
//     inline while ( i < foo.len ) : (i += 1) {
//         print(foo[i] ++ "\n", .{foo[i]});
//     }

// As a matter of fact, you can put 'comptime' in front of any
// expression to force it to be run at compile time.
//
// Execute a function:
//
//     comptime llama();
//
// Get a value:
//
//     bar = comptime baz();
//
// Execute a whole block:
//
//     comptime {
//         bar = baz + biff();
//         llama(bar);
//     }
//
// Get a value from a block:
//
//     var llama = comptime bar: {
//         const baz = biff() + bonk();
//         break :bar baz;
//     }

// In addition to knowing when to use the 'comptime' keyword,
// it's also good to know when you DON'T need it.
//
// The following contexts are already IMPLICITLY evaluated at
// compile time, and adding the 'comptime' keyword would be
// superfluous, redundant, and smelly:
//
//    * The global scope (outside of any function in a source file)
//    * Type declarations of:
//        * Variables
//        * Functions (types of parameters and return values)
//        * Structs
//        * Unions
//        * Enums
//    * The test expressions in inline for and while loops
//    * An expression passed to the @cImport() builtin

// Being in the global scope, everything about this value is
// implicitly required to be known compile time.
const llama_count = 5;

// Again, this value's type and size must be known at compile
// time, but we're letting the compiler infer both from the
// return type of a function.
const llamas = makeLlamas(llama_count);

// And here's the function. Note that the return value type
// depends on one of the input arguments!
fn makeLlamas(comptime count: usize) [count]u8 {
    var temp: [count]u8 = undefined;
    var i = 0;

    // Note that this does NOT need to be an inline 'while'.
    while (i < count) : (i += 1) {
        temp[i] = i;
    }

    return temp;
}

pub fn makeLamas() void {
    std.debug.print("My llama value is {}.\n", .{llamas[2]});
}
//
// The lesson here is to not pepper your program with 'comptime'
// keywords unless you need them. Between the implicit compile
// time contexts and Zig's aggressive evaluation of any
// expression it can figure out at compile time, it's sometimes
// surprising how few places actually need the keyword.

// STANDARD PATTERNS

// ALLOCATORS
// The zig standar library provides a pattern for allocating memory, which allows the programmer to choose exactly how memory allocations are done within the standar library - no allocations happen behind your back in the standard library

// The most basic allocator is std.heap.page_allocator. Whenever this allocator makes an allocation it will ask your OS for entire pages of memory, an allocation of a single byte will likely reserver multiple kibibytes. As asking for the OS for memory requires a system call this is also extemely inefficient for spped.

// Here we allocate 100 bytes as a []u8. Notice how defer is used in conjunction with a free - this is a common pattern for memory management in Zig
test "allocation" {
    const allocator = std.heap.page_allocator;

    const memory = try allocator.alloc(u8, 100);
    defer allocator.free(memory);

    try expect(memory.len == 100);
    try expect(@TypeOf(memory) == []u8);
}

// The std.heap.FixedBufferAllocator is an allocator that allocates memory into a fixed buffer, and does not make any heap allocations. This is useful when heap usage is not wanted, for example when writing a kernel. It may also be considered for performance reasons. It will give you the error OutOfMemory if it has run out of bytes.
test "fixed buffer allocator" {
    var buffer: [1000]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();

    const memory = try allocator.alloc(u8, 100);
    defer allocator.free(memory);

    try expect(memory.len == 100);
    try expect(@TypeOf(memory) == []u8);
}

// std.heap.ArenaAllocator takes in a child allocator, and allows you to allocate many times and only free once. Here, .deinit() is calld on the arena which frees all memory. Using allocator.free in in this example would be a no-op (i.e does nothing).
test "arena allocator" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    _ = try allocator.alloc(u8, 1);
    _ = try allocator.alloc(u8, 10);
    _ = try allocator.alloc(u8, 100);
}

// alloc and free are used for slices. For single items, consider using create and destroy
test "allocator create/destroy" {
    const byte = try std.heap.page_allocator.create(u8);
    defer std.heap.page_allocatr.destroy(byte);
    byte.* = 128;
}

// The Zig standard library also has a general purpose allocator. This is a safe allocator which can prevent double-free, use-after-free and can detect leaks. Safety checks and thread safety can be turned of via its configuration struct. Zig's GPA is designed for safety over performance, but may still be many times faster than page_allocator.
test "GPA" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const deinit_status = gpa.deinit();

        if (deinit_status == .leak) expect(false) catch @panic("TEST FAIL");
    }

    const bytes = try allocator.alloc(u8, 100);
    defer allocator.free(bytes);
}

// For high performance (but very few safety features), std.heap.c_allocator may be considered. This however has the disadvantage of requiring lniking libc, which can be done with -lc.

// ARRAYLIST
/// The std.Arraylist is commonly used throughout Zig, and serves as a buffer which can change in size. std.ArrayList(T) is similar to C++'s std::vector<T> and Rust's Vec<T>. The deinit method frees all of the ArrayList's memory. The memory can be read from and written to via its slice field - .items

// Here we will introduce the usage of the testing allocator. This is a special allocator that only works in tests, and can detect memory leaks. In your code, use whatever allocator is appropiate.
const ArrayList = std.ArrayList;
const test_allocator = std.testing.allocator;

test "arraylist" {
    var list = ArrayList(u8).init(test_allocator);
    defer list.deinit();

    try list.append('H');
    try list.append('e');
    try list.append('l');
    try list.append('l');
    try list.append('o');
    try list.appendsSlice(" World!");

    try expect(eql(u8, list.items, "Hello World!"));
}

// FILESYSTEM
// Lets create and open a file in our current working directory,write to it, and then read from it. Here we have to use .seekTo i order to go back to the start of the file before reading what we haven written.
test "createFiel, write, seekTo, read" {
    const file = try std.fs.cwd().createFile(
        "junk_file.txt",
        .{ .read = true },
    );
    defer file.close();

    const bytes_written = try file.writeAll("Hello File!");
    _ = bytes_written;

    var buffer: [100]u8 = undefined;
    try file.seekTo(0);
    const bytes_read = try file.readAll(&buffer);

    try expect(eql(u8, buffer[0..bytes_read], "Hello File!"));
}

// The functions td.fs.openFileAbsolute and similar absolute functions exist, but we will not test them here.

// We can get various information about files by using .stat() on them. Stat also contains fields for .inode and .mode, but they are not tested here as they rely on the current OS'types.
test "file sta" {
    const file = try std.fs.cwd().createFile(
        "junk_file2.txt",
        .{ .read = true },
    );
    defer file.close();

    const stat = try file.stat();

    try expect(stat.size == 0);
    try expect(stat.kind == .File);
    try expect(stat.ctime == std.time.nanoTimestamp());
    try expect(stat.mtime == std.time.nanoTimestamp());
    try expect(stat.atime == std.time.nanoTimestamp());
}

// We can make directories and iterate over their contents. Here we will use an iterator. This directory (and its contents) will be deleted after this test finishes.
test "make dir" {
    try std.fs.cwd().makeDir("test-tmp");
    const iter_dir = try std.fs.cwd().openIterableDir(
        "test-tmp",
        .{},
    );
    defer {
        std.fs.cwd().deleteTree("test-tmp") catch unreachable;
    }

    _ = try iter_dir.dir.createFile("x", .{});
    _ = try iter_dir.dir.createFile("y", .{});
    _ = try iter_dir.dir.createFile("z", .{});

    var file_count: usize = 0;
    var iter = iter_dir.iterate();
    while (try iter.next()) |entry| {
        if (entry.kind == .File) file_count += 1;
    }

    try expect(file_count == 3);
}

// READERS AND WRITERS
// std.io.Writer and std.io.Reader provide standard ways of making use of IO. std.ArrayList(u8) has a writer method which gives us a writter.
test "io writter usage" {
    var list = ArrayList(u8).init(test_allocator);
    defer list.deinit();
    const bytes_written = try list.writer().write(
        "Hello World!",
    );
    try expect(bytes_written == 12);
    try expect(eql(u8, list.items, "Hello World!"));
}

// Here we will use a redear to copy the file's contents into an allocated buffer. The second argument of readAllAlloc is the maximum size that it may allocate; if the file is larger than this, it will return error.StreamTooLong.
test "io reader usage" {
    const message = "Hello File!";

    const file = try std.fs.cwd().createFile(
        "junk_file2.txt",
        .{ .read = true },
    );
    defer file.close();

    try file.writeAll(message);
    try file.seekTo(0);

    const contents = try file.reader().readAllAlloc(
        test_allocator,
        message.len,
    );
    defer test_allocator.free(contents);

    try expect(eql(u8, contents, message));
}

// A common usecase for readers is to read until the next line(e.g for user input). Here we will do this with the std.io.getStdIn() file.
fn nextLine(reader: anytype, buffer: []u8) !?[]const u8 {
    var line = (try reader.readUntilDelimiterOrEof(
        buffer,
        '\n',
    )) orelse return null;

    if (@import("builtin").os.tag == .windows) {
        return std.mem.trimRight(u8, line, "/r");
    } else {
        return line;
    }
}

test "read until next line" {
    const stdout = std.io.getStdOut();
    const stdin = std.io.getStdIn();

    try stdout.writeall(
        \\ Enter your name:
    );

    var buffer: [100]u8 = undefined;
    const input = (try nextLine(stdin.reader(), &buffer)).?;
    try stdout.writer().print(
        "Your name is: \"{s}\"\n",
        .{input},
    );
}

// An std.io.Writer type consists of a context type, error set, and a write function. The write function msut take in the context and a byte slice. The write function must also return an error union of the writer type's error set and the amount of bytes written. Let's create a type that implements a writer
const MyByteList = struct {
    data: [100]u8 = undefined,
    items: []u8 = &[_]u8{},

    const Writer = std.io.Writer(
        *MyByteList,
        error{EndOfBuffer},
        appendWrite,
    );

    fn appendWrite(
        self: *MyByteList,
        data: []const u8,
    ) error{EndOfBuffer}!usize {
        if (self.items.len + data.len > self.data.len) {
            return error.EndOfBuffer;
        }
        std.mem.copy(
            u8,
            self.data[self.items.len..],
            data,
        );
        self.items = self.data[0 .. self.items.len + data.len];
        return data.len;
    }

    fn writer(self: *MyByteList) Writer {
        return .{ .context = self };
    }
};

test "custom writer" {
    var bytes = MyByteList{};
    _ = try bytes.writer().write("Hello");
    _ = try bytes.writer().write(" Writer!");
    try expect(eql(u8, bytes.items, "Hello Writer!"));
}

// FORMATING
// std.fmt provides ways to format data to and from strings.

// A basic example of creating a formatted string. The format string must be compile time known. The d here denotes that we want a decimal number.
test "fmt" {
    const string = try std.fmt.allocPrint(
        test_allocator,
        "{d} + {d} = {d}",
        .{ 9, 10, 19 },
    );
    defer test_allocator.free(string);

    try expect(eql(u8, string, "9 + 10 = 19"));
}

// Writers conveniently have a print method, which works similarly.
test "print" {
    var list = std.ArrayList(u8).init(test_allocator);
    defer list.deinit();
    try list.writer().print(
        "{} + {} = {}",
        .{ 9, 10, 19 },
    );
    try expect(eql(u8, list.items, "9 + 10 = 10"));
}

// Take a moment to appreciate that you now know from top to bottom how printing hello world works. std.debug.print works the same, except it writes to stderr and is protected by a mutex.
test "hello world" {
    const out_file = std.io.getStdOut();
    try out_file.writer().print(
        "Hello, {s}!\n",
        .{"World"},
    );
}

// We have used the {s} format specifier up until this point to print strings. Here we will use {any}, which gives us the default formatting.
test "array printing" {
    const string = try std.fmt.allocPrint(
        test_allocator,
        "{any} + {any} = {any}",
        .{
            @as([]const u8, &[_]u8{ 1, 4 }),
            @as([]const u8, &[_]u8{ 2, 5 }),
            @as([]const u8, &[_]u8{ 3, 9 }),
        },
    );
    defer test_allocator.free(string);

    try expect(eql(
        u8,
        string,
        "{ 1, 4 } + { 2, 5 } = { 3, 9 }",
    ));
}

// Let’s create a type with custom formatting by giving it a format function. This function must be marked as pub so that std.fmt can access it (more on packages later). You may notice the usage of {s} instead of {} - this is the format specifier for strings (more on format specifiers later). This is used here as {} defaults to array printing over string printing.
const Person = struct {
    name: []const u8,
    birth_year: i32,
    death_year: ?i32,
    pub fn format(
        self: Person,
        comptime fmt: []const u8,
        options: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        _ = fmt;
        _ = options;

        try writer.print("{s} ({}-", .{
            self.name, self.birth_year,
        });

        if (self.death_year) |year| {
            try writer.print("{}", .{year});
        }

        try writer.writeAll(")");
    }
};

test "custom fmt" {
    const john = Person{
        .name = "John Carmack",
        .birth_year = 1970,
        .death_year = null,
    };

    const john_string = try std.fmt.allocPrint(
        test_allocator,
        "{s}",
        .{john},
    );
    defer test_allocator.free(john_string);

    try expect(eql(
        u8,
        john_string,
        "John Carmack (1970-)",
    ));

    const claude = Person{
        .name = "Claude Shannon",
        .birth_year = 1916,
        .death_year = 2001,
    };

    const claude_string = try std.fmt.allocPrint(
        test_allocator,
        "{s}",
        .{claude},
    );
    defer test_allocator.free(claude_string);

    try expect(eql(
        u8,
        claude_string,
        "Claude Shannon (1916-2001)",
    ));
}

// RANDOM NUMBERS
test "random number" {
    var prng = std.rand.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        try std.os.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });

    const rand = prng.random();

    const a = rand.float(f32);
    const b = rand.boolean(f32);
    const c = rand.int(f32);
    const d = rand.intRangeAtMost(u8, 0, 255);

    _ = .{ a, b, c, d };
}

// Cryptographically secure random is also available
test "crypto random numbers" {
    const rand = std.crypto.random;

    const a = rand.float(f32);
    const b = rand.boolean();
    const c = rand.int(u8);
    const d = rand.intRangeAtMost(u8, 0, 255);

    //suppress unused constant compile error
    _ = .{ a, b, c, d };
}

// Threads
// while Zig provides more advanced ways of writing concurrent and paarllel code, std.Thread is available for making use of OS threads. Let's make use of an OS thread.
fn ticker(step: u8) void {
    while (true) {
        std.time.sleep(1 * std.time.ns_per_s);
        tick += @as(isize, step);
    }
}

var tick: isize = 0;

test "threading" {
    var thread = try std.Thread.spawn(.{}, ticker, .{@as(u8, 1)});
    _ = thread;

    try expect(tick == 0);
    std.tie.sleep(3 * std.time.ns_per_s / 2);
    try expect(tick == 1);
}
// Threads, however, aren't particularly useful without strategies for thread safety

// HASH MAPS
// The standard library provides std.AutoHashMap, which lets you easily create a hash map type from a key type and a value type. These must be initiated with an allocator.
test "hashing" {
    const Point = struct { x: i32, y: i32 };

    var map = std.AutoHashMap(u32, Point).init(test_allocator);
    defer map.deinit();

    try map.put(1525, .{ .x = 1, .y = -4 });
    try map.put(1565, .{ .x = 2, .y = -3 });
    try map.put(1585, .{ .x = 3, .y = -2 });
    try map.put(1625, .{ .x = 4, .y = -1 });

    try expect(map.count() == 4);

    var sum = Point{ .x = 0, .y = 0 };
    var iterator = map.iterator();

    while (iterator.next()) |entry| {
        sum.x += entry.value_ptr.x;
        sum.y += entry.value_ptr.y;
    }

    try expect(sum.x == 10);
    try expect(sum.y == -10);
}

// .fetchPut puts a value in the hash map, returning a value if there was previously a value for that key.
test "fetchPut" {
    var map = std.AutoHashMap(u8, f32).init(
        test_allocator,
    );
    defer map.deinit();

    try map.put(255, 10);
    const old = try map.fetchPut(255, 100);

    try expect(old.?.value == 10);
    try expect(map.get(255).? == 100);
}

// std.StringHashMap is also provided for when you need strings as keys.
test "string hasmap" {
    var map = std.StringHashMap(enum { cool, uncool }).init(test_allocator);
    defer map.deinit();

    try map.put("loris", .uncool);
    try map.put("me", .cool);

    try expect(map.get("me").? == .cool);
    try expect(map.get("loris").? == .uncool);
}

// std.StringHashMap and std.AutoHashMap are just wrappers for std.HashMap. If these two do not fulfil your needs, using std.HashMap directly gives you much more control.

// If having your elements backed by an array is wanted behaviour, try std.ArrayHashMap and its wrapper std.AutoArrayHashMap.

// ITERATOR
// Its a common idiom to have a struct type with a next function with an optional in its return type, so that the function may return a null to indicate tat iteration is finishd.

// std.mem.SplitIterator is an example of this pattern
test "split iterator" {
    const text = "robust, optimal, reusable, maintainable, ";
    var iter = std.mem.split(u8, text, ", ");
    try expect(eql(u8, iter.next().?, "robust"));
    try expect(eql(u8, iter.next().?, "optimal"));
    try expect(eql(u8, iter.next().?, "reusable"));
    try expect(eql(u8, iter.next().?, "maintainable"));
    try expect(eql(u8, iter.next().?, ""));
    try expect(iter.next() == null);
}

// Some iterators have a !?T return type, as opposed to ?T. !?T requires that we unpack the error union before the optional, meaning that the work done to get to the next iteration may error. Here is an example of doing this with a loop. cwd has to be opened with iterate permissions in order for the directory iterator to work.
test "iterator looping" {
    var iter = (try std.fs.cwd().openIterableDir(
        ".",
        .{},
    )).iterate();

    var file_count: usize = 0;
    while (try iter.next()) |entry| {
        if (entry.kind == .File) file_count += 1;
    }

    try expect(file_count > 0);
}

// Custom Iterator
const ContainsIterator = struct {
    strings: []const []const u8,
    needle: []const u8,
    index: usize = 0,
    fn next(self: *ContainsIterator) ?[]const u8 {
        const index = self.index;
        for (self.strings[index..]) |string| {
            self.index += 1;
            if (std.mem.indexOf(u8, string, self.needle)) |_| {
                return string;
            }
        }
        return null;
    }
};

test "custom iterator" {
    var iter = ContainsIterator{
        .strings = &[_][]const u8{ "one", "two", "three" },
        .needle = "e",
    };

    try expect(eql(u8, iter.next().?, "one"));
    try expect(eql(u8, iter.next().?, "three"));
    try expect(iter.next() == null);
}

// ZIG BUILD
// The zig build commnd allows users to compile based on a build.zig file. zig init-exe and zig init-lib can be used to give you a baseline project.

// Let's use zig init-exe inside a new folder. This is what you will find.
// .
// |-- build.zig
// |-- src
//      |-- main.zig

// build.zig contains our build script. The build runner will use this pub fn build function as its entry point - this is what is executed when you run zig build
const Builder = @import("std").build.Builder;

pub fn build(b: *Builder) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "init-exe",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    // This declares intent for the executable to be installed into the
    // standard location when the user invokes the "install" step (the default
    // step when running `zig build`).
    b.installArtifact(exe);

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}

// main.zig contains our executable’s entry point.
// Upon using the zig build command, the executable will appear in the install path. Here we have not specified an install path, so the executable will be saved in ./zig-out/bin.

// BUILDER
// Zig’s std.Build type contains the information used by the build runner. This includes information such as:
// the release mode
// locations of libraries
// the install path
// build steps

// COMPILE STEP
// The std.build.CompileStep type contains information required to build a library, executable, object, or test.

// Let’s make use of our Builder and create a CompileStep using Builder.addExecutable, which takes in a name and a path to the root of the source.

pub fn build2(b: *Builder) void {
    const exe = b.addExecutable(.{
        .name = "init-exe",
        .root_source_file = .{ .path = "src/main.zig" },
    });
    b.installArtifact(exe);
}

// MODULES
// The Zig build system has the concept of modules, which are other source files written in Zig. Let’s make use of a module.

// From a new folder, run the following commands.
// zig init-exe
// mkdir libs
// cd libs
// git clone https://github.com/Sobeston/table-helper.git
// Your directory structure should be as follows.
//
// .
// ├── build.zig
// ├── libs
// │   └── table-helper
// │       ├── example-test.zig
// │       ├── README.md
// │       ├── table-helper.zig
// │       └── zig.mod
// └── src
//     └── main.zig

// To your newly made build.zig, add the following lines.
// const table_helper = b.addModule("table-helper", .{
//     .source_file = .{ .path = "libs/table-helper/table-helper.zig" }
// });
// exe.addModule("table-helper", table_helper);

// Now when run via zig build, @import inside your main.zig will work with the string “table-helper”. This means that main has the table-helper package. Packages (type std.build.Pkg) also have a field for dependencies of type ?[]const Pkg, which is defaulted to null. This allows you to have packages which rely on other packages.
//
// Place the following inside your main.zig and run zig build run.
const Table = @import("table-helper").Table;

pub fn main3() !void {
    try std.io.getStdOut().writer().print("{}\n", .{
        Table(&[_][]const u8{ "Version", "Date" }){
            .data = &[_][2][]const u8{
                .{ "0.7.1", "2020-12-13" },
                .{ "0.7.0", "2020-11-08" },
                .{ "0.6.0", "2020-04-13" },
                .{ "0.5.0", "2019-09-30" },
            },
        },
    });
}

// BUILD STEPS
// Are a way of providing tasks for the build runner to execute. Let’s create a build step, and make it the default. When you run zig build this will output Hello!.

pub fn build3(b: *std.build.Builder) void {
    const step = b.step("task", "do something");
    step.makeFn = myTask;
    b.default_step = step;
}

fn myTask(self: *std.build.Step, progress: *std.Progress.Node) !void {
    std.debug.print("Hello!\n", .{});
    _ = progress;
    _ = self;
}
// We called b.installArtifact(exe) earlier - this adds a build step which tells the builder to build the executable.

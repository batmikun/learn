const std = @import("std");
// Zig has no runtime, hence, no automatic memory management. It's the developer's responsibility to manage the allocation/deallocation of memories. It's importante to know how memory allocation works, where your data is stored, and what to do with them

// Where data is stored in Zig program?

// String lterals, comptime variables, top-level var, struct-level var, and const declarations are stored in the global constant data section.

// Function-level var variables are stored in the function's stck frame, once teh function returns, any pointers to variables in the function's stack frame will become invalid.

// So, Zig will not stop you from making mistakes like this:
const Node = struct { value: i32, left: Node, right: Node };

fn createNode(value: i32) *Node {
    var node = Node{ .value = value, .left = null, .right = null };

    return &node;
}

// In the code above, we return a pointer to a Node object that was created inside the createNode function. This object, however, will be freed after the createNode functions returns, and won't be valid anymore. Any dereference to this pointer will lead to undefined behaivour.

// This also explains why you are able to return a string literal will lead to undefined behaviour.

fn sayHello() []const u8 {
    return "hello world";
}

// How to choose an allocator?

// In the above example, the right way to return a pointer from a functions is to first allocate some memory for the pointer and initialize the Node struct to that pointer.

// Unlike C, Zig does not come with any default allocator, so we need to determine which allocator we should use based on our use case.

// It's a convention in Zig that a function or struct that needs t perform memory allocation accepts an Allocator parameter.

// The rules of thumb to choose an allocator is:

// - If we are making a library, do not specify any allocator, butlet the user pass their desired Allocator as a parameter into our library and use it.

// - If we are linking with libc, use std.heap.c_allocator.

// - If the maximun memory size is known or need to be bound by any number at compile time, use std.heap.FixedBufferAllocator or std.heap.ThreadSafeFixedBufferAllocator.

// - If we are making a program that runs straight from start to end, like a CLI program, and it would make sens to free everything at once at the end, use something like
fn arena_() void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    // pass the reference of this allocator to other struct as needed
    var allocator = &arena.allocator();
    _ = allocator;
}

// The call to arena.deinit() will try to automatically traverse and free everything we allocated during the program.

// - Otherwise, use std.heap.GeneralPurposeAllocator, this allocator gives us the ability to detect memory leak, but it does not automatically free everything.
fn gpa_() void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(!gpa.deinit());

    // pass the reference of this allocator to other struct as needed
    var allocator = &gpa.allocator();
    _ = allocator;
}

// We also need to handle allocation error when using allocator, most of the time, an error named error.OutOfMemory will be returned and must be catch
fn createNode2(allocator: *std.Allocator, value: i32) !*Node {
    const result = try allocator.create(Node);
    result.* = Node{ .value = value };
    return result;
}

fn main2() void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = &gpa.allocator();
    defer allocator.destroy();

    var node = createNode2(allocator, 12) catch |err| {
        std.debug.print("Error: Out of memory\n{}\n", .{err});
        return null;
    };
    _ = node;
}

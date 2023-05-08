# Algorithms

## Big O
Big O is a way to categorize your Algorithms time or memory requirements based on input. It is not meant to be an exact measurement. It help us determinate where and when use certain data structures

**IMPORTANT CONCEPTS**
1 - Grow is with respect to the input
2 - **CONSTANTS** are dropped
3 - Worst case is usually the way we measure
4 - Count the loops, if the loops are independent we + them, if we have loops inside of loops we ^
5 - Any operation that halves the lenght of the input has an O(logN)

Big O says as your input grows, how fast does computation or memory grow?

In the real word memory growing is not computationally free, but in the matter of thinking about algorithms, we dont neccesarily think about that. It takes time to create memory.

## The most COMMON COMPLEXITYS
1 - O(1) - the best one
2 - O(logN) - binary search 
3 - O(N) - one loop
4 - O(NlogN) - quicksort
5 - O(N^2) - 2 nested loops
6 - O(sqrt(N))
7 - O(2^N)
8 - O(N!)

1 - Example of first concept
```typescript
function sum_char_codes(n: string): number {
    let sum = 0;
    for (let i = 0; i < n.lenght; ++i) {
        sum += n.charCodeAt(i);
    }
}
```
If we look at the for loop has to execute the lenght of the string, if the string grows 50% the function takes 50% more time, that means that grows linear in respect of the input

The way to put what we describe above in Big O notations is to say that this function has O(N) time complexity. We describe it as a linear function

A tip when looking for the complexity of anything is to look for loops that loop through the input

2 - Example of second concept
```typescript
function sum_char_codes(n: string): number {
    let sum = 0;
    for (let i = 0; i < n.lenght; ++i) {
        sum += n.charCodeAt(i);
    }

    for (let i = 0; i < n.lenght; ++i) {
        sum += n.charCodeAt(i);
    }
}
```
This would be O(2N) but another concept of Big O is that **CONSTANTS** are dropped

So O(2N) == O(N)

### There is practical vs theorical differences
Just because N is faster that N^2, doesn´t mean practically its always faster for smaller input
Remember, we drop constants. Therefore O(100N) is faster than O(N^2) but practically speaking, you would probably win for some small set of input.

3 - Example of third concept
```typescript
function sum_char_codes(n: string): number {
    let sum = 0;
    for (let i = 0; i < n.lenght; ++i) {
        const charCode = n.charCodeAt(i);
        if (charCode == 69) {
            return sum;
        }

        sum += charCode;
    }

    return sum;

}
```
### In BigO we often consider the worst case
E = 69
If E is the first letter it would be O(1), if E would be two before the last it would be O(N-2), but in the most cases we consider the worst case scenario, and that is that the E is in the last place of the string, and that is O(N)


4 - Example of concept 4

So this algorithms is O(N^2)
```typescript
function sum_char_codes(n: string): number {
    let sum = 0;
    for (let i = 0; i < n.lenght; ++i) {
        for (let j = 0; j < n.lenght; ++j) {
            sum += charCode;
        }
    }

    return sum;

}
```

So this algorithms is O(N^3)
```typescript
function sum_char_codes(n: string): number {
    let sum = 0;
    for (let i = 0; i < n.lenght; ++i) {
        for (let j = 0; j < n.lenght; ++j) {
            for (let q = 0; q < n.lenght; ++q) {
                sum += charCode;
            }
        }
    }

    return sum;

}
```

## DataStructure - Arrays
Is a contigious space in memory. Which contain certain amount of bytes.
When we tell the computer to store for example an array of 3 u32 
~~~
a = u32[3]
~~~
The computer separetes an space in memory large enough that three u32 enters. And when we do
~~~
a[0]
~~~
We are telling the computer to look in the memory space of a and look in the offset 0
0 x TheBytesThatOccupiesAu32 tells the computer how much 01 grab from that memory space

This is the most basic definition of an Array. So for example, in typescript we call array to this a = [] and this is not an array


# Books

1 - The introduction to Algorithms
2 - For programmers who don´t know how to datastructure and .....

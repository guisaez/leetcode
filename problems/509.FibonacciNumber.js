/*
The Fibonacci numbers, commonly denoted F(n) form a sequence, called the Fibonacci 
sequence, such that each number is the sum of the two preceding ones, starting from 
0 and 1. That is,

F(0) = 0, F(1) = 1
F(n) = F(n-1) + F(n-2)
for n > 1

Given n, calculate F(n) using Dynamic Programing Bottom Up Memoization
*/

var fib = function(n){
    var mem = [0,1];

    for(let i = 2; i <= n; i++){
        mem[i] = mem[i - 1] + mem[i - 2];
    }

    return mem[n]; 
}
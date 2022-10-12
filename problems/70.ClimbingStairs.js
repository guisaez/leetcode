/*
You are climbing a staircase. It takes n steps
to reach the top.

Each time you can either climb 1 or 2 steps.
In how many distinct ways can you climb to the top?

Input: n = 2
Output: 2
Explanation: There are two ways to climb to the top.
1. 1 step + 1 step
2. 2 steps

Input: n = 3
Output: 3
Explanation: There are three ways to climb to the top.
1. 1 step + 1 step + 1 step
2. 1 step + 2 steps
3. 2 steps + 1 step

Solved using Dynamic Programming.
*/

/**
 * @param {number} n
 * @return {number}
 */
 var climbStairs = function(n) {
    if (n === 1) return 1;
    if (n === 2) return 2;

    var stairCase= [1, 2]
    
    for(let i = 3; i <= n; i++){
        stairCase[i - 1] = stairCase[i - 2] + stairCase[i - 3];
    }
    
    return stairCase[n - 1];
};
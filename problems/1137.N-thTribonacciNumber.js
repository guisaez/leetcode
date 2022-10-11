/*
The Tribonacci sequence Tn is defined as follows: 
T0 = 0, T1 = 1, T2 = 1, and Tn+3 = Tn + Tn+1 + Tn+2 for n >= 0.
Given n, return the value of Tn.

Input: n = 4
Output: 4
Explanation:
T_3 = 0 + 1 + 1 = 2
T_4 = 1 + 1 + 2 = 4

Input: n = 25
Output: 1389537
*/

/**
 * @param {number} n
 * @return {number}
 */
 var tribonacci = function(n) {
    var mem = [0,1,1];
    
    for(let i = 3; i <= n; i++){
        mem[i] = mem[i - 1] + mem[i - 2] + mem[i-3];
    }
    
    return mem[n]
    
};
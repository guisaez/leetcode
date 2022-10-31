/*
You have n dice, and each die has k faces numbered from 1 to k.
Given three integers n, k, and target, return the number of 
possible ways (out of the kn total ways) to roll the dice, 
so the sum of the face-up numbers equals target. Since the 
answer may be too large, return it modulo 109 + 7.

 
Example 1:
Input: n = 1, k = 6, target = 3
Output: 1
Explanation: You throw one die with 6 faces.
There is only one way to get a sum of 3.

Example 2:
Input: n = 2, k = 6, target = 7
Output: 6
Explanation: You throw two dice, each with 6 faces.
There are 6 ways to get a sum of 7: 1+6, 2+5, 3+4, 4+3, 5+2, 6+1.

Example 3:
Input: n = 30, k = 30, target = 500
Output: 222616187
Explanation: The answer must be returned modulo 109 + 7.
 
Constraints:
1 <= n, k <= 30
1 <= target <= 1000 
 */

class Solution {
    
    private final int MOD = 1000000007;
    
    private int numRollsHelper(Integer[][] dp, int dice, int n, int sum, int target, int k){
        
        if(dice == n){
            return sum == target ? 1 : 0;
        }
        
        if(dp[dice][sum] != null) {
            return dp[dice][sum];
        }
        
        int ways = 0;
        
        for(int i = 1; i <= Math.min(k, target - sum); i++){
            ways = (ways + numRollsHelper(dp, dice+1, n,  sum + i, target, k)) % MOD;
        }
        
        return dp[dice][sum] = ways;
    }
    
    public int numRollsToTarget(int n, int k, int target) {
        
        Integer[][] dp = new Integer[n + 1][target + 1];
        return numRollsHelper(dp, 0, n, 0, target, k);
    }
    
}
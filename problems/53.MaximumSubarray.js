/*
Given an integer array nums, find the contiguous subarray 
(containing at least one number) which has the largest sum and return its sum.

A subarray is a contiguous part of an array.

Example 1:
Input: nums = [-2,1,-3,4,-1,2,1,-5,4]
Output: 6
Explanation: [4,-1,2,1] has the largest sum = 6.

Example 2:
Input: nums = [1]
Output: 1

Example 3:
Input: nums = [5,4,-1,7,8]
Output: 23
 
Constraints:
1 <= nums.length <= 105
-104 <= nums[i] <= 104
 
Follow up: If you have figured out the O(n) solution, try coding another 
solution using the divide and conquer approach, which is more subtle.
*/

/*
PrefixSum + Brute Force
Time Complexity: O(n^2)
Space Complexity: O(1)
*/
var maxSubArraySol1 = function(nums) {
    
    var n = nums.length;
    
    var maxSum = -Number.MAX_VALUE;
    
    var dp = [nums[0]];
    
    for(let i = 0; i < n; i++){
        var sum = 0;
        for(let j = i; j < n; j++){
            sum += nums[j];
            maxSum = Math.max(maxSum, sum);
        }
    }
    return maxSum;
};

/*
Optimized Prefix Sum
Time Complexity: O(n)
Space Complexity: O(1)
*/
var maxSubArraySol2 = function(nums){
    var n = nums.length;

    var max = nums[0];

    var min = 0;
    var sum = 0;

    for(let i = 0; i < n; i++){
        sum += nums[i];
        if(sum - min > max) max = sum - min;
        if(sum < min){
            min = sum;
        }
    }

    return max;
}

/*
Dynamic Programming
*/
var maxSubArraySol3 = function(nums){

}


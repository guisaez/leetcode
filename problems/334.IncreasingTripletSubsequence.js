/*
Given an integer array nums, return true if there exists a triple of
indices (i, j, k) such that i < j < k and nums[i] < nums[j] < nums[k].
If no such indices exists, return false.

Input: nums = [1,2,3,4,5]
Output: true
Explanation: Any triplet where i < j < k is valid. \

Constraints:
1 <= nums.length <= 5 * 10^5
-2^31 <= nums[i] <= 2^31 - 1
*/

/**
 * @param {number[]} nums
 * @return {boolean}
 */
var increasingTriplet = function(nums){

    var smallest = Math.pow(2, 31) - 1;
    var middle = Math.pow(2, 31) - 1;

    for(let i =0; i < nums.length; i++){
        if(nums[i] < smallest){
            smallest = nums[i];
        }else{
            if(smallest < nums[i] && nums[i] < middle){
                middle = nums[i];
            }else{
                if(smallest < middle && middle < nums[i]){
                    return true;
                }
            }
        }
    }

    return false;
}

// Time Complexity: O(n)
// Space Complexity: O(1)
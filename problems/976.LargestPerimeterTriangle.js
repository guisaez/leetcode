/*
Given an integer array nums, return the largest perimeter of a triangle with
a non-zero area, formed from three of these lengths. If it is impossible to form any triangle
of a non-zero area, return 0.

Input: nums = [2,1,2]
Output: 5

Input: nums = [1,2,1]
Output: 0
*/
/**
 * @param {number[]} nums
 * @return {number}
 */
 var largestPerimeter = function(nums) {
    // Triangle Properties
    // A + B > C && A + C < B && B + C > A
    
    // PERIMETER A + B + C
    
    nums.sort((a,b) => a - b);
    var perimeter = 0;
    for(let i = 0; i < nums.length - 2; i++){
        var a = nums[i];
        var b = nums[i+1];
        var c = nums[i+2]
        
        if((a + b) > c && (a + c) > b && (a + c) > b){
            var perimeter = Math.max(perimeter, a + b + c);
        }
    }
    
    return perimeter;
};
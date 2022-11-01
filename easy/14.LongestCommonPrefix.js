/**
 * Write a function to find the longest common prefix string amongst 
 * and array of strings.
 * 
 * If there is not common prefix, return an empty string "".
 * 
 * Example 1:
 * Input: strs = ["flower", "flow", "flight"]
 * Output: "fl"
 * 
 * Example 2:
 * Input: strs = ["dog", "racecar", "car"]
 * Output: ""
 * Explanation: There is no common prefix among the input strings.
 */

/**
 * @param {string[]} strs
 * @return {string}
 */
 var longestCommonPrefix = function(strs) {
    
    strs.sort((a , b) => a.length - b.length);
    
    var prefix = strs[0];
    
    var end = prefix.length;
    
    for(let i = 1; i < strs.length; i++){
        if(prefix != strs[i].substring(0, end)){
            prefix = prefix.substring(0, end - 1);
            end--;
            i--;
        }
    }
    
    return prefix;
};
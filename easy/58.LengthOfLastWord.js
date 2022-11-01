/**
 * Given a string s consisting of words and spaces, return the length of the last word in the string.
 * A word is a maximal substring of non-space character only.
 * 
 * Example 1:
 * Input: s = "Hello World"
 * Output: 5
 * Explanation: The last word is "World" with length 5.
 * 
 * Example 2: 
 * Input: s = "   fly me   to   the moon  "
 * Output: 4
 * Explanation: The last word is "moon" with length 4
 * 
 * Example 3:
 * Input: s = "luffy is still joyboy"
 * Output: 6
 * Explanation: The last word is "joyboy" with length 6.
 * 
 * Constraints:
 * 1 <= s.length <= 10^4
 * s consists of only English letters and spaces.
 * There will be at least one word in s.
 */
/**
 * @param {string} s
 * @return {number}
 */
 var lengthOfLastWord = function(s) {
    
    
    var count = 0;
    for(let i = s.length - 1; i >= 0; i--){
        if(i > 0 && s.charAt(i-1) == ' ' && s.charAt(i) != ' '){
            return count + 1;
        }
        if(s.charAt(i) != ' '){
            count++;
        }
     }
    
    return count;
};
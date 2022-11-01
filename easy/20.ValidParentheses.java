/**
 * Given a string s containing just the characters
 * '(', ')', '{', '}', '[', ']', determine if the input string is valid.
 * 
 * An input string is valid if:
 * * Open brackets must be closes by the same type of brackets.
 * * Open brackets must be closed in the correct order.
 * * Every close bracket has a corresponding open bracket of the same type.
 * 
 * Example 1:
 * Input: s = "()"
 * Output: true
 * 
 * Example 2:
 * Input: s = "()[]{}"
 * Output: true
 * 
 * Example 3:
 * Input: s = "(]"
 * Output: false
 * 
 * Constraints:
 * 1 <= s.length <+ 10^4
 * s consists of parentheses only '()[]{}'
 */
import java.util.*;

class Solution {
    public boolean isValid(String s) {
        
        
        Stack<Character> stack = new Stack<>();
        
        for(Character c : s.toCharArray()){
            switch(c){
                case '(':
                    stack.add(')');
                    break;
                case '{':
                    stack.add('}');
                    break;
                case '[':
                    stack.add(']');
                    break;
                default:
                    if(stack.isEmpty() || stack.peek() != c){
                        return false;
                    }
                    stack.pop();
            }
        }
        return true && stack.isEmpty();
    }
}
/**
 * Roman numerals are represented by seven different symbols:
 * I, V,X,L,C,D and M.
 * 
 * Given a roman numeral, convert it to an integer.
 * 
 * Example:
 * Input: s = "III"
 * Output: 3
 * Explanation: III = 3
 * 
 * Example 2:
 * Input : s = "MCMXCIV"
 * Output: 1994
 * Explanation: M = 1000, CM = 900, XC = 90, IV = 4.
 */

/**
 * @param {string} s
 * @return {number}
 */
 var romanToInt = function(s) {
    
    const map = new Map();
    
    map.set('I', 1);
    map.set('V', 5);
    map.set('X', 10);
    map.set('L', 50);
    map.set('C', 100);
    map.set('D', 500);
    map.set('M', 1000);
    
    const n = s.length;
    
    var number = 0;
    
    for(let i = 0; i < n; i++){
        var curr = s.charAt(i);
        var next = i + 1 < n ? s.charAt(i+1) : "";
        if(curr == 'I' && (next == 'V' || next == 'X') || curr == 'X' && (next == 'L' || next == 'C') || curr == 'C' && (next == 'D' || next == 'M')){
            number += map.get(next) - map.get(curr);
            i+= 1;
        }
        else{
            number += map.get(curr);
        }
    }
    
    return number;
    
};
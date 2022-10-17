/*
A pangram is a sentence where every letter of the English 
alphabet appears at least once.

Given a string sentence containing only lowercase English 
letters, return true if sentence is a pangram, or false otherwise.
*/

var checkIfPangram = function(sentence){
    return new Set([...sentence]).size == 26;
}

var checkIfPangramInnerImplementation = function(sentence){
    var n = sentence.length;
    
    if(n < 26){
        return false;
    }
    
    var letters = new Set();
    
    for(let i = 0; i < n; i++){
        if(!letters.has(sentence[i])){
           letters.add(sentence[i]);
        }
    }

    return letters.size == 26;
};
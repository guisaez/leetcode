/*
Given an m x n picture consisting of black 'B' and white 'W' pixels, 
return the number of black lonely pixels.

A black lonely pixel is a character 'B' that located at a specific position
where the same row and same column don't have any other black pixels.

Input: 
[['W','W','B'],
 ['W','B','W'],
 ['B','W','W']
]
Output: 3
Explanation: All three 'B's are black lonely pixels.
*/

/**
 * @param {character[][]} picture
 * @return {number}
 */
var findLonelyPixel = function(picture){

    var columns_to_be_checked = [];

    var height = picture.length;
    var width = picture[0].length;

    var result = 0;

    for(let row = 0; row < height; row++){
        var row_sum = 0;
        var column_number = -1;
        for(let column = 0; column < width; column++){
            if(picture[row][column] === 'B'){
                column_number = column;
                row_sum++;
            }
        }
        if(row_sum === 1){
            columns_to_be_checked.push(column_number);
        }
    }

    for(let i = 0; i < columns_to_be_checked.length; i++){
        var sum = 0;
        for(let row = 0; row < height; row++){
            if(picture[row][columns_to_be_checked[i]] === 'B'){
                sum++;
            }
        }

        if(sum === 1){
            result++;
        }
    }

    return result;
}

console.log(findLonelyPixel([['W','W','B'],['W','B','W'],['B','W','W']]))
/*
Given an n x n array of integers matrix, return the minimum sum of 
any falling path through matrix.

A falling path starts at any element in the first row and chooses the
element in the next row that is either directly below or
diagonally left/right. Specifically, the next element
from position (row, col) will be (row + 1, col - 1), (row + 1, col), 
or (row + 1, col + 1).
*/

/**
 * @param {number[][]} matrix
 * @return {number}
 */
 var minFallingPathSum = function(matrix){
    var len = matrix.length;

    var mem = new Array(len).fill(0).map(() => new Array(len).fill(0));

    for(let i = 0; i < len; i++){
        mem[0][i] = matrix[0][i];
    }

    var min = Infinity;
    // Top - Down
    for(let row = 1; row < len; row++){
        for(let column = 0; column < len; column++){
            mem[row][column] = Math.min(
                Math.min(
                    column > 0 ? 
                        mem[row - 1][column -1] 
                        : min,
                    column < len - 1 ? 
                        mem[row - 1][column + 1]
                        : min),
                mem[row - 1][column]) + matrix[row][column];
        }
    }

    for(let i = 0; i < len; i++){
        min = Math.min(min, mem[len - 1][i]);
    }

    return min;
 }
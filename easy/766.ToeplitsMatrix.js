/**
 * Given an m x n matrix, return true if the matrix is Toeplitz. Otherwise, return false.
 * A matrix is Toeplitz if every diagonal from top-left to bottom-right has the same elements.
 * 
 * Example 1:
 * Input: matrix = [[1,2,3,4],[5,1,2,3],[9,5,1,2]]
 * Output: true
 * Explanation:
 * In the above grid, the diagonals are:
 * "[9]", "[5, 5]", "[1, 1, 1]", "[2, 2, 2]", "[3, 3]", "[4]".
 * In each diagonal all elements are the same, so the answer is True.
 * 
 * Constraints:
 * m == matrix.length
 * n == matrix[i].length
 * 1 <= m, n <= 20
 * 0 <= matrix[i][j] <= 99
 */

/**
 * @param {number[][]} matrix
 * @return {boolean}
 */
 var isToeplitzMatrix = function(matrix) {
    
    const n = matrix.length;
    const m = matrix[0].length;
    
    for(let i = 1; i < m; i++){
        
        for(let j = n - 1; j >= 1; j--){
            if(matrix[j][i] != matrix[j - 1][i - 1]){
                return false
            }
        }
    }
    
    return true;
};
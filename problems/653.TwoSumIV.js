/* Given the root of a Binary Search Tree and a target number k, 
return true if there exists two elements in the BST such that their]
sum is equal to the given target.

Example:
Input: root = [5,3,6,2,4,null,7], k = 9
Output: true

       5
     /   \
    3      6
   / \      \
  2   4      7

*/

/**
 * Definition for a binary tree node.
 * function TreeNode(val, left, right) {
 *     this.val = (val===undefined ? 0 : val)
 *     this.left = (left===undefined ? null : left)
 *     this.right = (right===undefined ? null : right)
 * }
 */
/**
 * @param {TreeNode} root
 * @param {number} k
 * @return {boolean}
 */

var findTarget = function(root, k){
    if(!root) return null;

    var sortedArray = [];

    function inOrderTraversal(node){
        if(!node) return null;

        inOrderTraversal(node.left);
        sortedArray.push(node.val);
        inOrderTraversal(node.right);
    }

    inOrderTraversal(root);

    console.log(sortedArray)

    var left = 0;
    var right = sortedArray.length - 1;

    while (left < right){
        var sum = sortedArray[left] + sortedArray[right];

        if(sum === k){
            return true;
        }else{
            if(sum < k){
                left++;
            }else{
                right++;
            }
        }
    }
    return false;
}
/*
You are given the head of a linked list. Delete the middle node, and return the head of the modified linked list.

The middle node of a linked list of size n is the ⌊n / 2⌋th node from the start using 0-based indexing, where ⌊x⌋ denotes the largest integer less than or equal to x.

For n = 1, 2, 3, 4, and 5, the middle nodes are 0, 1, 1, 2, and 2, respectively.

Example 1:

Input: head = [1,3,4,7,1,2,6]
Output: [1,3,4,1,2,6]
Explanation:
The above figure represents the given linked list. The indices of the nodes are written below.
Since n = 7, node 3 with value 7 is the middle node, which is marked in red.
We return the new list after removing this node. 

Example 2:
Input: head = [1,2,3,4]
Output: [1,2,4]
Explanation:
The above figure represents the given linked list.
For n = 4, node 2 with value 3 is the middle node, which is marked in red.

Example 3:
Input: head = [2,1]
Output: [2]
Explanation:
The above figure represents the given linked list.
For n = 2, node 1 with value 1 is the middle node, which is marked in red.
Node 0 with value 2 is the only node remaining after removing node 1.
*/

/**
 * Definition for singly-linked list.
 * function ListNode(val, next) {
 *     this.val = (val===undefined ? 0 : val)
 *     this.next = (next===undefined ? null : next)
 * }
 */
/**
 * @param {ListNode} head
 * @return {ListNode}
 */

// Time Complexity O(n)
// Space Complexity O(1)

var deleteMiddle = function(head) {
    
    var slowPointer = head;
    var fastPointer = head;
    var prev = null;
    
    while(fastPointer != null && fastPointer.next != null){
        prev = slowPointer;
        slowPointer = slowPointer.next;
        fastPointer = fastPointer.next ? fastPointer.next.next : null;
        
    }
   
    if(!prev) return null;
    
    prev.next = slowPointer.next;
    
    return head;
};

// Time Complexity: O(n)
// Space Complexity: O(n)

var deleteMiddleWithArray = function(head){
    var current = head;

    if(!current.next) return null;

    var linked_list_to_array = [];

    while(current !== null){
        linked_list_to_array.push(current);
        current = current.next;
    }

    var position = Math.floor(linked_list_to_array.length / 2) - 1;

    var current = linked_list_to_array[position];

    current.next = current.next.next ? current.next.next : null;

    return head;
}
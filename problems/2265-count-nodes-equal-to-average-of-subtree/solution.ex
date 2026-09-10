# Definition for a binary tree node.
#
# defmodule TreeNode do
#   @type t :: %__MODULE__{
#           val: integer,
#           left: TreeNode.t() | nil,
#           right: TreeNode.t() | nil
#         }
#   defstruct val: 0, left: nil, right: nil
# end

defmodule Solution do
  @spec average_of_subtree(root :: TreeNode.t() | nil) :: integer
  def average_of_subtree(root) do
    {count, _, _} = average_of_subtree_(root)
    count
  end

  @spec average_of_subtree_(TreeNode.t() | nil) :: {integer(), integer(), integer()}
  defp average_of_subtree_(nil), do: {0, 0, 0}

  # This is a leaf node. It does not have child nodes:
  # * NodeCount: 1
  # * Sum: Val
  # * Acc: 1
  defp average_of_subtree_(%TreeNode{left: nil, right: nil, val: val}), do: {1, val, 1}
  # This is a parent node.
  # * NodeCount: 1 + NodeCountLeft + NodeCountRight
  # * Sum: Val + SumLeft + SumRight
  # * Average: Floor(Sum/NodeCount)
  # * Acc: if Average == Val, do: Acc + 1, else: Acc
  defp average_of_subtree_(%TreeNode{left: left, right: right, val: val}) do
    {left_acc_count, sum_left, nodes_left} = average_of_subtree_(left)
    {right_acc_count, sum_right, nodes_right} = average_of_subtree_(right)

    new_sum = sum_left + sum_right + val
    nodes_count = nodes_left + nodes_right + 1

    if div(new_sum, nodes_count) == val do
      {left_acc_count + right_acc_count + 1, new_sum, nodes_count}
    else
      {left_acc_count + right_acc_count, new_sum, nodes_count}
    end
  end
end

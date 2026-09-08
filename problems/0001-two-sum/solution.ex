defmodule Solution do
  @spec two_sum(nums :: [integer], target :: integer) :: [integer]
  def two_sum(nums, target) do
    Enum.reduce_while(nums, {%{}, 0}, fn num, {map, idx} ->
      complement = target - num

      case map[complement] do
        nil -> {:cont, {Map.put(map, num, idx), idx + 1}}
        comp_idx -> {:halt, [comp_idx, idx]}
      end
    end)
  end
end

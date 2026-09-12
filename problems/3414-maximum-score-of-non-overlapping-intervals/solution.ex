defmodule Solution do
  @max_intervals 4

  @spec maximum_weight(intervals :: [[integer]]) :: [integer]
  def maximum_weight(intervals) do
    indexed =
      intervals
      |> Enum.with_index()
      |> Enum.map(fn {[start, finish, weight], idx} -> {start, finish, weight, idx} end)
      |> Enum.sort_by(fn {_, finish, _, idx} -> {finish, idx} end)

    n = length(indexed)
    arr = :array.from_list(indexed)
    j = build_j(arr, n)
    dp = build_dp(arr, j, n)

    {_, indices} = Map.get(dp, {@max_intervals, n}, {0, []})
    Enum.sort(indices)
  end

  defp better({w1, idxs1}, {w2, idxs2}) do
    w1 > w2 or (w1 == w2 and idxs1 < idxs2)
  end

  defp build_j(arr, n) do
    j_list =
      Enum.map(0..(n - 1), fn i ->
        {start, _, _, _} = :array.get(i, arr)
        binary_search(arr, start, i - 1)
      end)

    :array.from_list(j_list)
  end

  defp build_dp(arr, j, n) do
    empty = {0, []}

    Enum.reduce(1..@max_intervals, %{}, fn r, dp ->
      Enum.reduce(1..n, dp, fn i, dp ->
        {_, _, weight, orig_idx} = :array.get(i - 1, arr)

        skip_val = Map.get(dp, {r, i - 1}, empty)

        compatible_i = :array.get(i - 1, j)
        {prev_weight, prev_idxs} = Map.get(dp, {r - 1, compatible_i + 1}, empty)

        take_val = {weight + prev_weight, Enum.sort([orig_idx | prev_idxs])}

        best = if better(take_val, skip_val), do: take_val, else: skip_val
        Map.put(dp, {r, i}, best)
      end)
    end)
  end

  defp binary_search(_arr, _start, right) when right < 0, do: -1

  defp binary_search(arr, start, right) do
    do_bsearch(arr, start, 0, right, -1)
  end

  defp do_bsearch(arr, start, left, right, answer) when left <= right do
    mid = div(left + right, 2)
    {_, finish, _, _} = :array.get(mid, arr)

    if finish < start do
      do_bsearch(arr, start, mid + 1, right, mid)
    else
      do_bsearch(arr, start, left, mid - 1, answer)
    end
  end

  defp do_bsearch(_arr, _start, _left, _right, answer), do: answer
end

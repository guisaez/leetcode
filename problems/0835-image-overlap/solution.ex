defmodule Solution do
  @spec largest_overlap(img1 :: [[integer]], img2 :: [[integer]]) :: integer
  def largest_overlap(img1, img2) do
    m1 = to_coord_list(img1)
    m2 = to_coord_list(img2)
    translations = for {x1, y1} <- m1, {x2, y2} <- m2, do: {x2 - x1, y2 - y1}
    count_max(translations)
  end

  defp count_max([]), do: 0

  defp count_max(translations) do
    counts =
      Enum.reduce(translations, %{}, fn t, map ->
        Map.update(map, t, 1, &(&1 + 1))
      end)

    Enum.reduce(counts, 0, fn {_, v}, max -> max(v, max) end)
  end

  defp to_coord_list(grid) do
    grid
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, y} ->
      row
      |> Enum.with_index()
      |> Enum.flat_map(fn
        {1, x} -> [{x, y}]
        {_, _} -> []
      end)
    end)
  end
end

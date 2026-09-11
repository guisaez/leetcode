defmodule Solution do
  @spec total_numbers(digits :: [integer]) :: integer
  def total_numbers(digits) do
    freq_map =
      Enum.reduce(digits, %{}, fn digit, acc ->
        Map.update(acc, digit, 1, &(&1 + 1))
      end)

    count_by_hundreds(Map.keys(freq_map), freq_map, 0)
  end

  defp count_by_hundreds([], _freq_map, count), do: count

  defp count_by_hundreds([0 | rest], freq_map, count) do
    count_by_hundreds(rest, freq_map, count)
  end

  defp count_by_hundreds([hundreds | rest], freq_map, count) do
    remaining = Map.update(freq_map, hundreds, 0, &(&1 - 1))
    count_by_hundreds(rest, freq_map, count + count_by_units(remaining))
  end

  defp count_by_units(freq_map) do
    freq_map
    |> Map.keys()
    |> Enum.reduce(0, fn units, count ->
      cond do
        Map.get(freq_map, units) == 0 ->
          count

        rem(units, 2) != 0 ->
          count

        true ->
          remaining = Map.update(freq_map, units, 0, &(&1 - 1))
          count + count_available_middles(remaining)
      end
    end)
  end

  defp count_available_middles(freq_map) do
    freq_map
    |> Map.values()
    |> Enum.count(&(&1 > 0))
  end
end

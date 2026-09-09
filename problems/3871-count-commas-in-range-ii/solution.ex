defmodule Solution do
  @spec count_commas(n :: integer) :: integer
  def count_commas(n) when n < 1000, do: 0

  def count_commas(n) do
    count_commas(n, log1000(n), 0)
  end

  defp count_commas(_n, 0, acc), do: acc

  defp count_commas(n, tier, acc) do
    tier_start = pow1000(tier)
    tier_end = min(n, pow1000(tier + 1) - 1)
    count_commas(n, tier - 1, acc + tier * (tier_end - tier_start + 1))
  end

  defp pow1000(0), do: 1
  defp pow1000(k), do: 1000 * pow1000(k - 1)

  def log1000(n) when n < 1000, do: 0
  def log1000(n), do: 1 + log1000(div(n, 1000))
end

defmodule SolutionTest do
  use ExUnit.Case

  test "example 1" do
    assert Solution.count_commas(1002) == 3

    assert Solution.count_commas(1_000_002) == 999_006
  end
end

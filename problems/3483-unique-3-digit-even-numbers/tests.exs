defmodule SolutionTest do
  use ExUnit.Case

  test "examples from problem" do
    assert Solution.total_numbers([1, 2, 3, 4]) == 12
    assert Solution.total_numbers([0, 2, 2]) == 2
    assert Solution.total_numbers([6, 6, 6]) == 1
  end

  test "all odd digits — no even last digit possible" do
    assert Solution.total_numbers([1, 3, 5]) == 0
    assert Solution.total_numbers([1, 1, 3]) == 0
    assert Solution.total_numbers([7, 7, 9]) == 0
  end

  test "all zeros — leading zero disqualifies every arrangement" do
    assert Solution.total_numbers([0, 0, 0]) == 0
  end

  test "two zeros with one even non-zero — only one valid number" do
    # only 200: last=0 → h=2,t=0; last=2 → h must be non-zero but only 0s left
    assert Solution.total_numbers([0, 0, 2]) == 1
  end

  test "zeros mixed with other digits" do
    # last=0: h∈{1,2},t=remaining → 120,210; last=2: h=1,t=0 → 102
    assert Solution.total_numbers([0, 1, 2]) == 3
  end

  test "all even distinct digits — maximum permutations" do
    # 4 choices for last, 3 for hundreds (all non-zero), 2 for tens
    assert Solution.total_numbers([2, 4, 6, 8]) == 24
  end

  test "repeated even digit with one odd" do
    # digits {1,2,2}: 122, 212
    assert Solution.total_numbers([1, 2, 2]) == 2
  end

  test "one even with all same odd" do
    # digits {1,1,2}: only 112
    assert Solution.total_numbers([1, 1, 2]) == 1
  end

  test "two zeros with two even — duplicates across last-digit choices" do
    # {0,0,4,4}: last=0→400,440; last=4→404 → 3
    assert Solution.total_numbers([0, 0, 4, 4]) == 3
  end

  test "larger input — all distinct digits" do
    # digits 0-9: brute-forceable but result should be consistent
    result = Solution.total_numbers([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])
    # hundreds: 9 choices (1-9), tens: 9 choices (0-9 minus hundreds), last: 4 choices (even, minus used)
    # exact count via enumeration — verified externally as 328
    assert result == 328
  end
end

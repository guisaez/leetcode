#!/usr/bin/env elixir
# Usage: elixir scripts/run_tests.exs <slug-or-id>
#   elixir scripts/run_tests.exs two-sum
#   elixir scripts/run_tests.exs 0001

ExUnit.start()

arg = List.first(System.argv()) || raise "usage: elixir run_tests.exs <slug-or-id>"

problems_dir = Path.expand(Path.join(__DIR__, "../problems"))

folder =
  problems_dir
  |> File.ls!()
  |> Enum.filter(&String.contains?(&1, arg))
  |> case do
    [] -> raise "no problem folder matching '#{arg}' found in #{problems_dir}"
    [name] -> Path.join(problems_dir, name)
    many -> raise "ambiguous match for '#{arg}': #{inspect(many)} — be more specific"
  end

solution_path = Path.join(folder, "solution.ex")
tests_path = Path.join(folder, "tests.exs")

unless File.exists?(solution_path),
  do: raise("no solution.ex in #{folder}")

unless File.exists?(tests_path),
  do: raise("no tests.exs in #{folder} — create one with your test cases")

IO.puts("Testing: #{Path.basename(folder)}\n")

Code.require_file(solution_path)
Code.require_file(tests_path)

ExUnit.run()

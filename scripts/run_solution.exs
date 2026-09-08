#!/usr/bin/env elixir
# Usage: elixir scripts/run_solution.exs <slug-or-id> [--lang elixir|go|python|erlang] [--submit]
#   elixir scripts/run_solution.exs two-sum
#   elixir scripts/run_solution.exs 0001 --lang go
#   elixir scripts/run_solution.exs two-sum --submit

Code.require_file(Path.join(__DIR__, "common.exs"))

defmodule LeetcodeTracker.RunSolution do
  alias LeetcodeTracker.Common

  @base_url "https://leetcode.com"

  @languages %{
    "python" => {"python3", "py"},
    "elixir" => {"elixir", "ex"},
    "erlang" => {"erlang", "erl"},
    "go" => {"golang", "go"}
  }

  @question_query """
  query questionData($titleSlug: String!) {
    question(titleSlug: $titleSlug) {
      questionId
      titleSlug
      exampleTestcaseList
    }
  }
  """

  def run(argv) do
    {opts, args, _} = OptionParser.parse(argv, strict: [lang: :string, submit: :boolean])

    arg =
      List.first(args) ||
        raise "usage: elixir scripts/run_solution.exs <slug-or-id> [--lang elixir|go|python|erlang] [--submit]"

    lang = opts[:lang] || "elixir"
    submit? = opts[:submit] || false

    {lc_slug, ext} =
      Map.get(@languages, lang) ||
        raise "unknown lang '#{lang}'. choose from: #{Map.keys(@languages) |> Enum.join(", ")}"

    problems_dir = Path.expand(Path.join(__DIR__, "../problems"))

    folder =
      problems_dir
      |> File.ls!()
      |> Enum.filter(&String.contains?(&1, arg))
      |> case do
        [] -> raise "no problem folder matching '#{arg}' found"
        [name] -> Path.join(problems_dir, name)
        many -> raise "ambiguous match '#{arg}': #{inspect(many)}"
      end

    solution_path = Path.join(folder, "solution.#{ext}")
    unless File.exists?(solution_path), do: raise("no solution.#{ext} in #{folder}")

    slug = folder |> Path.basename() |> String.replace(~r/^\d+-/, "")
    code = File.read!(solution_path)

    IO.puts("Fetching problem metadata for: #{slug}")
    data = Common.graphql(@question_query, %{"titleSlug" => slug})
    q = data["question"]
    question_id = q["questionId"]
    test_cases = q["exampleTestcaseList"] |> Enum.join("\n")

    if submit? do
      IO.puts("Submitting #{lang} solution to LeetCode...\n")
      submission_id = submit(slug, question_id, lc_slug, code)
      result = poll(submission_id)
      print_submit_result(result)
    else
      IO.puts("Running #{lang} solution via LeetCode...\n")
      interpret_id = interpret(slug, question_id, lc_slug, code, test_cases)
      result = poll(interpret_id)
      print_result(result)
    end
  end

  defp interpret(slug, question_id, lc_lang, code, test_cases) do
    opts = Common.request_opts()
    url = "#{@base_url}/problems/#{slug}/interpret_solution/"

    body = %{
      "lang" => lc_lang,
      "question_id" => question_id,
      "typed_code" => code,
      "data_input" => test_cases
    }

    case Req.post(url, [json: body] ++ opts) do
      {:ok, %Req.Response{status: 200, body: %{"interpret_id" => id}}} ->
        id

      {:ok, %Req.Response{status: status, body: body}} ->
        raise "interpret request failed (HTTP #{status}): #{inspect(body)}"

      {:error, reason} ->
        raise "request failed: #{inspect(reason)}"
    end
  end

  defp submit(slug, question_id, lc_lang, code) do
    opts = Common.request_opts()
    url = "#{@base_url}/problems/#{slug}/submit/"

    body = %{
      "lang" => lc_lang,
      "question_id" => question_id,
      "typed_code" => code
    }

    case Req.post(url, [json: body] ++ opts) do
      {:ok, %Req.Response{status: 200, body: %{"submission_id" => id}}} ->
        id

      {:ok, %Req.Response{status: status, body: body}} ->
        raise "submit request failed (HTTP #{status}): #{inspect(body)}"

      {:error, reason} ->
        raise "request failed: #{inspect(reason)}"
    end
  end

  defp poll(interpret_id) do
    opts = Common.request_opts()
    url = "#{@base_url}/submissions/detail/#{interpret_id}/check/"

    Stream.repeatedly(fn ->
      case Req.get(url, opts) do
        {:ok, %Req.Response{status: 200, body: body}} -> body
        {:error, reason} -> raise "poll failed: #{inspect(reason)}"
      end
    end)
    |> Enum.find(fn body ->
      state = body["state"]
      IO.write(".")
      state not in ["STARTED", "PENDING"]
    end)
    |> tap(fn _ -> IO.puts("") end)
  end

  defp print_result(%{"state" => "SUCCESS"} = r) do
    status = r["run_success"]
    total = length(r["code_answer"] || [])
    correct = r["correct_answer"]

    IO.puts("Status:  #{if status, do: "OK", else: "Runtime Error"}")

    if r["compile_error"] do
      IO.puts("Compile error: #{r["compile_error"]}")
      IO.puts(r["full_compile_error"] || "")
    end

    if r["runtime_error"] do
      IO.puts("Runtime error: #{r["runtime_error"]}")
      IO.puts(r["full_runtime_error"] || "")
    end

    if status do
      IO.puts("Correct: #{if correct, do: "yes", else: "no"}")
      IO.puts("Cases:   #{total}")
      IO.puts("Runtime: #{r["status_runtime"] || "n/a"}")
      IO.puts("")

      expected = r["expected_code_answer"] || []
      actual = r["code_answer"] || []

      Enum.zip(actual, expected)
      |> Enum.with_index(1)
      |> Enum.each(fn {{got, exp}, i} ->
        icon = if got == exp, do: "✓", else: "✗"
        IO.puts("  #{icon} Test #{i}: got #{got}  (expected #{exp})")
      end)
    end
  end

  defp print_result(%{"state" => state} = r) do
    IO.puts("Unexpected state: #{state}")
    IO.inspect(r)
  end

  defp print_submit_result(%{"state" => "SUCCESS"} = r) do
    status_msg = r["status_msg"] || "Unknown"
    accepted = r["status_msg"] == "Accepted"

    IO.puts("Result:   #{status_msg}")

    if r["compile_error"] do
      IO.puts("Compile error: #{r["compile_error"]}")
      IO.puts(r["full_compile_error"] || "")
    end

    if r["runtime_error"] do
      IO.puts("Runtime error: #{r["runtime_error"]}")
      IO.puts(r["full_runtime_error"] || "")
    end

    if accepted do
      passed = r["total_correct"] || 0
      total = r["total_testcases"] || 0
      IO.puts("Cases:    #{passed}/#{total}")
      IO.puts("Runtime:  #{r["status_runtime"] || "n/a"} (beats #{r["runtime_percentile"] |> then(&if &1, do: Float.round(&1 * 1.0, 1), else: "?")}%)")
      IO.puts("Memory:   #{r["status_memory"] || "n/a"} (beats #{r["memory_percentile"] |> then(&if &1, do: Float.round(&1 * 1.0, 1), else: "?")}%)")
    else
      if r["last_testcase"] do
        IO.puts("Failed on: #{r["last_testcase"]}")
        IO.puts("Expected:  #{r["expected_output"]}")
        IO.puts("Got:       #{r["code_output"]}")
      end
    end
  end

  defp print_submit_result(%{"state" => state} = r) do
    IO.puts("Unexpected state: #{state}")
    IO.inspect(r)
  end
end

LeetcodeTracker.RunSolution.run(System.argv())

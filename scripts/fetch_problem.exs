Code.require_file(Path.join(__DIR__, "common.exs"))

defmodule LeetcodeTracker.FetchProblem do
  alias LeetcodeTracker.Common
  # friendly name => {Leetcode langSlug, file extension}
  @languages %{
    "python" => {"python3", "py"},
    "elixir" => {"elixir", "ex"},
    "erlang" => {"erlang", "erl"},
    "go" => {"golang", "go"}
  }

  @query """
  query questionData($titleSlug: String!) {
    question(titleSlug: $titleSlug) {
      questionFrontendId
      title
      titleSlug
      difficulty
      content
      codeSnippets { langSlug code }
    }
  }
  """

  def run(argv) do
    {opts, args, _} = OptionParser.parse(argv, strict: [langs: :string])

    slug =
      case args do
        [s | _] -> s
        [] -> raise "usage: elixir fetch_problem.exs <slug> [--langs python,elixir]"
      end

    langs =
      (opts[:langs] || "elixir")
      |> String.split(",")
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.downcase/1)

    case Enum.reject(langs, &Map.has_key?(@languages, &1)) do
      [] ->
        :ok

      unknown ->
        raise "unknonw language(s): #{inspect(unknown)}. choose from #{inspect(Map.keys(@languages))}"
    end

    data = Common.graphql(@query, %{"titleSlug" => slug})

    case data["question"] do
      nil ->
        raise "no problem found for slug '#{slug}'"

      q ->
        write_problem(q, langs)
    end
  end

  defp write_problem(q, langs) do
    id = String.pad_leading(q["questionFrontendId"], 4, "0")

    folder = Path.join([__DIR__, "..", "problems", "#{id}-#{q["titleSlug"]}"])
    File.mkdir_p!(folder)

    readme = """
    # #{id}. #{q["title"]}

    **Difficulty:** #{q["difficulty"]}

    #{html_to_text(q["content"])}
    """

    File.write!(Path.join(folder, "README.md"), readme)

    snippets =
      q["codeSnippets"]
      |> Enum.map(fn s -> {s["langSlug"], s["code"]} end)
      |> Map.new()

    Enum.each(langs, fn lang ->
      {lc_slug, ext} = @languages[lang]
      path = Path.join(folder, "solution.#{ext}")

      if File.exists?(path) do
        IO.puts("skip (exists): #{path}")
      else
        stub = Map.get(snippets, lc_slug, "// no starter snippet available for #{lang}\n")
        File.write!(path, stub <> "\n")
        IO.puts("wrote: #{path}")
      end
    end)

    tests_path = Path.join(folder, "tests.exs")

    unless File.exists?(tests_path) do
      tests = """
      defmodule SolutionTest do
        use ExUnit.Case

        # test "example 1" do
        #   assert Solution.function_name(input) == expected_output
        # end
      end
      """

      File.write!(tests_path, tests)
      IO.puts("wrote: #{tests_path}")
    end

    IO.puts("\nScaffolded #{folder}")
    IO.puts("Run tests with: elixir scripts/run_tests.exs #{q["titleSlug"]}")
  end

  defp html_to_text(html) do
    html
    |> String.replace(~r/<pre>/, "\n```\n")
    |> String.replace(~r{</pre>}, "\n```\n")
    |> String.replace(~r/<li>/, "\n- ")
    |> String.replace(~r{<(br|/p|/div)\s*/?>}, "\n")
    |> String.replace(~r/<[^>]+>/, "")
    |> String.replace("&nbsp;", " ")
    |> String.replace("&lt;", "<")
    |> String.replace("&gt;", ">")
    |> String.replace("&amp;", "&")
    |> String.replace("&quot;", "\"")
    |> String.replace(~r/\n{3,}/, "\n\n")
    |> String.trim()
  end
end

LeetcodeTracker.FetchProblem.run(System.argv())

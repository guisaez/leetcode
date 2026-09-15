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
        raw = Map.get(snippets, lc_slug, "// no starter snippet available for #{lang}\n")
        stub = prepare_stub(raw, lang)
        File.write!(path, stub <> "\n")
        IO.puts("wrote: #{path}")
        write_support_files(folder, lang)
      end
    end)

    IO.puts("\nScaffolded #{folder}")
  end

  defp prepare_stub(stub, "go"), do: "package main\n\n" <> stub

  defp prepare_stub(stub, "erlang") do
    exports =
      stub
      |> String.split("\n")
      |> Enum.filter(&String.starts_with?(&1, "-spec "))
      |> Enum.map(fn spec_line ->
        name = Regex.run(~r/-spec (\w+)\(/, spec_line, capture: :all_but_first) |> List.first()
        # each argument has exactly one "Var ::" pattern; return type never uses "::"
        arity = length(Regex.scan(~r/\w+ ::/, spec_line))
        "#{name}/#{arity}"
      end)
      |> Enum.join(", ")

    "-module(solution).\n-export([#{exports}]).\n\n" <> stub
  end

  defp prepare_stub(stub, _lang), do: stub

  defp write_support_files(folder, "go") do
    mod_path = Path.join(folder, "go.mod")
    unless File.exists?(mod_path) do
      File.write!(mod_path, "module problem\n\ngo 1.23\n")
      IO.puts("wrote: #{mod_path}")
    end

    test_path = Path.join(folder, "solution_test.go")
    unless File.exists?(test_path) do
      File.write!(test_path, "package main\n\nimport \"testing\"\n\nfunc TestSolution(t *testing.T) {\n\tt.Skip(\"TODO: add test cases\")\n}\n")
      IO.puts("wrote: #{test_path}")
    end
  end

  defp write_support_files(_folder, _lang), do: :ok

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

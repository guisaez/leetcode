Mix.install([{:req, "~> 0.5"}])

defmodule LeetcodeTracker.Common do
  @graphql_url "https://leetcode.com/graphql"

  def load_config do
    env_path = Path.join([__DIR__, "..", ".config"])

    if File.exists?(env_path) do
      {config, _bindings} = Code.eval_file(env_path)
      config
    else
      %{}
    end
  end

  def request_opts do
    headers = [
      {"content-type", "application/json"},
      {"referer", "https://leetcode.com"},
      {"user-agent", "Mozilla/5.0 (personal-leetcode-tracker)"}
    ]

    case load_config() do
      %{leetcode_session: session, leetcode_csrf_token: csrf} ->
        cookie = "LEETCODE_SESSION=#{session}; csrftoken=#{csrf}"
        [headers: headers ++ [{"cookie", cookie}, {"x-csrftoken", csrf}]]

      _ ->
        {:error, :missing_session_or_csrf}
    end
  end

  def graphql(query, variables) do
    case request_opts() do
      {:error, :missing_session_or_csrf} ->
        IO.puts("""
        No credentials found. Create a .config file in the project root:

          %{
            leetcode_session: "your LEETCODE_SESSION cookie value",
            leetcode_csrf_token: "your csrftoken cookie value"
          }

        You can find these in your browser's dev tools after logging in to leetcode.com.
        Open DevTools > Application > Cookies > leetcode.com.
        """)

        System.halt(1)

      opts ->
        case Req.post(@graphql_url, [json: %{query: query, variables: variables}] ++ opts) do
          {:ok, %Req.Response{status: 200, body: %{"data" => _data, "errors" => errors}}}
          when not is_nil(errors) ->
            raise "GraphQL error: #{inspect(errors)}"

          {:ok, %Req.Response{status: 200, body: %{"data" => data}}} ->
            data

          {:ok, %Req.Response{status: status, body: body}} ->
            raise "HTTP #{status}: #{inspect(body)}"

          {:error, reason} ->
            raise "request failed: #{inspect(reason)}"
        end
    end
  end
end

-module(solution).
-export([max_num_of_substrings/1]).

-spec max_num_of_substrings(S :: unicode:unicode_binary()) -> [unicode:unicode_binary()].
max_num_of_substrings(S) ->
    String = binary_to_list(S),
    Ranges = build_ranges(String),
    Candidates = lists:foldl(fun(Range, Acc) ->
                                case iterate(Range, String, Ranges) of
                                    false ->
                                        Acc;
                                    ValidRange ->
                                        [ValidRange | Acc]
                                end
                             end, [], maps:values(Ranges)),

    Sorted = lists:sort(fun({_, End1}, {_, End2}) ->
                            End1 < End2
                        end, Candidates),

    {_, Result} = lists:foldl(fun({Start, End}, {LastEnd, Acc}) ->
                                      case Start > LastEnd of
                                          true ->
                                              Substring = list_to_binary(lists:sublist(String, Start + 1, End - Start + 1)),
                                              {End, [Substring | Acc]};
                                          false ->
                                              {End, Acc}
                                      end

                              end, {-1, []}, Sorted),
    lists:reverse(Result).

build_ranges(String) ->
    {_, Ranges} = lists:foldl(
        fun(Char, {Index, Acc}) ->
                {Start, _} = maps:get(Char, Acc, {Index, Index}),
                {Index + 1, Acc#{Char => {Start, Index}}}

        end, {0, #{}}, String),
        Ranges.

iterate({Start, End}, String, Ranges) ->
    iterate(Start, End, lists:nthtail(Start, String), Ranges, Start).
iterate(Start, End, _String, _Ranges, Pos) when Pos > End ->
    {Start, End};
iterate(Start, End, [Char | Rest], Ranges, Pos) ->
    {CharStart, CharEnd} = maps:get(Char, Ranges),

    if CharStart < Start ->
           false;
       CharEnd > End ->
           iterate(Start, CharEnd, Rest, Ranges, Pos + 1);
       true ->
           iterate(Start, End, Rest, Ranges, Pos + 1)
    end.

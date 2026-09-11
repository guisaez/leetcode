-spec total_numbers(Digits :: [integer()]) -> integer().
total_numbers(Digits) ->
    FreqMap = lists:foldl(fun(Digit, Acc) -> Acc#{Digit => maps:get(Digit, Acc, 0) + 1} end, #{}, Digits),
    count_by_hundreds(maps:keys(FreqMap), FreqMap, 0).

count_by_hundreds([], _FreqMap, Count) ->
    Count;
count_by_hundreds([0 | R], FreqMap, Count) ->
    count_by_hundreds(R, FreqMap, Count);
count_by_hundreds([Hundreds | R], FreqMap, Count) ->
    Remaining = FreqMap#{Hundreds => maps:get(Hundreds, FreqMap) - 1},
    count_by_hundreds(R, FreqMap, Count + count_by_units(maps:keys(FreqMap), Remaining, 0)).

count_by_units([], _FreqMap, Acc) ->
    Acc;
count_by_units([Unit|R], FreqMap, Acc) ->
    case (Unit rem 2 == 1) orelse maps:get(Unit, FreqMap) of
        true ->
            count_by_units(R, FreqMap, Acc);
        0 ->
            count_by_units(R, FreqMap, Acc);
        Freq ->
            Count = count_available_middles(maps:to_list(FreqMap#{Unit => Freq - 1})),
            count_by_units(R, FreqMap, Acc + Count)
    end.

count_available_middles(L) ->
    length(lists:filter(fun({_, V}) -> V >= 1 end , L)).


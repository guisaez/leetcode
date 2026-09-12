-spec maximum_weight(Intervals :: [[integer()]]) -> [integer()].
maximum_weight(Intervals) ->
    N = length(Intervals),
    Indexed = lists:zipwith(
        fun([S, F, W], I) -> {S, F, W, I} end,
        Intervals, lists:seq(0, N - 1)),
    Sorted = lists:sort(
        fun({_, FA, _, IA}, {_, FB, _, IB}) ->
            FA < FB orelse (FA =:= FB andalso IA < IB)
        end, Indexed),
    SortedArr = list_to_tuple(Sorted),
    FinishArr = list_to_tuple([F || {_, F, _, _} <- Sorted]),
    K = 4,
    EmptyArr = array:new(N + 1, {default, {0, []}}),
    % Layers accumulates [dp[J], dp[J-1], ..., dp[0]], newest at front
    Layers = lists:foldl(
        fun(_, [PrevLayer | _] = Acc) ->
            NewLayer = lists:foldl(
                fun(I, Arr) ->
                    {StartI, _, WeightI, OrigI} = element(I, SortedArr),
                    Skip = array:get(I - 1, Arr),
                    P = find_prev(StartI, FinishArr, 1, N),
                    {PW, PI} = array:get(P, PrevLayer),
                    Take = {PW + WeightI, lists:sort([OrigI | PI])},
                    array:set(I, better(Take, Skip), Arr)
                end,
                EmptyArr,
                lists:seq(1, N)
            ),
            [NewLayer | Acc]
        end,
        [EmptyArr],
        lists:seq(1, K)
    ),
    % Find best result across dp[1..K] (drop dp[0] at the tail)
    {_, BestIdx} = lists:foldl(
        fun(Layer, Acc) -> better(array:get(N, Layer), Acc) end,
        {0, []},
        lists:droplast(Layers)
    ),
    BestIdx.

% Binary search: largest index i in 1..N such that FinishArr[i] < Start; 0 if none
find_prev(_Start, _Arr, Lo, Hi) when Lo > Hi -> Lo - 1;
find_prev(Start, Arr, Lo, Hi) ->
    Mid = (Lo + Hi) div 2,
    case element(Mid, Arr) < Start of
        true  -> find_prev(Start, Arr, Mid + 1, Hi);
        false -> find_prev(Start, Arr, Lo, Mid - 1)
    end.

% Higher weight wins; on tie, lexicographically smaller sorted index list wins
better({W1, _} = R1, {W2, _}) when W1 > W2 -> R1;
better({W1, _}, {W2, _} = R2) when W1 < W2 -> R2;
better({_, I1} = R1, {_, I2} = R2) ->
    case I1 =< I2 of
        true  -> R1;
        false -> R2
    end.

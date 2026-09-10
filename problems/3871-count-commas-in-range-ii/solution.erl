-spec count_commas(N :: integer()) -> integer().
count_commas(N) when N < 1000 ->
    0;
count_commas(N) ->
    count_commas(N, floor_log1000(N), 0).

count_commas(_N, 0, Acc) ->
    Acc;
count_commas(N, Tier, Acc) ->
    TierStart = pow_1000(Tier),
    TierEnd = min(N, pow_1000(Tier + 1) - 1),
    count_commas(N, Tier - 1, Acc + Tier * (TierEnd - TierStart + 1)).


pow_1000(0) -> 1;
pow_1000(K) -> 1000 * pow_1000(K - 1).

floor_log1000(N) when N < 1000 -> 0;
floor_log1000(N) ->
    1 + floor_log1000(N div 1000).

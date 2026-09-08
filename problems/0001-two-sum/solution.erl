-spec two_sum(Nums :: [integer()], Target :: integer()) -> [integer()].
two_sum(Nums, Target) ->
    two_sum_(Nums, Target, #{}, 0).

two_sum_([], _Target, _Map, _Idx) ->
    {error, not_found};
two_sum_([N | R], Target, Map, Idx) ->
    Complement = Target - N,
    case maps:get(Complement, Map, undefined) of
        undefined ->
            two_sum_(R, Target, Map#{N => Idx}, Idx + 1);
        CompIdx ->
            [CompIdx, Idx]
    end.

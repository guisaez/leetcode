-spec largest_overlap(Img1 :: [[integer()]], Img2 :: [[integer()]]) -> integer().
largest_overlap(Img1, Img2) ->
    M1 = to_coord_list(Img1),
    M2 = to_coord_list(Img2),
    Translations = [{X2 - X1, Y2 - Y1} || {X1, Y1} <- M1, {X2, Y2} <- M2],
    count_max(Translations).


count_max([]) -> 0;
count_max(Translations) ->
    Counts = lists:foldl(fun(T, Map) ->
        maps:update_with(T, fun(V) -> V + 1 end, 1, Map)
    end, #{}, Translations),
    maps:fold(fun(_, V, Max) -> max(V, Max) end, 0, Counts).

to_coord_list(Grid) ->
    {_, Coords} = lists:foldl(fun(Row, {Y, Acc}) ->
        {_, RowCoords} = lists:foldl(fun
            (1, {X, RowAcc}) -> {X + 1, [{X, Y} | RowAcc]};
            (_, {X, RowAcc}) -> {X + 1, RowAcc}
        end, {0, []}, Row),
        {Y + 1, RowCoords ++ Acc}
    end, {0, []}, Grid),
    Coords.

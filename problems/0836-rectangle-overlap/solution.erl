-module(solution).
-export([is_rectangle_overlap/2]).

-spec is_rectangle_overlap(Rec1 :: [integer()], Rec2 :: [integer()]) -> boolean().
is_rectangle_overlap([X1, Y1, X2, Y2], [X3, Y3, X4, Y4]) ->
    X1 < X4 andalso X3 < X2 andalso
    Y1 < Y4 andalso Y3 < Y2.


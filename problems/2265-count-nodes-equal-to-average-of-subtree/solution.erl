%% Definition for a binary tree node.
%%
% -record(tree_node, {val = 0 :: integer(),
%                     left = null  :: 'null' | #tree_node{},
%                     right = null :: 'null' | #tree_node{}}).

-spec average_of_subtree(Root :: #tree_node{} | null) -> integer().
average_of_subtree(Root) ->
    {Count, _, _} = average_of_subtree_(Root),
    Count.

average_of_subtree_(null) -> {0, 0, 0};
average_of_subtree_(#tree_node{left = null, right = null, val = Val}) ->
    {1, Val, 1};
average_of_subtree_(#tree_node{left = Left, right = Right, val = Val}) ->
    {AvgLeftCount, SumLeft, SumNodeL} = average_of_subtree_(Left),
    {AvgRightCount, SumRight, SumNodeR} = average_of_subtree_(Right),

    Sum = SumLeft + SumRight + Val,
    NodeCount = SumNodeL + SumNodeR + 1,

    case Sum div NodeCount of
        Val ->
            {AvgLeftCount + AvgRightCount + 1, Sum, NodeCount};
        _ ->
            {AvgLeftCount + AvgRightCount, Sum, NodeCount}

    end.


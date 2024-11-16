-module(cbt).

-export([t1/0, t2/0, ic/1]).

-type btree() :: {empty} | {node, number(), btree(), btree()}.

%% Example of a complete bt
-spec t1() -> btree().
t1() ->
    {node, 1, {node, 2, {empty}, {empty}}, {node, 3, {empty}, {empty}}}.

%% Example of a non-complete bt
-spec t2() -> btree().
t2() ->
    {node, 1, {node, 2, {empty}, {empty}}, {node, 3, {empty}, {node, 3, {empty}, {empty}}}}.

%% Checks that all the trees in the queue are empty trees.
-spec all_empty(queue:queue()) -> boolean().
all_empty(Q) ->
    queue:fold(fun ({empty}, Acc) ->
                       Acc;
                   (_, _) ->
                       false
               end,
               true,
               Q).

%% helper function for ic
-spec ich(queue:queue()) -> boolean().
ich(Q) ->
    case queue:out(Q) of
        {empty, _} ->
            true;
        {{value, {empty}}, R} ->
            all_empty(R);
        {{value, {node, _, L, R}}, Rest} ->
            ich(queue:in(L, queue:in(R, Rest)));
        _ ->
            false
    end.

-spec ic(btree()) -> boolean().
ic(T) ->
    ich(queue:in(T, queue:new())).

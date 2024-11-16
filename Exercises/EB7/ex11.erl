-module(ex11).

-export([mapGTree/2, test/0, foldGTree/3]).

mapGTree(F, {node, Number, Children}) ->
    {node, F(Number), [mapGTree(F, Child) || Child <- Children]}.

foldGTree(_, Acc, []) ->
    Acc;
foldGTree(F, Acc, {node, Number, Children}) ->
    NewAcc = F(Number, Acc),
    lists:foldl(fun(Child, A) -> foldGTree(F, A, Child) end, NewAcc, Children).

test() ->
    Tree =
        {node,
         5,
         [{node, 1, []},
          {node, 2, [{node, 3, [{node, 12, []}]}, {node, 4, []}]},
          {node, 6, [{node, 7, []}]}]},
    foldGTree(fun(X, Acc) -> X * Acc end, 1, Tree).

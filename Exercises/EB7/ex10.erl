-module(ex10).

-export([sumTree/1, mapTree/2, foldTree/3, test/0]).

sumTree(Tree) ->
    sumTree(Tree, 0).

sumTree({empty}, Acc) ->
    Acc;
sumTree({node, Number, LSubtree, RSubtree}, Acc) ->
    NewAcc = Acc + Number,
    Acc1 = sumTree(LSubtree, NewAcc),
    sumTree(RSubtree, Acc1).

mapTree(_, {empty}) ->
    {empty};
mapTree(F, {node, Number, LSubtree, RSubtree}) ->
    {node, F(Number), mapTree(F, LSubtree), mapTree(F, RSubtree)}.

foldTree(F, Acc, {node, Number, LSubtree, RSubtree}) ->
    Acc1 = foldTree(F, Acc, LSubtree),
    Acc2 = F(Number, Acc1),
    foldTree(F, Acc2, RSubtree).

% for testing purposes
test() ->
    Tree =
        {node,
         5,
         {node, 3, {node, 1, {empty}, {empty}}, {node, 4, {empty}, {empty}}},
         {node, 8, {empty}, {node, 9, {empty}, {empty}}}},
    % sumTree(Tree).
    % mapTree(fun(X) -> X * 2 end, Tree).
    foldTree(fun(X, Acc) -> X + Acc end, 0, Tree).

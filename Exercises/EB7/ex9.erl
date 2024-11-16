-module(ex9).

-export([map/2, filter/2, fold/2]).

% map/2: Applies a function to each element of a list
map(F, []) ->
    [];
map(F, [H | T]) ->
    [F(H) | map(F, T)].

% to execute: ex9:map(fun(X)->X*2 end, [1,2,33,4]).

% filter/2: Returns a list of elements that satisfy a predicate
filter(Pred, []) ->
    [];
filter(Pred, [H | T]) ->
    case Pred(H) of
        true ->
            [H | filter(Pred, T)];
        false ->
            filter(Pred, T)
    end.

% to exec: ex9:filter(fun(X)->X rem 2 =:= 1 end, [1,2,4,6,44,2,1,4,3,3,4,6,5,7]).

% fold/2: Folds a list from the left with a function
fold(F, [H | T]) ->
    fold(F, H, T).

fold(F, Acc, []) ->
    Acc;
fold(F, Acc, [H | T]) ->
    fold(F, F(H, Acc), T).

% to exec: ex9:fold(fun(X, Acc) -> X + Acc end, [1, 2, 3, 4]).
-module(ex7).
-export([sum/1, maximum/1, zip/2, append/2, reverse/1, evenL/1, take/2, drop/2]).
sum([]) -> 0;
sum([H|T]) -> H + sum(T).

maximum([])->0;
maximum([X|Y]) -> 
    Max = maximum(Y),
    if X > Max ->
        X;
    true ->
        Max
    end.

zip(X,Y) ->
    lists:zip(X, Y).

append([], Y) -> Y;
append([H|T], Y) -> [H | append(T, Y)].

reverse([]) -> [];
reverse([X | Y]) -> reverse(Y) ++ [X].

evenL(X) ->
    [Y || Y <- X, Y rem 2 == 0].

take(0, L) -> [];
take(N, []) -> [];
take(N,[X | L]) when N>0 -> [X] ++ take(N-1, L).

drop(0, X) -> X;
drop(N,[]) -> [];
drop(N, [X | L]) when N>0 -> drop(N-1, L).
-module(basic).
-export([mult/2, double/1, distance/2, my_and/2, my_or/2, my_not/1, fibonacci/1, fibonacciTR/1]).

mult(X,Y) ->
    X*Y.

double(X) -> 
    X*2.

distance({X,Y},{A,B}) ->
    math:sqrt(math:pow(X - A, 2) + math:pow(Y - B, 2)).

my_and(X, Y) -> X and Y.

my_or(false, false) -> false;
my_or(_, _) -> true.

my_not(true) -> false;
my_not(false) -> true.

fibonacciTR(0) -> 0;
fibonacciTR(1) -> 1;
fibonacciTR(X) -> fibonacciTR(X-1) + fibonacciTR(X-2).


fibonacci_helper(X, F1, F2, Counter) ->
    if Counter == X -> F2;
        true -> fibonacci_helper(X, F2, F1 + F2, Counter + 1)
    end.

fibonacci(X) ->
    fibonacci_helper(X, 0, 1, 1).


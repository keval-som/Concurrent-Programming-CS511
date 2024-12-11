-module(ex6).

-compile(export_all).
-compile(nowarn_export_all).

start() ->
    S = spawn(?MODULE, server, []),
    spawn(?MODULE, client, [S]).

server() ->
    receive
        {Pid, Number} ->
            case lists:any(fun(N) -> Number rem N == 0 end, lists:seq(2, trunc(math:sqrt(Number))))
            of
                true ->
                    Pid ! {Number, false};
                false ->
                    Pid ! {Number, true}
            end,
            server()
    end.

client(Server) ->
    Server ! {self(), rand:uniform(100)},
    receive
        {Number, false} ->
            io:format("~p is prime: ~p~n", [Number, false]),
            client(Server);
        {Number, true} ->
            io:format("~p is prime: ~p~n", [Number, true]),
            client(Server)
    end.

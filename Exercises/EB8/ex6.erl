-module(ex6).

-compile(export_all).
-compile(nowarn_export_all).

start() ->
    S = spawn(?MODULE, server, []),
    [spawn(?MODULE, client, [S]) || _ <- lists:seq(1, 10)].

client(S) ->
    Rand = rand:uniform(100),
    S ! {Rand, self()},
    receive
        {Msg} ->
            io:format("Client ~p received ~p~n", [self(), Msg])
    end.

server() ->
    io:format("Server started~n"),
    receive
        {Rand, Pid} ->
            io:format("Server received ~p from ~p~n", [Rand, Pid]),
            IsPrime =
                lists:foldl(fun(X, Acc) ->
                               case Rand rem X of
                                   0 -> false;
                                   _ -> Acc
                               end
                            end,
                            true,
                            lists:seq(2, Rand div 2)),
            Pid ! {IsPrime},
            server()
    end.

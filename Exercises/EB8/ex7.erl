-module(ex7).

-compile(export_all).
-compile(nowarn_export_all).

start(P, J) ->
    S = spawn(?MODULE, server, [0]),
    [spawn(?MODULE, patriots, [S]) || _ <- lists:seq(1, P)],
    [spawn(?MODULE, jets, [S]) || _ <- lists:seq(1, J)].

patriots(S) -> % Reference to PID of server
    io:format("Patriots~n"),
    S ! {self(), patriots}.

jets(S) -> % Reference to PID of server
    Ref = make_ref(),
    S ! {self(), Ref, jets},
    receive
        {S, Ref, ok} ->
            io:format("Jets~n"),
            ok
    end.

server(Patriots) ->
    receive
        {_From, patriots} ->
            server(Patriots + 1);
        {From, Ref, jets} when Patriots > 1 ->
            From ! {self(), Ref, ok},
            server(Patriots - 2)
    end.

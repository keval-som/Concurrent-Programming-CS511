-module(ex7b).

-compile(export_all).
-compile(nowarn_export_all).

start(P, J) ->
    S = spawn(?MODULE, server, [0, false]),
    [spawn(?MODULE, patriots, [S]) || _ <- lists:seq(1, P)],
    [spawn(?MODULE, jets, [S]) || _ <- lists:seq(1, J)],
    spawn(?MODULE, timer, [S]),
    ok.

patriots(S) -> % R ef e re nc e to PID of server
    S ! {self(), patriots},
    io:format("Patiots ~w went in\n", [self()]).

jets(S) -> % R ef e re nc e to PID of server
    S ! {self(), jets},
    receive
        {S, ok} ->
            io:format("Jets ~w went in\n", [self()])
    end.

server(Patriots, IGL) ->
    receive
        {_From, patriots} ->
            server(Patriots + 1, IGL);
        {From, jets} when (Patriots > 1) and not IGL ->
            From ! {self(), ok},
            server(Patriots - 2, IGL);
        {From, jets} when IGL ->
            From ! {self(), ok},
            server(Patriots, IGL);
        {itGotLate} ->
            server(Patriots, true)
    end.

timer(S) ->
    timer:sleep(4000),
    io:format("It got late\n"),
    S ! {itGotLate}.

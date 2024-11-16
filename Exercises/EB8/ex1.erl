-module(ex1).

-compile(export_all).

start(N) -> % Spawns a counter and N turnstile clients
    io:format("Starting counter and ~p turnstile clients~n", [N]),
    C = spawn(?MODULE, counter_server, [0]),
    [spawn(?MODULE, turnstile, [C, 50]) || _ <- lists:seq(1, N)],
    C.

counter_server(State) ->
    io:format("Counter server state: ~p~n", [State]),
    receive
        {bump} ->
            io:format("Received bump message~n"),
            counter_server(State + 1);
        {read, From} ->
            io:format("Received read message from ~p~n", [From]),
            From ! {counter, State},
            counter_server(State)
    end.

turnstile(C, 0) ->
    io:format("Turnstile finished sending bumps~n"),
    ok;
turnstile(C, N) ->
    io:format("Turnstile sending bump, ~p remaining~n", [N]),
    C ! {bump},
    turnstile(C, N - 1).

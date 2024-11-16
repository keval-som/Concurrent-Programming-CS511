-module(gg).

-compile(export_all).
-compile(nowarn_export_all).

make() ->
    spawn(?MODULE, server_loop, []).

server_loop() ->
    receive
        {play, PID} ->
            S = spawn(?MODULE, servlet, [rand:uniform(10), PID, 0]),
            PID ! {ok, S},
            server_loop()
    end.

servlet(N, PID, Tries) ->
    receive
        {guess, M} when M == N ->
            PID ! {gotIt, Tries};
        {guess, M} when M =/= N ->
            PID ! {tryAgain},
            servlet(N, PID, Tries + 1)
    end.

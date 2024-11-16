-module(ex5).

-compile(export_all).

start(Freq) ->
    L = spawn(?MODULE, timer, [Freq, []]),
    [spawn(?MODULE, client, [L]) || _ <- lists:seq(1, 5)].

client(L) ->
    L ! {register, self()},
    client_loop().

client_loop() ->
    receive
        {tick} ->
            io:format("Client ~p received tick~n", [self()]),
            client_loop()
    end.

timer(Freq, Pids) ->
    receive
        {register, Pid} ->
            io:format("Timer registered client ~p~n", [Pid]),
            timer(Freq, [Pid | Pids])
    after
        Freq ->
            lists:foreach(fun(Pid) ->
                Pid ! {tick}
            end, Pids),
            timer(Freq, Pids)
    end.

-module(ex4).

-compile(export_all).
-compile(nowarn_export_all).

start(Freq) ->
    L = [spawn(?MODULE, client, []) || _ <- lists:seq(1, 10)],
    spawn(?MODULE, timer, [Freq, L]).

client() ->
    receive
        {tick} ->
            io:format("Client ~p received tick~n", [self()]),
            client()
    end.

timer(Freq, L) ->
    timer:sleep(Freq),
    [Pid ! {tick} || Pid <- L],
    timer(Freq, L).

-module(ex2).

-compile(export_all).
-compile(nowarn_export_all).

start() ->
    S = spawn(?MODULE, server, []),
    [spawn(?MODULE, client, [S]) || _ <- lists:seq(1, 100000)].

client(S) ->
    S ! {start, self()},
    S ! {add, "h", self()},
    S ! {add, "e", self()},
    S ! {add, "l", self()},
    S ! {add, "l", self()},
    S ! {add, "o", self()},
    S ! {done, self()},
    receive
        {S, Str} ->
            io:format("Done: ~p ~s~n", [self(), Str])
    end.
    server() ->
        receive
            {start, Pid} ->
                server(Pid, "");
            {add, Char, Pid} ->
                server(Pid, Char);
            {done, Pid} ->
                Pid ! {self(), ""}
        end.
    
    server(Pid, Str) ->
        receive
            {add, Char, Pid} ->
                server(Pid, Str ++ Char);
            {done, Pid} ->
                Pid ! {self(), Str}
        end.

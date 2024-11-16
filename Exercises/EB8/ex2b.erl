-module(ex2b).

-compile(export_all).
-compile(nowarn_export_all).

start() ->
    S = spawn(?MODULE, server, []),
    [spawn(?MODULE, client, [S]) || _ <- lists:seq(1, 100000)].

client(S) ->
    S ! {start, self()},
    receive
        {Servlet} ->
            ok
    end,
    Servlet ! {add, "h", self()},
    Servlet ! {add, "e", self()},
    Servlet ! {add, "l", self()},
    Servlet ! {add, "l", self()},
    Servlet ! {add, "o", self()},
    Servlet ! {done, self()},
    receive
        {Servlet, Str} ->
            io:format("Done: ~p ~s~n", [self(), Str])
    end.

server() ->
    receive
        {start, Pid} ->
            Servlet = spawn(?MODULE, server, [Pid, ""]),
            Pid ! {Servlet},
            server()
    end.

server(Pid, Str) ->
    receive
        {add, Char, Pid} ->
            server(Pid, Str ++ Char);
        {done, Pid} ->
            Pid ! {self(), Str}
    end.

-module(rw).
-compile(export_all).
-compile(nowarn_export_all).

start() ->
    spawn(?MODULE, server_loop, []).

server_loop(R,W) ->
    receive
        {start_read, PID} when W==0->
            PID ! {ok},
            server_loop(R+1, W);
        {stop_read} ->
            server_loop(R-1, W);
        {start_write, PID} when (W==0) and (R==0) ->
            PID ! {ok},
            server_loop(R, W+1);
        {stop_write} ->
            server_loop(R, W-1)
            
    end.

start() -> 
    S = rw:start(),
    [spawn(?MODULE, client, [rand:uniform(2)])].

start_read(S) -> 
    S!{start_read, self()},
    

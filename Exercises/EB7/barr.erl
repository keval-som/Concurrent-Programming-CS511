-module(barr).

-compile(export_all).
-compile(nowarn_export_all).

-include_lib("stdlib/include/assert.hrl").

make(B) ->
    spawn(?MODULE, barr_loop, [B, [], B]).

%% B is the size of the barrier
%% L is the list of PIDs of threads that have arrived
%% C is the count of threads yet to arrive

barr_loop(B, L, 0) ->
    ?assert(B == length(L)),
    [PID ! {ok} || PID <- L],
    barr_loop(B, [], B);
barr_loop(B, L, C) when C > 0 ->
    receive
        {arrived, PID} ->
            barr_loop(B, [PID | L], C - 1)
    end.

synch(B) ->
    B ! {arrived, self()},
    receive
        {ok} ->
            ok
    end.

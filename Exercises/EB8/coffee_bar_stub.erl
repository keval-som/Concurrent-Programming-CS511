-module(coffee_bar_stub).

-compile(export_all).
-compile(nowarn_export_all).

make(SIZE) ->
    spawn(?MODULE, cb_loop, [SIZE, SIZE]).

%% SIZE: size of the coffee bar
%% Open: number of open spots at the bar
cb_loop(SIZE,
        0) ->  %% Bar is full, wait for all to leave
               %% See: wait_for_party_to_leave/2 below.
    wait_for_party_to_leave(SIZE, SIZE);

cb_loop(SIZE, Open)
    when Open > 0 -> %% Bar still has spots
    receive
        {enter, Pid} ->
            Pid ! {ok},
            cb_loop(SIZE, Open - 1);
        {exit} ->
            cb_loop(SIZE, Open + 1)
    end.

%% wait for everybody to leave, then restart
wait_for_party_to_leave(SIZE, 0) ->
wait_for_party_to_leave(SIZE, C) when C > 0 ->
    receive
        {exit} ->
            wait_for_party_to_leave(SIZE, C - 1)
    end.

enter(CB) ->
    CB ! {enter, self()},
    receive
        {ok} ->
            ok
    end.

leave(CB) ->
    CB ! {exit}.

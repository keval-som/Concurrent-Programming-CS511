-module(barr_cl).
-compile(export_all).
-compile(nowarn_export_all).


start() ->
    B = barr:make(2),
    spawn(?MODULE,client1,[B]),
    spawn(?MODULE,client2,[B]).

client1(B) ->
    io:format("a"),
    barr:synch(B),
    io:format("1"),
    client1(B).

client2(B) ->
    io:format("b"),
    barr:synch(B),
    io:format("2"),
    client2(B).

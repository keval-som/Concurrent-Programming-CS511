-module(gg_clients).
-compile(export_all).
-compile(nowarn_export_all).

start(NC) ->
    S = gg:make(),
    [ spawn(?MODULE,client,[S]) || _ <- lists:seq(1,NC)],
    ok.

client(S) ->
    S!{play,self()},
    receive
	{ok,Servlet} ->	    
	    client_loop(Servlet,rand:uniform(10))
    end.

client_loop(Servlet,N) ->
    Servlet!{guess,N},
    receive
	{gotIt,Tries} ->
	    io:format("~p guessed in ~w tries~n",[self(),Tries]);
	{tryAgain} ->
	    client_loop(Servlet,rand:uniform(10))
    end.

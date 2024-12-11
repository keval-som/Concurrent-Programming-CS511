-module(echo).
-compile(nowarn_export_all).
-compile(export_all).
%% Name:

start() ->
    P = spawn(?MODULE,set_neighbor,[initiator]),
    Q = spawn(?MODULE,set_neighbor,[noninitiator]),
    R = spawn(?MODULE,set_neighbor,[noninitiator]),
    S = spawn(?MODULE,set_neighbor,[noninitiator]),
    T = spawn(?MODULE,set_neighbor,[noninitiator]),
    io:format("P is ~p~n",[P]), io:format("Q is ~p~n",[Q]),
    io:format("R is ~p~n",[R]), io:format("S is ~p~n",[S]),
    io:format("T is ~p~n",[T]),
    P![Q,S,T],
    Q![P,S,T,R],
    R![Q],
    S![P,Q,T],
    T![S,P,Q],
    ok.

set_neighbor(Init) ->
    receive
	NPIDs ->
	    case Init of
		initiator ->  %% Initiator node: send first wave
		    [ Pid!{self(),[]} || Pid <- NPIDs ];
		noninitiator ->  %% Noninitiator node
		    ok
	    end,
	    loop(Init,NPIDs,0,undef,[])
    end.

%% Noninitiator node and parent undef
%% - Wait for first message.
%% - Set parent
%% - If there is more than one neighbor, send wave forward to them (except parent) 
%% - Otherwise, send wave back to parent
loop(noninitiator,NPIDs,0,undef,[]) -> 
    receive
	{From,_Subtree} ->
	    if
		length(NPIDs)>1 ->  %% have more than one neighbor, send wave forward
		    [ Nei!{self(),[]} || Nei <- lists:delete(From,NPIDs) ],
		    loop(noninitiator,NPIDs,1,From,[]);
		true ->             %% only one neighbor, send wave to parent
		    From!{self(),[{From,parent_of,self()}]}
	    end

    end;

%% Noninitiator node with parent already defined behaves as follows:
%% - receive {_From,Subtree} message
%% - if got replies from all neighbors, send parent [{Parent,parent_of,self()} | Subtree++Tree]
%% - otherwise, wait for more messages (recursive call)  
%% Rec: counts number of messages received
loop(noninitiator,NPIDs,Rec,Parent,Tree) ->  
    complete; 

%% Initiator node behaves as follows:
%% - receive {_From,Subtree} message
%% - if got replies from all neighbors, print out spanning tree (io:format("done ~w~n",[Subtree++Tree]);)
%% - otherwise, wait for more messages (recursive call)  
loop(initiator,NPIDs,Rec,undef,Tree) ->  
    complete.












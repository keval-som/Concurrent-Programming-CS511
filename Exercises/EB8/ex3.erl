-module(ex3).

-compile(export_all).

start() ->
    S = spawn(?MODULE, server, []),
    [spawn(?MODULE, client, [S]) || _ <- lists:seq(1, 10)].

client(S) ->
    S ! {start, self()},
    Rand = rand:uniform(2),
    case Rand of
        1 ->
            io:format("Client ~p sending counter~n", [self()]),
            S ! {counter, self()};
        2 ->
            io:format("Client ~p sending continue~n", [self()]),
            S ! {continue, self()}
    end,
    receive
        {Msg} ->
            io:format("Client ~p received ~p~n", [self(), Msg])
    end.

server() ->
    io:format("Server started~n"),
    receive
        {start, Pid} ->
            io:format("Server received start from ~p~n", [Pid]),
            server(0, 0)
    end.

server(Counter, Continue) ->
    receive
        {counter, Pid} ->
            io:format("Server received counter from ~p~n", [Pid]),
            Pid ! {Continue},
            server(Counter + 1, 0);
        {continue, Pid} ->
            io:format("Server received continue from ~p~n", [Pid]),
            Pid ! {Counter},
            server(0, Continue + 1)
    end.

    % start() ->
    %     S = spawn(?MODULE, server, [0, 0]),
    %     [spawn(?MODULE, client, [S]) || _ <- lists:seq(1, 10)].

    % server(Continue, Counter) ->
    %     receive
    %         {Pid, 2} ->
    %             io:format("server received 0~n"),
    %             Pid ! {self(), Counter},
    %             server(Continue + 1, 0);
    %         {Pid, 1} ->
    %             io:format("server received 1~n"),
    %             Pid ! {self(), Continue},
    %             server(0, Counter + 1)
    %     end.

    % client(Server) ->
    %     R = rand:uniform(2),
    %     Server ! {self(), R},
    %     receive
    %         {_, Count} ->
    %             io:format("Client ~p received ~p~n", [self(), Count])
    %     end.

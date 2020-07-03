:- module(webclient, [start_game/0, start_game/1, play_in_loop/0, play_in_loop/1]).

:- use_module(library(http/websocket)).
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/json)).

:- use_module(notation).
:- use_module(ai).
:- use_module(rules).
:- use_module(configuration).
:- use_module(field_label).

handle_server_message(WebSocket, CurrentContext, NewContext) :-
	ws_receive(WebSocket, Reply, [ format(json) ]),
	writeln(Reply),
	( 
		Reply.data.type == "rfx#jz" ->
			ws_send(WebSocket, text('{"roomName":"lobby", "target":"zone", "type":"rfx#jr"}'))
		;
		Reply.data.type == "rfx#jr" ->
			(
				Reply.data.roomData.name == "lobby" ->
					ws_send(WebSocket, text('{"target":"zone","type":"si#gs"}'))
				; true -> true
			)
		;
		Reply.data.type == "si#gb" ->
			start(State0),
			(
				Reply.data.isYourTurn == true -> 
					make_move(WebSocket, State0, NextState),
					NewContext = context{ myId: 0, myColor: white, boardState: NextState, isGameEnd: CurrentContext.isGameEnd }
				; true ->
					NewContext = context{ myId: 1,myColor: black, boardState: State0, isGameEnd: CurrentContext.isGameEnd }
			)
		;
		Reply.data.type == "si#pm" ->
			(
				Reply.data.playerId \= CurrentContext.myId ->
					opponents_move(CurrentContext.boardState, Reply.data.move, ParsedState),
					make_move(WebSocket, ParsedState, NextState),
					NewContext = context{ myId: CurrentContext.myId, myColor: CurrentContext.myColor, boardState: NextState,isGameEnd: CurrentContext.isGameEnd }
				; true -> true
			)
		;
		Reply.data.type == "si#ge" ->
			finish_game(Reply),
			NewContext = context{ myId: CurrentContext.myId, myColor: CurrentContext.myColor, boardState: CurrentContext.boardState, isGameEnd: true }
		;
		true -> true
	),
	(
		not(is_dict(NewContext)) ->
			NewContext = CurrentContext
		; true -> true
	).

open_websocket(URL, WebSocket) :- 
	http_open_websocket(URL, WebSocket, []).

send_move(WebSocket, Move) :- 
	atom_concat('{"target":"zone","type":"si#pm","move":"', Move, TempMessage),
	atom_concat(TempMessage, '"}', Message),
	ws_send(WebSocket, text(Message)).

make_move(WebSocket, State, NextState) :- 
	find_move(State,4,move(From, To, Remove),Value),
	coordinates_notation(From, To, Remove, Move),
	write("best move: "),
	writeln(Move),
	write("value: "),
	writeln(Value),
	writeln(State),
	move(State, move(From, To, Remove), NextState),
	writeln(NextState),
	send_move(WebSocket, Move).
	
opponents_move(State, OpponentMove, NextState) :- 
	write("opponent move: "),
	writeln(OpponentMove),
	notation_coordinates(OpponentMove, From, To, Remove),
	writeln(State),
	move(State, move(From, To, Remove), NextState),
	writeln(NextState).

finish_game(Result) :-
	( Result.data.didYouWin == true ->
		writeln("Game result: win")
		;
		writeln("Game result: lose")
	),
	!.

game_loop(WebSocket, CurrentContext) :-
	handle_server_message(WebSocket, CurrentContext, NewContext),
	(
		NewContext.isGameEnd == false ->
			game_loop(WebSocket, NewContext)
		; true -> true
	),
	!.

start_game(URL) :- 
	write("Server URL: "),
	writeln(URL),
	open_websocket(URL, WebSocket),
	ws_send(WebSocket, text('{"target": "global", "type": "rfx#jz", "zoneName": "morabaraba"}')),
	CurrentContext = context{ myId: -1, myColor: none, boardState: none, isGameEnd: false },
	game_loop(WebSocket, CurrentContext).

start_game() :-
	start_game("ws://127.0.0.1:81/ws").

play_in_loop(URL) :-
	start_game(URL),
	play_in_loop(URL).

play_in_loop() :-
	play_in_loop("ws://127.0.0.1:81/ws").
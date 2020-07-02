:- use_module(library(http/websocket)).
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/json)).

:- use_module(notation).
:- use_module(ai).
:- use_module(rules).
:- use_module(configuration).
:- use_module(field_label).

open_websocket(URL, WebSocket) :- 
	http_open_websocket(URL, WebSocket, []).

connect_to_server(WebSocket) :- 
	ws_send(WebSocket, text('{"target": "global", "type": "rfx#jz", "zoneName": "morabaraba"}')),
	ws_receive(WebSocket, Reply, [ format(json) ]),
	writeln(Reply.data).

join_lobby(WebSocket) :- 
	ws_send(WebSocket, text('{"roomName":"lobby", "target":"zone", "type":"rfx#jr"}')),
	ws_receive(WebSocket, Reply, [ format(json) ]),
	writeln(Reply.data).

init_game(WebSocket) :- 
	ws_send(WebSocket, text('{"target":"zone","type":"si#gs"}')),
	ws_receive(WebSocket, Reply, [ format(json) ]),
	writeln(Reply.data).

wait_for_opponent(WebSocket, PlayerColor) :-
	ws_receive(WebSocket, Reply1, [ format(json) ]),
	wait_for_game_start(WebSocket, Reply1, Reply),
	is_your_turn_player_color(Reply.data.isYourTurn, PlayerColor).

wait_for_game_start(WebSocket, Reply, FinalReply) :-
	writeln(Reply), 
	( Reply.data.type == "si#gb" -> 
		FinalReply = Reply
	;
		ws_receive(WebSocket, Reply1, [ format(json) ]),
		wait_for_game_start(WebSocket, Reply1, FinalReply)
	).

is_your_turn_player_color(true, white).
is_your_turn_player_color(false, black).

receive_game_data(WebSocket, Reply) :-
		ws_receive(WebSocket, Reply, [ format(json) ]),
		writeln(Reply),
		( Reply.data.type == "si#pm" ->
			true
			;
			Reply.data.type == "rfx#ulr" ->
			ws_receive(WebSocket, ResultReply, [ format(json) ]),
			writeln(ResultReply),
			finish_game(WebSocket, ResultReply)
			;
			Reply.data.type == "si#ge" ->
			finish_game(WebSocket, Reply)
		).

send_move(WebSocket, Move) :- 
	atom_concat('{"target":"zone","type":"si#pm","move":"', Move, TempMessage),
	atom_concat(TempMessage, '"}', Message),
	ws_send(WebSocket, text(Message)),
	receive_game_data(WebSocket, _).
	
receive_move(WebSocket, Move) :- 
	receive_game_data(WebSocket, Reply),
	Move = Reply.data.move.

play_game(WebSocket, black) :- 
	start(State0),
	opponents_move(WebSocket, State0).

play_game(WebSocket, white) :- 
	start(State0),
	make_move(WebSocket, State0).

make_move(WebSocket, State) :- 
	find_move(State,4,move(From, To, Remove),Value),
	coordinates_notation(From, To, Remove, Move),
	write("best move: "),
	writeln(Move),
	write("value: "),
	writeln(Value),
	writeln(State),
	move(State, move(From, To, Remove), NextState),
	writeln(NextState),
	send_move(WebSocket, Move),
	opponents_move(WebSocket, NextState).
	
opponents_move(WebSocket, State) :- 
	receive_move(WebSocket, OpponentMove),
	write("opponent move: "),
	writeln(OpponentMove),
	notation_coordinates(OpponentMove, From, To, Remove),
	writeln(State),
	move(State, move(From, To, Remove), NextState),
	writeln(NextState),
	make_move(WebSocket, NextState).

finish_game(WebSocket, Result) :-
	( Result.data.didYouWin == true ->
		writeln("Game result: win")
		;
		writeln("Game result: lose")
	),
	ws_receive(WebSocket, Reply1, [ format(json) ]),
	writeln(Reply1),
	ws_close(WebSocket, 1000, "game_finished"), !,
	start_game().

start_game() :- 
	URL = "ws://127.0.0.1:81/ws",
	open_websocket(URL, WebSocket),
	connect_to_server(WebSocket),
	join_lobby(WebSocket),
	init_game(WebSocket),
	wait_for_opponent(WebSocket, PlayerColor),
	write("playing as: "),
	writeln(PlayerColor),
	play_game(WebSocket, PlayerColor).

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

play_game(WebSocket, black) :- 
	start(State0),
	receive_move(WebSocket, OpponentMove),
	writeln(OpponentMove),
	parse_move(OpponentMove, FromLabel, ToLabel, RemoveLabel),
	field_label(To, ToLabel),
	field_label(Remove, RemoveLabel),
	field_label(From, FromLabel),
	writeln(State0),
	move(State0, move(From, To, Remove), NextState),
	writeln(NextState),
	make_turn(WebSocket, NextState).

play_game(WebSocket, white) :- 
	start(State0),
	make_turn(WebSocket, State0).

send_move(WebSocket, Move) :- 
	atom_concat('{"target":"zone","type":"si#pm","move":"', Move, TempMessage),
	atom_concat(TempMessage, '"}', Message),
	ws_send(WebSocket, text(Message)),
	ws_receive(WebSocket, Reply, [ format(json) ]),
	writeln(Reply).
	
receive_move(WebSocket, Move) :- 
	ws_receive(WebSocket, Reply, [ format(json) ]),
	writeln(Reply),
	Move = Reply.data.move.

make_turn(WebSocket, State) :- 
	find_move(State,4,move(From, To, Remove),Value),
	field_label(From, FromLabel),
	field_label(To, ToLabel),
	field_label(Remove, RemoveLabel),	
	write_move(FromLabel, ToLabel, RemoveLabel, Move),
	writeln(Move),
	writeln(Value),
	writeln(State),
	move(State, move(From, To, Remove), SecondState),
	writeln(SecondState),
	send_move(WebSocket, Move),
	receive_move(WebSocket, OpponentMove),
	writeln(OpponentMove),
	parse_move(OpponentMove, SecondFromLabel, SecondToLabel, SecondRemoveLabel),
	field_label(SecondTo, SecondToLabel),
	field_label(SeocondRemove, SecondRemoveLabel),
	field_label(SecondFrom, SecondFromLabel),
	writeln(SecondState),
	move(SecondState, move(SecondFrom, SecondTo, SeocondRemove), NextState),
	writeln(NextState),
	make_turn(WebSocket, NextState).


start_game() :- 
	URL = "ws://127.0.0.1:81/ws",
	open_websocket(URL, WebSocket),
	connect_to_server(WebSocket),
	join_lobby(WebSocket),
	init_game(WebSocket),
	ws_receive(WebSocket, Reply1, [ format(json) ]),
	wait_for_game_start(WebSocket, Reply1, Reply),
	is_your_turn_player_color(Reply.data.isYourTurn, PlayerColor),
	writeln(PlayerColor),
	play_game(WebSocket, PlayerColor).


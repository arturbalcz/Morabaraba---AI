:- use_module(library(http/websocket)).
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/json)).

open_websocket(URL, WebSocket) :- 
	http_open_websocket(URL, WebSocket, []).

connect_to_server(WebSocket) :- 
	ws_send(WebSocket, json( _{
		target: "global",
		type: "rfx#jz",
		zoneName: "morabaraba"
	})),
	ws_receive(WebSocket, Reply, [ format(json) ]),
	writeln(Reply.data).

join_lobby(WebSocket) :- 
	% ws_send(WebSocket, json( _{
	% 	roomName: "lobby",
	% 	target: "zone",
	% 	type: "rfx#jr"
	% })),
	ws_send(WebSocket, text('{"roomName":"lobby", "target":"zone", "type":"rfx#jr"}')),
	ws_receive(WebSocket, Reply, [ format(json) ]),
	writeln(Reply.data).

init_game(WebSocket) :- 
	% ws_send(WebSocket, json( _{
	% 	target: "zone",
	% 	type: "si#gs"
	% })),
	ws_send(WebSocket, text('{"target":"zone","type":"si#gs"}')),
	ws_receive(WebSocket, Reply, [ format(json) ]),
	writeln(Reply.data).

wait_for_game_start(WebSocket, PlayerColor) :- 
	ws_receive(WebSocket, Reply, [ format(json) ]),
	writeln(Reply.data),
	( Reply.data.type == "si#gb" -> 
		writeln(gameok),
		writeln(Reply.data.isYourTurn),
		writeln(PlayerColor),
		is_your_turn_player_color(Reply.data.isYourTurn, PlayerColor)
	;
		writeln(nook),
		wait_for_game_start(WebSocket, _)
	).

is_your_turn_player_color(true, white).
is_your_turn_player_color(false, black).

test() :- 
	URL = "ws://127.0.0.1:81/ws",
	open_websocket(URL, WebSocket),
	connect_to_server(WebSocket),
	join_lobby(WebSocket),
	init_game(WebSocket),
	wait_for_game_start(WebSocket, PlayerColor),
	writeln(PlayerColor).


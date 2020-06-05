:- use_module(library(http/websocket)).
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/json)).

connect_to_server() :- 
	URL = 'ws://127.0.0.1:81/ws',
	http_open_websocket(URL, WS, []),
	ws_send(WS, json( _{
		target: "global",
		type: "rfx#jz",
		zoneName: "morabaraba"
	})),
	ws_receive(WS, Reply, [ format(json) ]),
	print(Reply.data.userData.name).
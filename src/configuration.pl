:- module(configuration,[
	      start/1,
	      player/2,
	      oponent/2,
	      board/2,
	      empty/2,
	      occupied/3,
	      remove_piece/4,
	      place_piece/4,
	      swap_fields/4,
	      next_player/2,
	      status/4
	  ]).

:- use_module(bake).
:- use_module(setters).
:- use_module(library(record)).
:- use_module(board).

:- record   player_status(
		   unused:between(0,12)=12,
		   lost:between(0,10)=0
		 ).

:- record board(
	      a7:oneof([black,white,empty])=empty,
	      d7:oneof([black,white,empty])=empty,
	      g7:oneof([black,white,empty])=empty,
	      g4:oneof([black,white,empty])=empty,
	      g1:oneof([black,white,empty])=empty,
	      d1:oneof([black,white,empty])=empty,
	      a1:oneof([black,white,empty])=empty,
	      a4:oneof([black,white,empty])=empty,
	      b6:oneof([black,white,empty])=empty,
	      d6:oneof([black,white,empty])=empty,
	      f6:oneof([black,white,empty])=empty,
	      f4:oneof([black,white,empty])=empty,
	      f2:oneof([black,white,empty])=empty,
	      d2:oneof([black,white,empty])=empty,
	      b2:oneof([black,white,empty])=empty,
	      b4:oneof([black,white,empty])=empty,
	      c5:oneof([black,white,empty])=empty,
	      d5:oneof([black,white,empty])=empty,
	      e5:oneof([black,white,empty])=empty,
	      e4:oneof([black,white,empty])=empty,
	      e3:oneof([black,white,empty])=empty,
	      d3:oneof([black,white,empty])=empty,
	      c3:oneof([black,white,empty])=empty,
	      c4:oneof([black,white,empty])=empty
	  ).

:- record configuration(
	      player:oneof([black,white])=white,
	      board:board=board(empty,empty,empty,empty,empty,empty,
				empty,empty,empty,empty,empty,empty,
				empty,empty,empty,empty,empty,empty,
				empty,empty,empty,empty,empty,empty
			       ),
	      white:player_status=player_status(12,0),
	      black:player_status=player_status(12,0)
	  ).

start(State):-
	default_configuration(State).

player(State,Player):-
	configuration_player(State,Player).
board(State,Board):-
	configuration_board(State,Board).


empty(State,Field):-
	board(State,Board),
        board_field_piece(Board,Field,empty).

occupied(State,Field,Player):-
	board(State,Board),
	board_field_piece(Board,Field,Player),
	Player \= empty.

oponent(black,white).
oponent(white,black).

remove_piece(State0,Field,Player,State1):-
	status(State0,Player,Unused,Lost0),
	board(State0,Board0),
	occupied(State0,Field,Player),
	board_set(Field,Board0,empty,Board1),
	succ(Lost0,Lost1),
	make_player_status([unused(Unused),lost(Lost1)],Status),
	StatusOption =.. [Player,Status],
	set_configuration_fields([board(Board1),StatusOption],State0,State1).

place_piece(State0,Player,Field,State1):-
	empty(State0,Field),
	board(State0,Board0),
	status(State0,Player,Unused0,Lost),
	succ(Unused1,Unused0),
	make_player_status([unused(Unused1),lost(Lost)],Status),
	StatusOption =.. [Player,Status],
	board_set(Field,Board0,Player,Board1),
	set_configuration_fields([board(Board1),StatusOption],State0,State1).

swap_fields(State0,A,B,State1):-
	board(State0,Board0),
	board_field_piece(Board0,A,PieceA),
	board_field_piece(Board0,B,PieceB),
	board_set([A=PieceB,B=PieceA],Board0,Board1),
	set_board_of_configuration(Board1,State0,State1).

next_player(State0,State1):-
	player(State0,A),
	oponent(A,B),
	set_player_of_configuration(B,State0,State1).

status(State,Player,Unused,Lost):-
        player_status_unused(Status,Unused),
        player_status_lost(Status,Lost),
	configuration_data(Player,State,Status).

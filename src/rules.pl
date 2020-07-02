:- module(rules,[
    defeated/2,
    victorious/2,
    move/3,
    phase/2
  ]).

:- use_module(configuration).
:- use_module(board).

defeated(State,Player):-
	player(State,Player),
	\+ move(State,_,_).

victorious(State,Player):-
	defeated(State,Oponent),
	oponent(Oponent,Player).

move(State0,move(From,To,Remove),State3):-
        phase(State0,Phase),
	move_piece(Phase,State0,From,To,State1),
	board(State1,Board1),
	(   in_mill(Board1,To)
        ->  take_piece(State1,Remove,State2)
        ;   Remove=x, State2=State1
        ),
        next_player(State2,State3).

move_piece(placing,State0,x,Field,State1):-
	player(State0,Me),
        place_piece(State0,Me,Field,State1).

move_piece(moving,State0,From,To,State1):-
	player(State0,Me),
	occupied(State0,From,Me),
	adjacent(From,To),
	empty(State0,To),
        swap_fields(State0,From,To,State1).

move_piece(flying,State0,From,To,State1):-
	player(State0,Me),
	occupied(State0,From,Me),
	empty(State0,To),
        swap_fields(State0,From,To,State1).

take_piece(State0,Remove,State1):-
	player(State0,Me),
        oponent(Me,Oponent),
        (   unprotected(State0,Oponent,Remove)
        *-> remove_piece(State0,Remove,Oponent,State1)
        ;   occupied(State0,Remove,Oponent),
            remove_piece(State0,Remove,Oponent,State1)
        ).

unprotected(State,Player,Field):-
	occupied(State,Field,Player),
	board(State,Board),
	\+ in_mill(Board,Field).

phase(State,Phase):-
	player(State,Player),
        status(State,Player,Unused,Lost),
	(   Lost > 9
	->  Phase = not_enough_pieces
	;   Unused > 0
	->  Phase = placing
	;   Lost = 9
	->  Phase = flying
	;   Phase = moving
	).

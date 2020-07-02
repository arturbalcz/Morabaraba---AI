:- module(evaluation,[
    evaluate/3
  ]).
:- use_module(configuration).
:- use_module(board).

pieces_left(State,Count):-
	player(State,Player),
	pieces_left(State,Player,Count).

pieces_left(State,Player,Count):-
        status(State,Player,_,Lost),
	Count is 12 - Lost.

freedom(State,Player,Field):-
	occupied(State,Field,Player),
	adjacent(Field,Neighbour),
	empty(State,Neighbour).

freedoms(State,Player,Count):-
	aggregate_all(count,freedom(State,Player,_Field),Count).

evaluate(State,Me,G):-
	oponent(Me,Them),
	pieces_left(State,Me,MyPieces),
	pieces_left(State,Them,TheirPieces),
	freedoms(State,Me,MyFreedoms),
	freedoms(State,Them,TheirFreedoms),
	G is 7*(MyPieces-TheirPieces) + MyFreedoms-TheirFreedoms.


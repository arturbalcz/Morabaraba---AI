:- module(ai,[find_move/4]).

:- use_module(library(record)).
:- use_module(rules).
:- use_module(configuration).
:- use_module(evaluation).

state_player(State,Player):-
	player(State,Player).
legal_move(From,Move,To):-
  move(From,Move,To).

:- dynamic state_value_cache/4.

state_value_calculate(State,Player,Value):-
	(   victorious(State,Player)
	->  Value=9999999
	;   defeated(State,Player)
	->  Value=(-9999999)
	;   evaluate(State,Player,Value)
	).

state_value(State,Player,Value):-
	term_hash(State,Hash),
        (   state_value_cache(Hash,State,Player,Value),
	    !
	;   state_value_calculate(State,Player,Value),
	    !,
	    assert(state_value_cache(Hash,State,Player,Value))
	).

:- record cx(player=white,horizon=5,depth=0,alpha=(-9999999),beta=9999999).

me(Cx):-
	cx_depth(Cx,D),
	0 is D mod 2.

down(Cx0,Cx):-
	cx_depth(Cx0,D0),
	D is D0 + 1,
	set_depth_of_cx(D,Cx0,Cx).

find_move(State,Horizon,Move,Value):-
	state_player(State,Player),
	make_cx([horizon(Horizon),player(Player)],Cx),
	value(State,Cx,Move-Value).

value(State,Cx,Move-Value):-
  cx_player(Cx,Player),
  ( passed_horizon(Cx)
  ->state_value(State,Player,Value),
    Move=horizon
  ; game_over(State)
  ->state_value(State,Player,Value),
    Move=game_over
  ; value_recursive(State,Cx,Move-Value)
  ).

passed_horizon(Cx):-
	cx_horizon(Cx,H),
	cx_depth(Cx,D),
	D>H.
game_over(State):-
	\+ legal_move(State,_,_).

value_recursive(State0,Cx0,Move-Value):-
  cx_player(Cx0,Player),
  findall(H-(Z-State),(legal_move(State0,Z,State),state_value(State,Player,H)),States),
  keysort(States,SortedStates),
  reverse(SortedStates,ReverseSortedStates),
  down(Cx0,Cx),
  ( me(Cx0)
  ->maximize(ReverseSortedStates,Cx,(nix-(-9999999)),Move-Value)
  ; minimize(ReverseSortedStates,Cx,(nix-9999999),Move-Value)
  ).

beta_cut(Cx,Move-Value,Cx,Move-Value):-
	cx_beta(Cx,Beta),
	Value >= Beta.

alpha_cut(Cx,Move-Value,Cx,Move-Value):-
	cx_alpha(Cx,Alpha),
	Value =< Alpha.

improvement(Cx0,ValueMax,Move-Value,Cx,Move-Value):-
	Value > ValueMax,
	set_alpha_of_cx(Value,Cx0,Cx).

worsening(Cx0,ValueMin,Move-Value,Cx,Move-Value):-
	Value < ValueMin,
	set_beta_of_cx(Value,Cx0,Cx).

maximize([],_,Move-Value,Move-Value).
maximize([_-(MoveK-State)|States],Cx0,Move0-Value0,Move-Value):-
  value(State,Cx0,_-ValueK),
  ( beta_cut(Cx0,MoveK-ValueK,Cx,Move1-Value1)
  ->Rest=[]
  ; improvement(Cx0,Value0,MoveK-ValueK,Cx,Move1-Value1)
  ->Rest=States
  ; Rest=States,
    Value1 = Value0,
    Move1 = Move0,
    Cx=Cx0
  ),
  maximize(Rest,Cx,Move1-Value1,Move-Value).

minimize([],_,Move-Value,Move-Value).
minimize([_-(MoveK-State)|States],Cx0,Move0-Value0,Move-Value):-
  value(State,Cx0,_-ValueK),
  ( alpha_cut(Cx0,MoveK-ValueK,Cx,Move1-Value1)
  ->Rest=[]
  ; worsening(Cx0,Value0,MoveK-ValueK,Cx,Move1-Value1)
  ->Rest=States
  ; Rest=States,
    Value1 = Value0,
    Move1=Move0,
    Cx=Cx0
  ),
  minimize(Rest,Cx,Move1-Value1,Move-Value).

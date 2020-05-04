:- module(boardstate, [boardstate/19]).
:- use_module(intersections).

state(empty).
state(white).
state(black).

state(Intersection, State) :-
    intersection(Intersection),
    state(State).

boardstate([State_a7,State_d7,State_g7,State_b6,State_d6,State_f6,State_c5,State_d5,State_e5], 
        a7, State_a7,
        d7, State_d7,
        g7, State_g7, 
        b6, State_b6,
        d6, State_d6,
        f6, State_f6, 
        c5, State_c5,
        d5, State_d5,
        e5, State_e5) :-
    state(State_a7), 
    state(State_d7), 
    state(State_g7), 
    state(State_b6), 
    state(State_d6), 
    state(State_f6), 
    state(State_c5), 
    state(State_d5), 
    state(State_e5).  

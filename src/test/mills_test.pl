:- use_module(main/gamerules/board/mills).

horizontal_positive_test() :-
    mill(a1,d1,g1),
    mill(b2,d2,f2),
    mill(c5,d5,e5),
    mill(a4,b4,c4),
    mill(e4,f4,g4). 

horizontal_negative_test() :-
    not(mill(a7,d6,g7)),
    not(mill(c4,c5,d5)),
    not(mill(b4,c4,e4)).

vertical_positive_test() :-
    mill(g7,g4,g1),
    mill(b2,b4,b6),
    mill(c3,c4,c5),
    mill(d5,d6,d7),
    mill(d1,d2,d3).

vertical_negative_test() :-
    not(mill(f6,e4,f2)),
    not(mill(e4,e3,e2)),
    not(mill(d5,d3,d2)).

diagonal_positive_test() :-
    mill(a7,b6,c5),
    mill(c3,b2,a1),
    mill(e3,f2,g1),
    mill(g7,f6,e5).

diagonal_negative_test() :-
    not(mill(c3,e5,f6)), 
    not(mill(c5,d4,e3)). 

test() :- 
    horizontal_positive_test(), 
    horizontal_negative_test(),
    vertical_positive_test(), 
    vertical_negative_test(),
    diagonal_positive_test(), 
    diagonal_negative_test(). 
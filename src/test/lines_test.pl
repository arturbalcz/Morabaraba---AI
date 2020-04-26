:- use_module(main/gamerules/board/lines).

horizontal_positive_test() :-
    line(1,1,4,1),
    line(6,2,4,2),
    line(5,3,4,3),
    line(5,4,6,4).

horizontal_negative_test() :-
    not(line(1,1,7,1)),
    not(line(2,2,6,2)),
    not(line(3,3,5,3)),
    not(line(1,4,3,4)),
    not(line(2,2,4,3)),
    not(line(3,4,4,4)).

vertical_positive_test() :-
    line(1,7,1,4),
    line(2,4,2,6),
    line(5,4,5,5),
    line(4,3,4,2).

vertical_negative_test() :-
    not(line(7,1,7,7)),
    not(line(6,6,6,2)),
    not(line(3,3,3,5)),
    not(line(4,5,4,7)),
    not(line(4,3,4,5)),
    not(line(2,6,3,4)).

diagonal_positive_test() :-
    line(2,6,3,5),
    line(6,2,7,1),
    line(1,1,2,2),
    line(5,5,6,6).

diagonal_negative_test() :-
    not(line(1,1,3,3)),
    not(line(5,3,7,1)),
    not(line(3,5,5,3)),
    not(line(3,3,5,5)).

test() :- 
    horizontal_positive_test(), 
    horizontal_negative_test(),
    vertical_positive_test(), 
    vertical_negative_test(),
    diagonal_positive_test(), 
    diagonal_negative_test(). 
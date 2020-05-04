:- use_module(main/gamerules/board/boardstate).

empty_test() :- 
    boardstate(Board, 
        a7, empty,
        d7, empty,
        g7, empty, 
        b6, empty,
        d6, empty,
        f6, empty, 
        c5, empty,
        d5, empty,
        e5, empty),
    Board = [empty,empty,empty,empty,empty,empty,empty,empty,empty].

some_black_test() :- 
    boardstate(Board, 
        a7, empty,
        d7, black,
        g7, empty, 
        b6, empty,
        d6, empty,
        f6, black, 
        c5, empty,
        d5, empty,
        e5, empty),
    Board = [empty,black,empty,empty,empty,black,empty,empty,empty].

black_and_white_test() :- 
    boardstate(Board, 
        a7, empty,
        d7, empty,
        g7, empty, 
        b6, black,
        d6, white,
        f6, empty, 
        c5, empty,
        d5, empty,
        e5, white),
    Board = [empty,empty,empty,black,white,empty,empty,empty,white].

test() :- 
    empty_test(), 
    some_black_test(),
    black_and_white_test().
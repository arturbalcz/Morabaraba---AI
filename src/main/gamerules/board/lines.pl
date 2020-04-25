:- module(lines, [line/4]).
:- use_module(coordinates).

connection(X1, Y1, X2, Y2) :-
    X1 is (X2 + 1), 
    Y1 is (Y2 + 1), !.

connection(X1, Y1, X2, Y2) :-
    X1 is (X2 - 1), 
    Y1 is (Y2 + 1), !.

connection(X1, 7, X2, 7) :- 
    X1 is (X2 + 3), !. 

connection(X1, 1, X2, 1) :- 
    X1 is (X2 + 3), !. 

connection(X1, 6, X2, 6) :- 
    X1 is (X2 + 2), !. 

connection(X1, 2, X2, 2) :-
    X1 is (X2 + 2), !. 

connection(X1, 5, X2, 5) :- 
    X1 is (X2 + 1), !. 

connection(X1, 3, X2, 3) :- 
    X1 is (X2 + 1), !. 

connection(X1, 4, X2, 4) :-
    X1 is (X2 + 1), !. 

edge(X1, Y1, X2, Y2) :-
    connection(X1, Y1, X2, Y2); 
    connection(X2, Y2, X1, Y1);
    connection(Y1, X1, Y2, X2);
    connection(Y2, X2, Y1, X1), !.

line(X1, Y1, X2, Y2) :- 
    coordinates(X1, Y1),
    coordinates(X2, Y2),
    edge(X1, Y1, X2, Y2), !.


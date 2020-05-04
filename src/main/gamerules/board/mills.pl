:- module(mills, [mill/6, mill/3]). 
:- use_module(lines). 
:- use_module(intersections).

connection(_,Y,_,Y,_,Y).

connection(X,_,X,_,X,_).

connection(X1,Y1,X2,Y2,X3,Y3) :- 
    X3 =:= (X2 - 1), 
    Y3 =:= (Y2 + 1), 
    X2 =:= (X1 - 1), 
    Y2 =:= (Y1 + 1), !.

connection(X1,Y1,X2,Y2,X3,Y3) :- 
    X3 =:= (X2 + 1), 
    Y3 =:= (Y2 + 1), 
    X2 =:= (X1 + 1), 
    Y2 =:= (Y1 + 1), !.

edge(X1,Y1,X2,Y2,X3,Y3) :- 
    connection(X1,Y1,X2,Y2,X3,Y3); 
    connection(X1,Y1,X3,Y3,X2,Y2);
    connection(X2,Y2,X1,Y1,X3,Y3);
    connection(X2,Y2,X3,Y3,X1,Y1);
    connection(X3,Y3,X1,Y1,X2,Y2);
    connection(X3,Y3,X2,Y2,X1,Y1), !. 

mill(X1,Y1,X2,Y2,X3,Y3) :- 
    line(X1,Y1,X2,Y2), 
    line(X2,Y2,X3,Y3), 
    edge(X1,Y1,X2,Y2,X3,Y3), !. 

mill(Label1, Label2, Label3) :- 
    intersection(Label1, X1, Y1),
    intersection(Label2, X2, Y2),
    intersection(Label3, X3, Y3),
    mill(X1,Y1,X2,Y2,X3,Y3), !. 
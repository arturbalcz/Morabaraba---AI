:- module(intersections, [intersection/3, intersection/2, intersection/1]).

intersection(a7, 1, 7).
intersection(d7, 4, 7). 
intersection(g7, 7, 7).

intersection(b6, 2, 6).
intersection(d6, 4, 6).
intersection(f6, 6, 6).

intersection(c5, 3, 5).
intersection(d5, 4, 5).
intersection(e5, 5, 5).

intersection(a4, 1, 4).
intersection(b4, 2, 4).
intersection(c4, 3, 4).

intersection(e4, 5, 4).
intersection(f4, 6, 4).
intersection(g4, 7, 4).

intersection(c3, 3, 3).   
intersection(d3, 4, 3).
intersection(e3, 5, 3).

intersection(b2, 2, 2).
intersection(d2, 4, 2).
intersection(f2, 6, 2).

intersection(a1, 1, 1).
intersection(d1, 4, 1).
intersection(g1, 7, 1).

intersection(Label) :- intersection(Label, _, _).
intersection(X, Y) :- intersection(_, X, Y).
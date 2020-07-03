:- use_module(webclient).

:- initialization(main, main).

main(Argv) :- 
    play(Argv).

play([]) :- 
    play_in_loop().

play([URL]) :-
    play_in_loop(URL).
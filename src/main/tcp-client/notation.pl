:- module(notation, [parse_move/4, write_move/4]).

parse_move(Notation, From, To, Remove) :-
    split_string(Notation, "-", "", FromTo),
    last(FromTo, ToRemoveNotation), 
    proper_length(FromTo, LengthFromTo),
    ( LengthFromTo == 2 ->
        nth0(0, FromTo, FromString),
        atom_string(From, FromString)
        ;
        From = x
    ),
    split_string(ToRemoveNotation, "x", "", ToRemove),
    proper_length(ToRemove, LengthToRemove),
    nth0(0, ToRemove, ToString),
    atom_string(To, ToString),
    ( LengthToRemove == 2 ->
        nth0(1, ToRemove, RemoveString),
        atom_string(Remove, RemoveString)
        ;
        Remove = x
    ).

write_move(From, To, Remove, Notation) :- 
    ( From == x ->
    FromTo = To
    ;
    atom_concat(From, "-", FromDash),
    atom_concat(FromDash, To, FromTo)
    ),
    ( Remove == x ->
    Notation = FromTo
    ;
    atom_concat(FromTo, "x", FromToX),
    atom_concat(FromToX, Remove, Notation)
    ).

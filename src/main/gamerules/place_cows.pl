:- module(place_cow, [place_cow/3, remove_cow/3, all_cow_places/3, all_cow_removes/3]). 

player_color(white).
player_color(black).

place_cow(PlayerColor, [empty|Rest], [PlayerColor|Rest]) :- player_color(PlayerColor). 
place_cow(PlayerColor, [X|Rest1], [X|Rest2]) :-  
    place_cow(PlayerColor, Rest1, Rest2). 

all_cow_places(PlayerColor, Board, AllNextBoards) :- 
    findall(NextBoard, place_cow(PlayerColor, Board, NextBoard), AllNextBoards). 

remove_cow(PlayerColor, [PlayerColor|Rest], [empty|Rest]) :- player_color(PlayerColor). 
remove_cow(PlayerColor, [X|Rest1], [X|Rest2]) :-  
    remove_cow(PlayerColor, Rest1, Rest2). 

all_cow_removes(PlayerColor, Board, AllNextBoards) :- 
    findall(NextBoard, remove_cow(PlayerColor, Board, NextBoard), AllNextBoards). 

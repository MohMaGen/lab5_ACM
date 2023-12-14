?- use_module(library(clpfd)).
?- use_module(library(clpq)).
?- use_module(library(lambda)).
?- use_module(library(lists)).


delta(A, B, D) :-
    { D =:= B - A }.


min([X|As], A) :-
    min([X|As], X, A).
min([], A, A).
min([A|As], Aminc, Amin) :-
    { A < Aminc },
    min(As, A, Amin),!;
    min(As, Aminc, Amin).

extremum_localization(Error, G, A, B, Xmin, Steps) :-
    delta(A, B, DX * 4),
    maplist(\J^X^ { X =:= A + DX * J }, [1,2,3], Xs),
    maplist(G, Xs, GXs),
    min(GXs, MinG),
    nth0(Idx, GXs, MinG),
    nth0(Idx, Xs, X),
    { A0 =:= X - DX },
    { B0 =:= X + DX },
    { Chk =:= (B0 - A0) / 2 },
    log_row(A, B, DX, Xs, GXs, Chk),
    (
        { Chk > Error },
        Steps1 #= Steps - 1,
        extremum_localization(Error, G, A0, B0, Xmin, Steps1),!;
        {Xmin =:= X},
        Steps = 1
    ).



r(X, R) :-
    { R =:= 1.38 - 0.56 * X - 4.61 * sin(0.99 * X) }.

in_range(X) :-
    { X >= -15.0 },
    { X =< 14.0 }.

graphic_pred(1, -12.0, -9.0).
graphic_pred(2, -6.0, -3.0).
graphic_pred(3, 0.0, 3.0).
graphic_pred(4, 6.0, 9.0).
graphic_pred(5, 12.0, 14.0).



run(Error, A, B, Xmin) :-
    graphic_pred(_, A, B),
    extremum_localization(Error, r, A, B, Xmin, Steps),
    log_line(10),
    format('+~n'),
    format('steps ~d', [Steps]),
    log(Error, V),
    log(10, Base),
    {E =:= - V / Base },
    sformat(S, '~d ~f~n', [Steps, E]),
    write(output, S).





log_row(A, B, DX, Xs, Gs, Chk) :-
    log_line(10),
    format('+~n'),
    maplist(log_cell, [A, B, DX]),
    maplist(log_cell, Xs),
    maplist(log_cell, Gs),
    log_cell(Chk),
    format('|~t~n').

log_cell(V) :-
    sformat(S, '~2f', [V]),
    writef('| %10c ', [S]).

log_line(1) :-
    writef('+------------'),!.

log_line(Size) :-
    log_line(1),
    Size1 #= Size - 1,
    Size1 #> 0,
    log_line(Size1),!.


f_compoundF(_,[],[]):-!.
f_compoundF(Alias,[F|Tail],[F|FTail]):-
        (
          (F=..[Op|[Alias::P,T]]) %left side case
          ;
          (F=..[Op|[T,Alias::P]]) %right side case
        ),
        atomic(T),
        free(Alias,Free),
	%+Bounded
        %atomicMemberOf(Alias::P,Free),!,
        memberchk(Alias::P,Free),!,
	%-Bounded
        f_compoundF(Alias,Tail,FTail).

f_compoundF(Alias,[_|Tail],FTail):-
        f_compoundF(Alias,Tail,FTail).

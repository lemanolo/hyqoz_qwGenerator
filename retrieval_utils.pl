r_compoundF(_,[],[]):-!.
r_compoundF(Alias,[F|Tail],[F|FTail]):-
	(
	  (F=..[Op|[Alias::B,T]]) %left side case
	  ;
	  (F=..[Op|[T,Alias::B]]) %right side case
	),
	bounded(Alias,Bounded),
	%+Bounded
	%atomicMemberOf(Alias::B,Bounded),
	memberchk(Alias::B,Bounded),
	%-Bounded
	atomic(T),!,
	r_compoundF(Alias,Tail,FTail).

r_compoundF(Alias,[_|Tail],FTail):-
	r_compoundF(Alias,Tail,FTail).

b_compoundF(_,[],[]):-!.
b_compoundF(Alias,[F|Tail],[F|FTail]):-
	(
	  (F=..[Op|[Alias::B,T]]) %left side case
	  ;
	  (F=..[Op|[T,Alias::B]]) %right side case
	),
	\+ atomic(T),
	bounded(Alias,Bounded),
	%+Bounded
	%Bounded atomicMemberOf(Alias::B,Bounded),!,
	memberchk(Alias::B,Bounded),!,
	%-Bounded
	b_compoundF(Alias,Tail,FTail).

b_compoundF(Alias,[_|Tail],FTail):-
	b_compoundF(Alias,Tail,FTail).

b_freeAliases([],_,[]):-!.
b_freeAliases([Exp|ETail],Alias,[FAlias|FTail]):-
	(
	   (Exp=..[_|[ Alias::B, FAlias::F]],!) %left side case
	   ;
	   (Exp=..[_|[FAlias::F,  Alias::B]],!)  %right side case
	),!,
	bounded(Alias,Bounded),
	free(FAlias,Free),
	%+Bounded
	%atomicMemberOf(Alias::B,Bounded),
	%atomicMemberOf(FAlias::F,Free),!,
	memberchk(Alias::B,Bounded),
	memberchk(FAlias::F,Free),!,
	%-Bounded
	b_freeAliases(ETail,Alias,FTail).


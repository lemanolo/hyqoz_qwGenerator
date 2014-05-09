:-op(350,xfy,::).

subtype(A::Def,A::Def):-!.

subtype(A::Def1,A::Def2):-
	list(Def1),
	list(Def2),
	length(Def1,L1),
	length(Def2,L2),
	L2>1, %it disjoints with the set type
	L1=<L2,
	findall(T2,(member(T1,Def1),member(T2,Def2),subtype(T1,T2)),SuperTypes2),
	length(SuperTypes2,L1),!.

subtype(A::[Def1],A::[Def2]):-
	subtype(Def1,Def2),!.
	

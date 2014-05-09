projection(SELECT,AP):-
	%+Dataset
	%findall(Alias,dataset(Alias,_,_,_),DS),
	findall(Alias,type_name(Alias,_),DS),
	%-Dataset
	projection(DS,SELECT,AP).

projection([],_,[]):-!.
projection([Alias|Tail],SELECT,[Function|APTail]):-
	findall(Alias::Path,member(Alias::Path,SELECT),P),
	%Result type(Alias,Type),
	%Result newType(P,Type,Result),
	%Result Result\==Type,!,
	create_dtf(proj,[Alias],[],P,Function),
	projection(Tail,SELECT,APTail).

projection([_|Tail],SELECT,APTail):-
	projection(Tail,SELECT,APTail).

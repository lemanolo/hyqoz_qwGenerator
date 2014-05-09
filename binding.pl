binding(WHERE,AF):-
	%+Dataset
	%findall(Alias,dataset(Alias,_,_,_),Aliases),
	findall(Alias,type_name(Alias,_),Aliases),
	%-Dataset
	binding(Aliases,WHERE,AF).

binding([],_,[]):-!.
binding([Alias|Tail],WHERE,[Function|AFTail]):-
	b_compoundF(Alias,WHERE,F),
	F\==[],!,
	b_freeAliases(F,Alias,FreeAliases),
	union(FreeAliases,[Alias],DS_b),
	%+Bounded
	%findall(Param,(member(A,DS_b),params(A,Params),atomicMemberOf(Param,Params)),P),
	findall(Atts,(member(A,DS_b),atts(A,Atts)),AttsList),
	unionAll(AttsList,P),
	%-Bounded
	%Result type(DS_b,AllTypes),
	%Result merge(AllTypes,Result),
	create_dtf(bind,DS_b,F,P,Function),
	binding(Tail,WHERE,AFTail).

binding([_|Tail],WHERE,AFTail):-%if it is not a binding but a retrieval function
	binding(Tail,WHERE,AFTail).


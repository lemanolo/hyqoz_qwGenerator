retrieval(WHERE,AF):-
	%+Dataset
	%findall(Alias,dataset(Alias,_,_,_),Aliases),
	findall(Alias,type_name(Alias,_),Aliases),
	%-Dataset
	retrieval(Aliases,WHERE,AF).

retrieval([],_,[]):-!.
retrieval([Alias|Tail],WHERE,[Function|AFTail]):-
	r_compoundF(Alias,WHERE,F),
	F\==[],!,
	%Result type(Alias,Result),
	%+Bounded
        %findall(Param,(params(Alias,Params),atomicMemberOf(Param,Params)),P),
	atts(Alias,P),
	%-Bounded
	create_dtf(retr,[Alias],F,P,Function),
	retrieval(Tail,WHERE,AFTail).

retrieval([_|Tail],WHERE,AFTail):-!,
	retrieval(Tail,WHERE,AFTail).


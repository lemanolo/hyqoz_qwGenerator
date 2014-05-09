filtering(WHERE,AF):-
	%+Dataset
	%findall(Alias,dataset(Alias,_,_,_),DS),
	findall(Alias,type_name(Alias,_),DS),
	%-Dataset
	filtering(DS,WHERE,AF).

filtering([],_,[]):-!.
filtering([Alias|Tail],WHERE,[Function|FTail]):-
	f_compoundF(Alias,WHERE,F),
	F\==[],!,
	%Result type(Alias,Result),
        %+Bounded
        %findall(Param,(params(Alias,Params),atomicMemberOf(Param,Params)),P),
	atts(Alias,P),
        %-Bounded
	create_dtf(filt,[Alias],F,P,Function),
	filtering(Tail,WHERE,FTail).

filtering([_|Tail],WHERE,FTail):-
	filtering(Tail,WHERE,FTail).

correlation(WHERE,AC):-
	setof(Pair,correlation_pair(WHERE,Pair),Pairs),!,
	correlation(Pairs,WHERE,AC).

correlation(_,[]):-!.


correlation([],_,[]):-!.
correlation([Pair|Tail],WHERE,[Function|CTail]):-
	Pair=[Alias1,Alias2],
	findall(Exp,(member(Exp,WHERE),
		   (correlation_expression(Exp,Alias1::_,Alias2::_);correlation_expression(Exp,Alias2::_,Alias1::_))
		  ), F),!,
	%Result type(Alias1,Type1),
	%Result type(Alias2,Type2),
	%+Bounded
	%findall(Param,(member(Alias,[Alias1,Alias2]),params(Alias,Params),atomicMemberOf(Param,Params)),P),
	atts(Alias1,Atts1),
	atts(Alias2,Atts2),
	union(Atts1,Atts2,P),
	%-Bounded
	%Result merge([Type1,Type2],Result),
	create_dtf(corr,[Alias1,Alias2],F,P,Function),
	correlation(Tail,WHERE,CTail).

correlation([_|Tail],WHERE,CTail):-
	correlation(Tail,WHERE,CTail).
	

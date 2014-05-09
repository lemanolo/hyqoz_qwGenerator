
%convertToExpressions([],[]):-!.
%convertToExpressions([List|Tail],[Exp|ExpTail]):-!,
	%Exp=..List,
	%convertToExpressions(Tail,ExpTail).
	

correlation_pair(WHERE,Pair):-
	member(Exp,WHERE),
	%correlation_expression(WHERE,Exp),
	correlation_expression(Exp,Alias1::_,Alias2::_),
	%Exp=..[_,Alias1::_,Alias2::_],
	%+Dataset
	%dataset(Alias1,_,_,_),
	%dataset(Alias2,_,_,_),
	type_name(Alias1,_),
	type_name(Alias2,_),
	%-Dataset
	Pair=[Alias1,Alias2].

%correlation_expression(WHERE,Exp):-
	%member(Exp,WHERE),
	%Exp=..ExpList,
	%sort(ExpList),
	%ExpList=[_,AliasLeft::PathLeft,AliasRight::PathRight],
	%free(AliasLeft,FreeLeft),   memberOf(AliasLeft::PathLeft,FreeLeft),
	%free(AliasRight,FreeRight), memberOf(AliasRight::PathRight,FreeRight).

%correlation_expression(WHERE,Path1,Op,Path2):-
	%correlation_expression(WHERE,Exp),
	%Exp=..[Op,Path1,Path2].

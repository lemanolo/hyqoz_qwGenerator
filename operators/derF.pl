%pi([a::nickname, b::nickname, a::friendship::with::friend, i::interests::interest::tag],
%	sigma(a::nickname='Alice',
%		sigma( b::nickname='Bob', 
%	       		sigma(i::nickname=a::friendship::with::friend, 
%	       			sigma(i::interests::interest::tag = 'Art history', 
%	       				sigma(a::friendship::with::friend= b::friendship::with::friend, times(rho(whatulike::interests as i),
%						times(rho(friends::friendsof as a), rho(friends::friendsof as b)))))))))

%sigma(b::nickname='Bob',rho(friends::friendsof as b))
%sigma(b::friendship::with::friend='Claire',sigma(b::nickname='Bob',rho(friends::friendsof as b)))
%pi([b::nickname, b::friendship::with::friend], sigma(b::friendship::with::friend='Claire',sigma(b::nickname='Bob',rho(friends::friendsof as b))))
%pi([b::nickname, b::friendship::with::friend], sigma(b::friendship::with::friend='Claire',sigma(b::nickname='Bob', sigma(a::nickname='Alice',times(rho(friends::friendsof as b),rho(friends::friendsof as a))))))

der(pi(Exp,SubHQ),[DFunction|TailF]):-
	memberchk(Alias::_,Exp),
	findall(Term,(member(Term,Exp),
		      Term=(Alias::_)),
	 	P),
	create_function(projection,[Alias],[],P,result,DFunction),
	difference(Exp,P,SubExp),
	((SubExp\=[],der(pi(SubExp,SubHQ), TailF));
	 (SubExp=[], der(SubHQ,TailF)           )).

der(rho(DS as Alias),[]):- assertz(alias(Alias,DS)).

der(sigma(RExp,SubHQ),[DFunction|TailF]):-
	der(SubHQ,TailF),
	rexp(RExp,Alias),!,
	atts(Alias,P),
	create_function(retrieval,[Alias],[RExp],P,result,DFunction).

der(sigma(FExp,SubHQ),[DFunction|TailF]):-
	der(SubHQ,TailF),
	fexp(FExp,Alias::_),!,
	atts(Alias,P),
	create_function(filtering,[Alias],[FExp],P,result,DFunction).

der(sigma(BExp,SubHQ),[DFunction|TailF]):-
	der(SubHQ,TailF),
	bexp(BExp,Alias1::_,Alias2::_),!,
	atts(Alias1,P1),
	atts(Alias2,P2),
	union(P1,P2,P),
        create_function(binding,[Alias1,Alias2],[BExp],P,result,DFunction).

der(sigma(CExp,SubHQ),[DFunction|TailF]):-
	der(SubHQ,TailF),
	cexp(CExp,Alias1::_,Alias2::_),!,
	atts(Alias1,P1),
	atts(Alias2,P2),
	union(P1,P2,P),
        create_function(correlation,[Alias1,Alias2],[CExp],P,result,DFunction).

der(times(SubHQ1, SubHQ2),F):-
	der(SubHQ1,F1),
	der(SubHQ2,F2),
	union(F1,F2,F).
	
rexp(Exp,Alias):-
        Exp=..[_,Alias::Path,Right],
        bounded(Alias,Bounded),
        memberchk(Alias::Path,Bounded),
        atomic(Right),!.

rexp(Exp,Alias):-
        Exp=..[_,Left,Alias::Path],
        bounded(Alias,Bounded),
        memberchk(Alias::Path,Bounded),
        atomic(Left),!.


bexp(Exp,Alias1::Path1,Alias2::Path2):-
        Exp=..[_,Alias1::Path1,Alias2::Path2],
        bounded(Alias1,Bounded),
        memberchk(Alias1::Path1,Bounded),
        free(Alias2,Free),
        memberchk(Alias2::Path2,Free),!.

bexp(Exp,Alias2::Path2,Alias1::Path1):-
        Exp=..[_,Alias1::Path1,Alias2::Path2],
        free(Alias1,Free),
        memberchk(Alias1::Path1,Free),
        bounded(Alias2,Bounded),
        memberchk(Alias2::Path2,Bounded),!.

fexp(Exp,Alias::Path):-
        Exp=..[_,Alias::Path,Right],
        free(Alias,Free),
        memberchk(Alias::Path,Free),
        atomic(Right),!.

fexp(Exp,Alias::Path):-
        Exp=..[_,Left,Alias::Path],
        free(Alias,Free),
        memberchk(Alias::Path,Free),
        atomic(Left),!.

cexp(Exp,Alias1::Path1,Alias2::Path2):-
        Exp=..[_,Alias1::Path1,Alias2::Path2],
        free(Alias1,Free1),
        memberchk(Alias1::Path1,Free1),
        free(Alias2,Free2),
        memberchk(Alias2::Path2,Free2),!.



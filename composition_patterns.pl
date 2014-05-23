%qw_pattern(independent,Pattern):-
%	PrePattern1=[ arc(in,par),
%                         arc(par,a),arc(a,end_par),
%                         arc(par,b),arc(b,end_par),
%			 	      arc(end_par,out)],
%	new_atom(par_,PAR),
%	atom_concat(par_,Suffix,PAR),
%	atom_concat(end_par_,Suffix,ENDPAR),
%	replace(arc(_,par),arc(_,PAR),PrePattern1,PrePattern2),
%	replace(arc(par,_),arc(PAR,_),PrePattern2,PrePattern3),
%	replace(arc(_,end_par),arc(_,ENDPAR),PrePattern3,PrePattern4),
%	replace(arc(end_par,_),arc(ENDPAR,_),PrePattern4,Pattern).

qw_pattern(independent,QW):-
	new_atom(par_,PAR),
	atom_concat(par_,Suffix,PAR),
	atom_concat(end_par_,Suffix,ENDPAR),
	%PAR=par,
	%ENDPAR=end_par,

	A=[a,b],
	P=[PAR,ENDPAR],
	E=[ arc(in,PAR),
                         arc(PAR,a),arc(a,ENDPAR),
                         arc(PAR,b),arc(b,ENDPAR),
			 	      arc(ENDPAR,out)],
	unionAll([A,P,[in,out]],V),
	QW=qw(A,P,V,E,in,out,cost(_,_,_)).

%qw_pattern(independent,QW):-
%        A=[a,b],
%        P=[],
%        E=[ arc(in,a), arc(a,b), arc(b,out)],
%        unionAll([A,P,[in,out]],V),
%        QW=qw(A,P,V,E,in,out,cost(_,_,_)).
%
%qw_pattern(independent,QW):-
%	A=[a,b],
%        P=[],
%        E=[ arc(in,b), arc(b,a), arc(a,out)],
%        unionAll([A,P,[in,out]],V),
%        QW=qw(A,P,V,E,in,out,cost(_,_,_)).

qw_pattern(concurrent,QW):-
        A=[a,b],
        P=[],
        E=[ arc(in,a), arc(a,b), arc(b,out)],
        unionAll([A,P,[in,out]],V),
        QW=qw(A,P,V,E,in,out,cost(_,_,_)).

qw_pattern(concurrent,QW):-
        A=[a,b],
        P=[],
        E=[ arc(in,b), arc(b,a), arc(a,out)],
        unionAll([A,P,[in,out]],V),
        QW=qw(A,P,V,E,in,out,cost(_,_,_)).

qw_pattern(dependent,QW):-
        A=[a,b],
        P=[],
        E=[ arc(in,a), arc(a,b), arc(b,out)],
        unionAll([A,P,[in,out]],V),
        QW=qw(A,P,V,E,in,out,cost(_,_,_)).


compose_qw(qw(_,_,_,E_p,_,_,_),SubQWA,SubQWB,qw(A,P,V,E,in,out,QW_COST)):-
	%+Result
	%arg(6,ActivityA,SubQWA),
	%arg(6,ActivityB,SubQWB),
	%arg(4,ActivityA,SubQWA),
	%arg(4,ActivityB,SubQWB),
	%-Result
	SubQWA=qw(_,_,_,E_a,in,out,_),
	SubQWB=qw(_,_,_,E_b,in,out,_),

	FirstArcA =arc(in,FirstActivityA),
	LastArcA  =arc(LastActivityA,out),
	memberchk(FirstArcA, E_a),
	memberchk(LastArcA,  E_a),
	difference(E_a,[FirstArcA,LastArcA],FreeQWA),

	FirstArcB =arc(in,FirstActivityB),
	LastArcB  =arc(LastActivityB,out),
	memberchk(FirstArcB, E_b),
	memberchk(LastArcB,  E_b),
	difference(E_b,[FirstArcB,LastArcB],FreeQWB),

	replace(arc(_,a),arc(_,FirstActivityA), E_p,     PreQW1),
	replace(arc(a,_),arc(LastActivityA,_),  PreQW1, PreQW2),
	replace(arc(_,b),arc(_,FirstActivityB), PreQW2, PreQW3),
	replace(arc(b,_),arc(LastActivityB,_),  PreQW3, PreQW4),
	unionAll([PreQW4,FreeQWA,FreeQWB],E),

	findall(Activity, (member(Arc,E),(Arc=..[arc,Activity,_]), \+is_control(Activity),\+is_parallel(Activity)),A),
	findall(Parallel, (member(Arc,E),(Arc=..[arc,Parallel,_]),   is_parallel(Parallel)),P),
	unionAll([A,P,[in,out]],V),
	sort(A),
	sort(P),
	sort(V),
	sort(E),
       (
              weighting(cost) -> qw_cost(qw(A,P,V,E,in,out,QW_COST),QW_COST)
                               ; QW_COST=cost(0,0,0)
       ).
	
%notrace.

is_parallel(V):- atom_concat(par,_,V),!.
is_parallel(V):- atom_concat(end_par,_,V),!.

is_control(V):- atom_concat(in,_,V),!.
is_control(V):- atom_concat(out,_,V),!.


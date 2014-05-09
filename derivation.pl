derive(sco(SCO),F):-!,
	derive(SCO,F).
derive(rho(S::M as Name, S::M), []):-!,
	nl,write('assertz(type_name('),write(Name),write(','),write(S::M),write('))'),
	assertz(type_name(Name,S::M)).

derive(pi(Exp, E_), [DTF|F]):-
	memberchk(Name::_,Exp),!,
	A=[Name],
	E=[],
	findall(Name::Path,member(Name::Path,Exp),P),
	difference(Exp,P,Exp_),
	(
		(Exp_\=[],derive(pi(Exp_,E_), F),!);
		(Exp_=[], derive(E_, F),!)
	),
	create_dtf(p,A,E,P,DTF).

derive(sigma(Exp,E_), [DTF|F]):-
	derive(E_,F),
	(
		(rexp(Exp,Name),Type=r,!);
		(fexp(Exp,Name),Type=f,!)
	),!,
	A=[Name],
	E=[Exp],
	atts(Name,P),
	create_dtf(Type,A,E,P,DTF).

derive(C,[DTF|F]):-
	C=..[_,Exp,E1,E2],
	derive(E1,F1),
	derive(E2,F2),
	union(F1,F2,F),
	memberchk(Exp1,Exp),
        (
                (cexp(Exp1,Name1::Path1, Name2::Path2),Type=c,!);
                (bexp(Exp1,Name1::Path1, Name2::Path2),Type=b,!)
        ),!,
	A=[Name1,Name2],
	E=Exp,
	atts(Name1,P1), atts(Name2,P2),
	union(P1,P2,P),
	create_dtf(Type,A,E,P,DTF).
	
	
	

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

fexp(Exp,Alias):-
        Exp=..[_,Alias::Path,Right],
        free(Alias,Free),
        memberchk(Alias::Path,Free),
        atomic(Right),!.

fexp(Exp,Alias):-
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


int(DTF,pi(P,SCO)):-
	DTF=..[_,A,E,P|_],
	P\=[],!,
	int(dtf(A,E,[]),SCO).


int(DTF,SCO):-
	DTF=..[_,A,E,[]|_],
	member(Exp,E),
	cexp(Exp,Name1::_,Name2::_),
	findall(OtherEXP,(member(OtherEXP,E), (rexp(OtherEXP,Name1); bexp(OtherEXP, Name1::_,_::_))),RetrievalFor1),
	RetrievalFor1\=[],
	findall(OtherEXP,(member(OtherEXP,E), (rexp(OtherEXP,Name2); bexp(OtherEXP, Name2::_,_::_))),RetrievalFor2),
	RetrievalFor2\=[],
 	Op=corr,
	%trace,
	findall(Exp_op,(member(Exp_op,E), condition_over(Exp_op,Name1), condition_over(Exp_op,Name2)),EOP),
	difference(E,EOP,E_),
	sort(E_),
	related_with(E_,Name1,ExpRelatedWith1),
	findall(Exp1,(member(Exp1,ExpRelatedWith1),\+condition_over(Exp1,Name2)),E1),
	related_with(E_,Name2,ExpRelatedWith2),
	findall(Exp2,(member(Exp2,ExpRelatedWith2),\+condition_over(Exp2,Name1)),E2),
	unionAll([E1,E2],UnionE),
	sort(UnionE),
	UnionE=E_,
%%%%%%%
        findall((S::M as DS), (member(Exp1,E1), condition_over(Exp1,DS), memberchk((S::M as DS), A)),A1),
	sort(A1),
        findall((S::M as DS), (member(Exp2,E2), condition_over(Exp2,DS), memberchk((S::M as DS), A)),A2),
	sort(A2),
        int(dtf(A1,E1,[]),SCO1),
        int(dtf(A2,E2,[]),SCO2),
%%%%%%%
	SCO=..[Op,EOP,SCO1,SCO2],!.

int(DTF,SCO):-
        DTF=..[_,A,E,[]|_],
        member(Exp,E),
        bexp(Exp,Name1::_,Name2::_),
	findall(OtherEXP,(member(OtherEXP,E), (rexp(OtherEXP,Name2); bexp(OtherEXP, Name2::_,_::_))),RetrievalFor2),
	RetrievalFor2\=[],
	Op=bind,
        %trace,
        findall(Exp_op,(member(Exp_op,E), condition_over(Exp_op,Name1), condition_over(Exp_op,Name2)),EOP),
        difference(E,EOP,E_),
        sort(E_),
        related_with(E_,Name1,ExpRelatedWith1),
        findall(Exp1,(member(Exp1,ExpRelatedWith1),\+condition_over(Exp1,Name2)),E1),
        related_with(E_,Name2,ExpRelatedWith2),
        findall(Exp2,(member(Exp2,ExpRelatedWith2),\+condition_over(Exp2,Name1)),E2),
        unionAll([E1,E2],UnionE),
        sort(UnionE),
        UnionE=E_,
%+Right deep
        findall((S1::M1 as Name1), (member(Exp1,E),condition_over(Exp1,Name1),member((S1::M1 as Name1), A)),A1),
        sort(A1),
        findall((S2::M2 as Name),(member(Exp2,E),condition_over(Exp2,Name),Name\=Name1,member((S2::M2 as Name), A)),A2),
        sort(A2),
        int(dtf(A1,E1,[]),SCO1),
        int(dtf(A2,E2,[]),SCO2),
%-Right deep
        SCO=..[Op,EOP,SCO1,SCO2],!.


int(DTF,sigma(Exp,SCO)):-
	DTF=..[_,A,E,[]|_],
	member(Exp,E),
        (
                fexp(Exp,Name),!;
                rexp(Exp,Name),!
        ),!,
	difference(E,[Exp],E_),
	int(dtf(A,E_,[]),SCO).

int(DTF,rho((S::M as Name), S::M)):-
	DTF=..[_,[(S::M as Name)],[],[]|_],!.
	


related_with(Expressions,DSName,ExpressionsRelated):-
	findall(Exp,(member(Exp,Expressions), condition_over(Exp,DSName)), ExpressionsOf_),
	findall(DSOther, (member(Exp,Expressions), condition_over(Exp,DSName), condition_over(Exp,DSOther), DSOther\=DSName), RelatedWith),
	sort(RelatedWith),
	difference(Expressions,ExpressionsOf_,RemindingExpressions),
	findall(ER,(member(RW,RelatedWith), member(Exp,RemindingExpressions), condition_over(Exp,RW), related_with(RemindingExpressions,RW,ER)), ExpressionsRelated_),
	unionAll([ExpressionsOf_|ExpressionsRelated_],ExpressionsRelated).


condition_over(Exp, Name):- Exp=..[_,Name::_,_].
condition_over(Exp, Name):- Exp=..[_,_,Name::_].

print_dtf(DTF):-
	DTF=..[Name,A,E,P|_],
	write(Name),write('('),
	write('['),
	findall(_,(member(DS,A),write(DS),write(', ')),_),
	write('],'),
	nl,write('['),
	findall(_,(member(Exp,E), write(Exp),write(', ')),_),
	write('],'),
	nl,write('['),
	findall(_,(member((_::_ as TypeName),A),
		   findall(Path,(member(TypeName::Path,P),write(TypeName::Path),write(', ')),Paths),
		   Paths\=[],
		   nl
		),_),
	write(']'),
	nl,write(').').

print_sco(SCO):-
	do_print_sco(SCO,0),write('.').

do_print_sco(rho((S::M as Name),S::M),Tab):-!,
	writeN(Tab),
	write('rho('),write((S::M as Name)),write(', '), write(S::M),
	write(')').

do_print_sco(SCO,Tab):-
	SCO=..[Op,Exp,SCO_],!,
	writeN(Tab),
	write(Op),write('('),write(Exp),
	write(', '),
	Tab2 is Tab+1,
	nl,do_print_sco(SCO_,Tab2),
	nl,writeN(Tab),write(')').

do_print_sco(SCO,Tab):-
	SCO=..[Op,Exp,SCO1_,SCO2_],!,
	writeN(Tab),
	write(Op),write('('),write(Exp),
	write(', '),
	Tab2 is Tab+1,
	nl, do_print_sco(SCO1_,Tab2),write(', '),
	nl, do_print_sco(SCO2_,Tab2),
	nl,writeN(Tab),write(')').

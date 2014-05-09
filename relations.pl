relations([tqw(QW,DTF)|Tail],Relations):-!, %is a list of tqw's
	TQWS=[tqw(QW,DTF)|Tail],
	findall([DTF1,DTF2],(sublist(Pair,TQWS),Pair=[tqw(_,DTF1),tqw(_,DTF2)]),PairsOfDTFS),
	do_relations(PairsOfDTFS,Relations).

relations(Functions,Relations):-
	\+Functions=[tqw(_,_)|_],!, %is alist of dtf's
	findall(Pair,(sublist(Pair,Functions),length(Pair,2)),PairsOfDTFS),
	do_relations(PairsOfDTFS,Relations).

do_relations([],[]):-!.

do_relations([[F1,F2]|Tail],[independent(IdF1,IdF2)|RTail]):-
        relation([F1,F2],independent(F1,F2)),!,
        arg(4,F1,IdF1),
        arg(4,F2,IdF2),
        do_relations(Tail,RTail).

do_relations([[F1,F2]|Tail],[concurrent(IdF1,IdF2)|RTail]):-
        relation([F1,F2],concurrent(F1,F2)),!,
        arg(4,F1,IdF1),
        arg(4,F2,IdF2),
        do_relations(Tail,RTail).

do_relations([[F1,F2]|Tail],[dependent(IdF1,IdF2)|RTail]):-
        relation([F1,F2],dependent(F1,F2)),!,
        arg(4,F1,IdF1),
        arg(4,F2,IdF2),
        do_relations(Tail,RTail).

do_relations([[F1,F2]|Tail],[dependent(IdF2,IdF1)|RTail]):-
        relation([F2,F1],dependent(F2,F1)),!,
        arg(4,F1,IdF1),
        arg(4,F2,IdF2),
        do_relations(Tail,RTail).



%do_relations([_|Tail],RTail):-
	%do_relations(Tail,RTail).

do_relations([[F1,F2]|Tail],[fail(IdF1,IdF2)|RTail]):-
        arg(4,F1,IdF1),
        arg(4,F2,IdF2),
	do_relations(Tail,RTail).


relation([F1,F2],independent(F1,F2)):-
	arg(1,F1,Aliases1),
	arg(1,F2,Aliases2),
%	sort(A1,Aliases1),
%	sort(A2,Aliases2),
	intersection(Aliases1,Aliases2,[]).

relation([F1,F2],concurrent(F1,F2)):-
	%nl,write('--------------------------------------------------'),
	%nl,write('          F1: '),write(F1),
	%nl,write('          F2: '),write(F2),
	arg(1,F1,Aliases1),
	arg(1,F2,Aliases2),
%	sort(A1,Aliases1),
%	sort(A2,Aliases2),
	intersection(Aliases1,Aliases2,Intersection),
	Intersection\==[],
	%nl,write('Intersection: '),write(Intersection),
%+No-anti-dependency
 	arg(3,F1,Projection1),
 	arg(3,F2,Projection2),

        arg(2,F1,Expression1),
        arg(2,F2,Expression2),

	findall(Alias::Path,(member(Exp,Expression1),
			        (Exp=..[_,Alias::Path,_]
				 ;
				 Exp=..[_,_,Alias::Path]
				),
			     memberchk(Alias,Intersection),
			     \+memberchk(Alias::Path,Projection2)
			    ),MissingRequired1),
	MissingRequired1=[],

	findall(Alias::Path,(member(Exp,Expression2),
			        (Exp=..[_,Alias::Path,_]
				 ;
				 Exp=..[_,_,Alias::Path]
				),
			     memberchk(Alias,Intersection),
			     \+memberchk(Alias::Path,Projection1)
			    ),MissingRequired2),
	MissingRequired2=[],
%-No-anti-dependency

%+No-retrieval or binding
	union(Expression1,Expression2,ExpressionUnion),
        findall(Alias, (member(Exp,ExpressionUnion),
                        (retrieval_expression(Exp,Alias)
                         ;
                         binding_expression(Exp,Alias::_,_)
                        ),
                        memberchk(Alias,Intersection)
                       ),
                BoundedAliases),
        BoundedAliases=[],!.
%-No-retrieval or binding

relation([F1,F2],dependent(F1,F2)):-
%	nl,write('--------------------------------------------------'),
%	nl,write('          F1: '),write(F1),
%	nl,write('          F2: '),write(F2),
	arg(1,F1,Aliases1),
	arg(1,F2,Aliases2),
%	sort(A1,Aliases1),
%	sort(A2,Aliases2),
	intersection(Aliases1,Aliases2,Intersection),
	Intersection\==[],
%	nl,write('Intersection: '),write(Intersection),
	arg(2,F1,Expression1),
	arg(2,F2,Expression2),
%+retrieval or binding 
	%F1 produces data for F2 
	findall(Alias, (member(Exp,Expression1),
			(retrieval_expression(Exp,Alias)
			 ;
			 binding_expression(Exp,Alias::_,_)
			),
			memberchk(Alias,Intersection)
		       ),
		BoundedAliases1),
	BoundedAliases1\==[],
	%F2 does not produce data for F1 NO-DEADLOCK
	findall(Alias, (member(Exp,Expression2),
			(retrieval_expression(Exp,Alias)
			 ;
			 binding_expression(Exp,Alias::_,_)
			),
			memberchk(Alias,Intersection)
		       ),
		BoundedAliases2),
	BoundedAliases2=[],
%-retrieval or binding
        arg(3,F1,Projection1),
%+no-anti-dependency
	findall(Alias::Path,(member(Exp,Expression2),
				    (Exp=..[_,Alias::Path,_]
				     ;
				     Exp=..[_,_,Alias::Path]
				    ),
				    memberchk(Alias,Intersection),
				    \+memberchk(Alias::Path,Projection1)
			   ),
		MissingParams),
	MissingParams=[],!.
%-no-anti-dependency
%	nl,write('BoundedAliases:'),write(BoundedAliases),
%	nl,write('DEPENDENCE!!!! retrieval').

relation([F1,F2],dependent(F1,F2)):-
%        nl,write('--------------------------------------------------'),
%        nl,write('          F1: '),write(F1),
%%        nl,write('          F2: '),write(F2),
	arg(1,F1,Aliases1),
	arg(1,F2,Aliases2),
%	sort(A1,Aliases1),
%	sort(A2,Aliases2),
        intersection(Aliases1,Aliases2,Intersection),
        Intersection\==[],
%        nl,write('Intersection: '),write(Intersection),

        arg(3,F2,Projection2),

        arg(2,F1,Expression1),
        arg(2,F2,Expression2),
%+retrieval or binding
	unionAll([Expression1,Expression2],UnionExpressions),
	findall(Alias, (member(Exp,UnionExpressions),
			(retrieval_expression(Exp,Alias)
			 ;
			 binding_expression(Exp,Alias::_,_)
			),
			memberchk(Alias,Intersection)
		       ),
		BoundedAliases),
	BoundedAliases=[],
%-retrieval or binding

%+anti-dependency
	findall(Alias::Path,(member(Exp,Expression1),
				    (Exp=..[_,Alias::Path,_]
				     ;
				     Exp=..[_,_,Alias::Path]
				    ),
				    memberchk(Alias,Intersection),
				    \+memberchk(Alias::Path,Projection2)
			   ),
		MissingParams),
	MissingParams\==[],!.
%-anti-dependency
%	nl,write('MissingParams: '),write(MissingParams),
%        nl,write('DEPENDENCE!!!! anti-dependence').




retrieval_expression(Exp,Alias):-
	Exp=..[_,Alias::Path,Right],
	atomic(Right),
	bounded(Alias,Bounded),
	%+Bounded
	%memberOf(Alias::Path,Bounded),
	memberchk(Alias::Path,Bounded),!.
	%-Bounded

retrieval_expression(Exp,Alias):-
	Exp=..[_,Left,Alias::Path],
	atomic(Left),
	bounded(Alias,Bounded),
	%+Bounded
	%memberOf(Alias::Path,Bounded),
	memberchk(Alias::Path,Bounded),!.
	%-Bounded


binding_expression(Exp,Alias1::Path1,Alias2::Path2):-
	Exp=..[_,Alias1::Path1,Alias2::Path2],
	bounded(Alias1,Bounded),
	free(Alias2,Free),
	%+Bounded
        %memberOf(Alias1::Path1,Bounded),
        %memberOf(Alias2::Path2,Free),!.
        memberchk(Alias1::Path1,Bounded),
        memberchk(Alias2::Path2,Free),!.
	%-Bounded

binding_expression(Exp,Alias2::Path2,Alias1::Path1):-
	Exp=..[_,Alias1::Path1,Alias2::Path2],
	free(Alias1,Free),
	bounded(Alias2,Bounded),
	%+Bounded
        %memberOf(Alias1::Path1,Free),
        %memberOf(Alias2::Path2,Bounded),!.
        memberchk(Alias1::Path1,Free),
        memberchk(Alias2::Path2,Bounded),!.
	%-Bounded

filtering_expression(Exp,Alias::Path):-
	Exp=..[_,Alias::Path,Right],
	atomic(Right),
	free(Alias,Free),
	%+Bounded
	%memberOf(Alias::Path,Free),
	memberchk(Alias::Path,Free),!.
	%-Bounded

filtering_expression(Exp,Alias::Path):-
	Exp=..[_,Left,Alias::Path],
	atomic(Left),
	free(Alias,Free),
	%+Bounded
	%memberOf(Alias::Path,Free),
	memberchk(Alias::Path,Free),!.
	%-Bounded

correlation_expression(Exp,Alias1::Path1,Alias2::Path2):-
	Exp=..[_,Alias1::Path1,Alias2::Path2],
	free(Alias1,Free1),
	free(Alias2,Free2),
	%+Bounded
        %memberOf(Alias1::Path1,Free1),
        %memberOf(Alias2::Path2,Free2),!.
        memberchk(Alias1::Path1,Free1),
        memberchk(Alias2::Path2,Free2),!.
	%-Bounded


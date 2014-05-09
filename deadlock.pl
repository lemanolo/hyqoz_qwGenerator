%deadlock(Rel,Relations):-
%        Rel=..[_,A,B],
%        R1=..[dependent,A,_],
%        R2=..[dependent,_,B],
%        findall(C,      (member(R1,Relations),member(R2,Relations),
%                         R1=..[dependent,A,C],C\==B,
%                         R2=..[dependent,C,B],C\==A,!
%                        ),RelsInDeadlock),
%        RelsInDeadlock\==[].

%deadlock(Rel,Relations):-
%	Rel=..[_,A,B],
%	findall(C,	(C\==B,C\==A,
%			 (
%			   (depends_on(A,C,Relations), depends_on(C,B,Relations),!)
%			   ;
%			   (depends_on(B,C,Relations), depends_on(C,A,Relations),!)
%			 )
%			),UnhealtyRels),
%	UnhealtyRels\==[].

safe(Rel,Relations):-
	Rel=..[_,A,B],
	difference(Relations,[Rel],Relations2),
%	findall(C,(depends_on(A,C,Relations2), accessible_from(C,B,Relations2),!),[]),
%	findall(C,(depends_on(B,C,Relations2), accessible_from(C,A,Relations2),!),[]).
	findall(C,(depends_on(A,C,Relations2), depends_on(C,B,Relations2),!),[]),
	findall(C,(depends_on(B,C,Relations2), depends_on(C,A,Relations2),!),[]).


safe_relations(Relations,Relations):-
	(
		Relations=[_,_]->true
		;
		Relations=[_]->true
		;
		Relations=[]
	),!.
safe_relations(Relations,NoDeadlockRelations):-
	findall(Rel,(member(Rel,Relations),nl,write('    It\'s safe?: '),write(Rel),(safe(Rel,Relations) -> write('    YES');(write('     NO'),fail))),NoDeadlockRelations).

	

depends_on(A,F,Relations):-
	R=..[dependent,A,F],
	member(R,Relations).

depends_on(A,F2,Relations):-
	R=..[dependent,A,F],
        member(R,Relations),
	depends_on(F,F2,Relations),!.

strict_accessible_from(A,B,Relations):- R=..[dependent,A,B],   memberchk(R,Relations),!.
strict_accessible_from(A,B,Relations):-
	R=..[independent,A,B], memberchk(R,Relations)->!;
	R=..[independent,B,A], memberchk(R,Relations)->!;fail.
strict_accessible_from(A,B,Relations):-
	R=..[concurrent,A,B], memberchk(R,Relations)->!;
	R=..[concurrent,B,A], memberchk(R,Relations)->!;fail.


accessible_from(A,B,Relations):-
	R=..[dependent,A,B],memberchk(R,Relations)->true,!
	;
	R=..[dependent,A,C],member(R,Relations)->true
	;
	accessible_from(C,B,Relations),!.

accessible_from(A,B,Relations):-
	R=..[independent,A,B],memberchk(R,Relations)->true,!
	;
	R=..[independent,B,A],memberchk(R,Relations)->true,!
	;
	R=..[independent,A,C],member(R,Relations)->true
	;
	R=..[independent,C,A],member(R,Relations)->true
	;
	accessible_from(C,B,Relations),!.

accessible_from(A,B,Relations):-
	R=..[concurrent,A,B],memberchk(R,Relations)->true,!
	;
	R=..[concurrent,B,A],memberchk(R,Relations)->true,!
	;
	R=..[concurrent,A,C],member(R,Relations)->true
	;
	R=..[concurrent,C,A],member(R,Relations)->true
	;
	accessible_from(C,B,Relations),!.

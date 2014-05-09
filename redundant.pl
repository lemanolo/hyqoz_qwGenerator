eliminate_redundant_relations2(Relations,NoRedundantRelations):-
	assert_relations(Relations),
       do_eliminate_redundant_relations2,
	findall(Rel,relation(Rel),NoRedundantRelations),
       sort(NoRedundantRelations),
	retractall(relation(_)).


do_eliminate_redundant_relations2:-
	findall(_,(
			relation(Rel_AC),
                     Rel_AC=..[_,A,C],
			relation(Rel_AB),
			Rel_AB\=Rel_AC,
			(
                        Rel_AB=..[_,A,B] -> true ; Rel_AB=..[_,B,A]
                     ),
			relation(Rel_BC),
			Rel_BC\=Rel_AC,
			Rel_BC\=Rel_AB,
                     (
                        Rel_BC=..[_,B,C] ->true ; Rel_BC=..[_,C,B]
                     ),
                     (
                        (Rel_AC=..[concurrent,_,_],  Rel_AB=..[concurrent,_,_],   Rel_BC=..[concurrent,_,_])  ->true; %retract(relation(Rel_AC)); %
                        (Rel_AC=..[concurrent,_,_],  Rel_AB=..[concurrent,_,_],   Rel_BC=..[dependent,_,_])   ->retract(relation(Rel_BC)); %
                        (Rel_AC=..[concurrent,_,_],  Rel_AB=..[concurrent,_,_],   Rel_BC=..[independent,_,_]) ->true; %retract(relation(Rel_AC)); %
                        (Rel_AC=..[concurrent,_,_],  Rel_AB=..[dependent,_,_],    Rel_BC=..[concurrent,_,_])  ->retract(relation(Rel_AB)); %
                        (Rel_AC=..[concurrent,_,_],  Rel_AB=..[dependent,_,_],    Rel_BC=..[dependent,_,_])   ->true; %retract(relation(Rel_AC)); %
                        (Rel_AC=..[concurrent,_,_],  Rel_AB=..[dependent,_,_],    Rel_BC=..[independent,_,_]) ->retract(relation(Rel_AB)); %
                        (Rel_AC=..[concurrent,_,_],  Rel_AB=..[independent,_,_],  Rel_BC=..[concurrent,_,_])  ->true; %retract(relation(Rel_AC)); %
                        (Rel_AC=..[concurrent,_,_],  Rel_AB=..[independent,_,_],  Rel_BC=..[dependent,_,_])   ->retract(relation(Rel_BC)); %
                        (Rel_AC=..[concurrent,_,_],  Rel_AB=..[independent,_,_],  Rel_BC=..[independent,_,_]) ->true; %retract(relation(Rel_AC)); %
                        (Rel_AC=..[dependent,_,_],   Rel_AB=..[concurrent,_,_],   Rel_BC=..[concurrent,_,_])  ->retract(relation(Rel_AC)); %
                        (Rel_AC=..[dependent,_,_],   Rel_AB=..[concurrent,_,_],   Rel_BC=..[dependent,_,_])   ->retract(relation(Rel_AC)); %
                        (Rel_AC=..[dependent,_,_],   Rel_AB=..[concurrent,_,_],   Rel_BC=..[independent,_,_]) ->retract(relation(Rel_AC)); %
                        (Rel_AC=..[dependent,_,_],   Rel_AB=..[dependent,_,_],    Rel_BC=..[concurrent,_,_])  ->retract(relation(Rel_AC)); %
                        (Rel_AC=..[dependent,_,_],   Rel_AB=..[dependent,_,_],    Rel_BC=..[dependent,_,_])   ->retract(relation(Rel_AC)); %
                        (Rel_AC=..[dependent,_,_],   Rel_AB=..[dependent,_,_],    Rel_BC=..[independent,_,_]) ->retract(relation(Rel_AC)); %
                        (Rel_AC=..[dependent,_,_],   Rel_AB=..[independent,_,_],  Rel_BC=..[concurrent,_,_])  ->retract(relation(Rel_AC)); %
                        (Rel_AC=..[dependent,_,_],   Rel_AB=..[independent,_,_],  Rel_BC=..[dependent,_,_])   ->retract(relation(Rel_AC)); %
                        (Rel_AC=..[dependent,_,_],   Rel_AB=..[independent,_,_],  Rel_BC=..[independent,_,_]) ->retract(relation(Rel_AC)); %
                        (Rel_AC=..[independent,_,_], Rel_AB=..[concurrent,_,_],   Rel_BC=..[concurrent,_,_])  ->true; %retract(relation(Rel_BC)); %
                        (Rel_AC=..[independent,_,_], Rel_AB=..[concurrent,_,_],   Rel_BC=..[dependent,_,_])   ->retract(relation(Rel_BC)); %
                        (Rel_AC=..[independent,_,_], Rel_AB=..[concurrent,_,_],   Rel_BC=..[independent,_,_]) ->true; %retract(relation(Rel_AB)); %
                        (Rel_AC=..[independent,_,_], Rel_AB=..[dependent,_,_],    Rel_BC=..[concurrent,_,_])  ->retract(relation(Rel_AB)); %
                        (Rel_AC=..[independent,_,_], Rel_AB=..[dependent,_,_],    Rel_BC=..[dependent,_,_])   ->true; %retract(relation(Rel_AC)); %
                        (Rel_AC=..[independent,_,_], Rel_AB=..[dependent,_,_],    Rel_BC=..[independent,_,_]) ->retract(relation(Rel_AB)); %
                        (Rel_AC=..[independent,_,_], Rel_AB=..[independent,_,_],  Rel_BC=..[concurrent,_,_])  ->true; %retract(relation(Rel_BC)); %
                        (Rel_AC=..[independent,_,_], Rel_AB=..[independent,_,_],  Rel_BC=..[dependent,_,_])   ->retract(relation(Rel_BC)); %
                        (Rel_AC=..[independent,_,_], Rel_AB=..[independent,_,_],  Rel_BC=..[independent,_,_]) ->true %%retract(relation(Rel_AC))
                     )
		),_).


assert_relations([]):-!.
assert_relations([Head|Tail]):-
	nl,write('assertz(relation('),write(Head),write('))'),
	assertz(relation(Head)),
	assert_relations(Tail).

eliminate_redundant_relations(Relations,Relations):-
	(
		Relations=[_,_]->true
		;
		Relations=[_]->true
		;
		Relations=[]
	),!.
	
eliminate_redundant_relations([Head|Tail],NonRedundantRelations):-
	\+redundant(Head,[Head|Tail]),!,
	append(Tail,[Head],Relations),
	eliminate_redundant_relations(Relations,NonRedundantRelations).

eliminate_redundant_relations([Head|Tail],NonRedundantRelations):-
	redundant(Head,[Head|Tail]),!,
	eliminate_redundant_relations(Tail,NonRedundantRelations).

eliminate_redundant_relations(NonRedundantRelations,NonRedundantRelations).


redundant(Rel_AC,Relations):-
	Rel_AC=..[dependent,A,C],
	difference(Relations,[Rel_AC],Reminding),
	findall(Rel_BC,(member(Rel_AB,Reminding),
			(
				Rel_AB=..[dependent,A,B]->true
				;
				Rel_AB=..[independent,A,B]->true
				;
				Rel_AB=..[independent,B,A]->true
				;
				Rel_AB=..[concurrent,A,B]->true
				;
				Rel_AB=..[concurrent,B,A]
			),
			(
				Rel_BC=..[dependent,B,C],memberchk(Rel_BC,Reminding)->true
				;
				Rel_BC=..[independent,B,C],memberchk(Rel_BC,Reminding)->true
				;
				Rel_BC=..[independent,C,B],memberchk(Rel_BC,Reminding)->true
				;
				Rel_BC=..[concurrent,B,C],memberchk(Rel_BC,Reminding)->true
				;
				Rel_BC=..[concurrent,C,B],memberchk(Rel_BC,Reminding)
			),!,	nl,write('\t*Rel_AC: '),write(Rel_AC),
				nl,write('\t Rel_AB: '),write(Rel_AB),
				nl,write('\t Rel_BC: '),write(Rel_BC),nl
		),[_]).

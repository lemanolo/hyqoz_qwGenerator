naive([],[TQW],TQW):-!,stepcounter_oks.

naive(Relations,TQWS,TQW):-
        member(Relation,Relations),
        (
         (safe_generation(safe),\+safe(Relation,Relations),!,fail)
         ;
         (safe_generation(safe),safe(Relation,Relations))
         ;
         (safe_generation(unsafe))
        ),
        Relation=..[RelationType,LDTFId,RDTFId],

        tqw(LDTFId,TQWS,tqw(SubQWL,LDTF)),
        tqw(RDTFId,TQWS,tqw(SubQWR,RDTF)),

        merge_dtfs(LDTF,RDTF,NewDTF),

        difference([tqw(NewQW,NewDTF)|TQWS],[tqw(SubQWL,LDTF),tqw(SubQWR,RDTF)],NewTQWS),

	relations(NewTQWS,NewRelations),
	(
		(memberchk(fail(_,_),NewRelations),stepcounter_fails,!, fail)
		;
		(\+memberchk(fail(_,_),NewRelations),
		 qw_pattern(RelationType,CompositionPattern),
        	 compose_qw(CompositionPattern,SubQWL,SubQWR,NewQW),
		 naive(NewRelations,NewTQWS,TQW))
	).

%%%%%%%%%%%% %%%%%%%%%%%% %%%%%%%%%%%% %%%%%%%%%%%% %%%%%%%%%%%% %%%%%%%%%%%% %%%%%%%%%%%% %%%%%%%%%%%% %%%%%%%%%%%% %%%%%%%%%%%%

naive2([],[TQW],TQW,_):-!,
%DEBUG nl,nl,write('================================================================================================================================'),nl,
stepcounter_oks.

naive2(Relations,TQWS,TQW,Level):-
%SELECTION
	(
        	(next_relation_selection(member) -> member(Relation,Relations)
		;
        	(next_relation_selection(next_rel) -> next_rel(Relations,Relation)
		;
        	(next_relation_selection(next_rel2) -> next_rel2(Relations,TQWS,Relation);fail)))
	),
%SAFETY
%	(
%	 	(safe_generation(safe),\+safe(Relation,Relations),! -> (nl,nl,write('!!!!!!!!!!!!!!!!!!!!!!!!!'),
%                                                                           nl,write('!!UNSAFE RELATION FOUND!!'),write('     ['),write(Relation),write(']'),
%                                                                           nl,write('!!!!!!!!!!!!!!!!!!!!!!!!!'),nl,nl,fail)
%	 	;
%	 	(safe_generation(safe) -> safe(Relation,Relations)
%	 	;
%	 	safe_generation(unsafe)))
%	),

        Relation=..[RelationType,LDTFId,RDTFId],
        (
              memoization(true) -> (clause(mem(Relation),true) -> (  \+clause(id(LDTFId),true) -> fail
                                                                   ; \+clause(id(LDTFId),true) -> fail ; true)
                                                                ; assertz(mem(Relation)))
                                ; true
        ),

        %DEBUG	nl,write('_____________________________________________________'),
        %DEBUG	nl,write('    Relation chosen: '),write(Relation),

        tqw(LDTFId,TQWS,tqw(SubQWL,LDTF)),
        tqw(RDTFId,TQWS,tqw(SubQWR,RDTF)),

        (
	 	merge_dtfs(LDTF,RDTF,NewDTF)-> true
		;
		(stepcounter_fails
              %DEBUG              , write('----->  1 FAIL')
              ,fail)
	),

	NewDTF=..[NewIDDTF|_],
       %DEBUG	nl,write('            New DTF: '),write(NewIDDTF),
        difference([tqw(NewQW,NewDTF)|TQWS],[tqw(SubQWL,LDTF),tqw(SubQWR,RDTF)],NewTQWS),

%RECOMPUTING
	(
		(new_relations_computation(local) ->
		 (
			adjacent_dtfs(Relations, TQWS, Relation, AdjacentFunctions),
		 	findall(Rel,(member(DTF,AdjacentFunctions),relations([DTF,NewDTF],[Rel])),NewAdjacentRelations),
		 	adjacent_rels(Relations, Relation, AdjacentRelations),
		 	difference(Relations,[Relation|AdjacentRelations],NewRelations1),
		 	union(NewRelations1,NewAdjacentRelations,NewRelations)
		 )
		;
		(new_relations_computation(global) -> relations(NewTQWS,NewRelations); true))
	),
%	safe_generation(Safe),
%	safe_relations(Safe,UnsafeRelations,NewRelations),
	(NewRelations\=[] ->
              true
              %DEBUG              ,nl,print_graph(NewRelations)
              ;
              true
              %DEBUG              ,nl,write('Finishing...'),nl,true
        ),
        (
                (memberchk(fail(_,_),NewRelations) -> (stepcounter_fails
                %DEBUG                                                       , write('-----> 2 FAIL')
                                                       ,fail)
                ;
                (
		  (
		  qw_pattern(RelationType,CompositionPattern),
                %DEBUG		  nl,write('Composition pattern: '),write(CompositionPattern),
        	  compose_qw(CompositionPattern,SubQWL,SubQWR,NewQW),
		  Level2 is Level +1,
        	  naive2(NewRelations,NewTQWS,TQW,Level2))))
        ).

%%%%%%%%%%%% %%%%%%%%%%%% %%%%%%%%%%%% %%%%%%%%%%%% %%%%%%%%%%%% %%%%%%%%%%%% %%%%%%%%%%%% %%%%%%%%%%%% %%%%%%%%%%%% %%%%%%%%%%%%

naive3([],[TQW],TQW,Level):-!,
        nl,writeN(Level),write('========================================================================================'),
        stepcounter_oks.

naive3(Relations,TQWS,TQW,Level):-
        nl,writeN(Level),write('----------------------------------------------------------------------------------------'),
        member(Relation,Relations),
        (
         (safe_generation(safe),\+safe(Relation,Relations),!,fail)
         ;
         (safe_generation(safe),safe(Relation,Relations))
         ;
         (safe_generation(unsafe))
        ),
        Relation=..[RelationType,LDTFId,RDTFId],
        nl,writeN(Level),write(Relation),

        tqw(LDTFId,TQWS,tqw(SubQWL,LDTF)),
        tqw(RDTFId,TQWS,tqw(SubQWR,RDTF)),

        merge_dtfs(LDTF,RDTF,NewDTF),

        difference([tqw(NewQW,NewDTF)|TQWS],[tqw(SubQWL,LDTF),tqw(SubQWR,RDTF)],NewTQWS),

        adjacent_dtfs(Relations, TQWS, Relation, AdjacentFunctions),
        findall(Rel,(member(DTF,AdjacentFunctions),relations([DTF,NewDTF],[Rel])),NewAdjacentRelations),
        (
                (memberchk(fail(_,_),NewAdjacentRelations),stepcounter_fails,!, fail)
                ;
                (\+memberchk(fail(_,_),NewAdjacentRelations),
                 qw_pattern(RelationType,CompositionPattern),
                 compose_qw(CompositionPattern,SubQWL,SubQWR,NewQW),
                 adjacent_rels(Relations, Relation, AdjacentRelations),
                 difference(Relations,[Relation|AdjacentRelations],NewRelations1),
                 union(NewRelations1,NewAdjacentRelations,NewRelations),
                 Level2 is Level +1,
                 naive3(NewRelations,NewTQWS,TQW,Level2))
        ).

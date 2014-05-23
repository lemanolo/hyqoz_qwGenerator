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


 %%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%

reduction_algo(Relations,TQWS,TQW):-
	safe_generation(Safe),
        safe_relations(Safe,Relations, NoDeadlockRelations),
        do_reduction_algo(NoDeadlockRelations,TQWS,TQW). 

do_reduction_algo([],[TQW],TQW):-stepcounter_oks.

do_reduction_algo(Relations,TQWS,TQW):-
	Relations\=[],

	member(Relation,Relations),
	%next_rel(Relations,Relation),
	Relation=..[RelationType,LDTFId,RDTFId],
	
	tqw(LDTFId,TQWS,tqw(SubQWL,LDTF)),
	tqw(RDTFId,TQWS,tqw(SubQWR,RDTF)),

	merge_dtfs(LDTF,RDTF,NewDTF),

	qw_pattern(RelationType,CompositionPattern),
	compose_qw(CompositionPattern,SubQWL,SubQWR,NewQW),

	difference([tqw(NewQW,NewDTF)|TQWS],[tqw(SubQWL,LDTF),tqw(SubQWR,RDTF)],NewTQWS),
	relations(NewTQWS,NewRelations),
	safe_generation(Safe),
        safe_relations(Safe,NewRelations, NoDeadlockRelations),
	reduction_algo(NoDeadlockRelations,NewTQWS,TQW).

all_dependent(Relations):-
	length(Relations,N),
	findall(dependent,member(dependent(_,_),Relations),L),
	length(L,N).

reduction_prunned_algo([],[TQW],TQW):-stepcounter_oks.

reduction_prunned_algo(Relations,TQWS,TQW):-
	all_dependent(Relations),!,
        next_rel2(Relations,TQWS,Relation),!,
        do_reduction_prunned_algo(Relation,TQWS,TQW).  

reduction_prunned_algo(Relations,TQWS,TQW):-
        next_rel2(Relations,TQWS,Relation),
	adjacent_dtfs(Relations,TQWS,Relation,AdjRels),
	nl,write('REL: '),write(Relation),
	nl,write('ADJ_DTFS: '),write(AdjRels),
        do_reduction_prunned_algo(Relation,TQWS,TQW).  

do_reduction_prunned_algo(Relation,TQWS,TQW):-

        Relation=..[RelationType,LDTFId,RDTFId],

        tqw(LDTFId,TQWS,tqw(SubQWL,LDTF)),
        tqw(RDTFId,TQWS,tqw(SubQWR,RDTF)),

        merge_dtfs(LDTF,RDTF,NewDTF),

        qw_pattern(RelationType,CompositionPattern),
        compose_qw(CompositionPattern,SubQWL,SubQWR,NewQW),

        difference([tqw(NewQW,NewDTF)|TQWS],[tqw(SubQWL,LDTF),tqw(SubQWR,RDTF)],NewTQWS),
        relations(NewTQWS,NewRelations),
	safe_generation(Safe),
        safe_relations(Safe,NewRelations, NoDeadlockRelations),

        reduction_prunned_algo(NoDeadlockRelations,NewTQWS,TQW).


resetstepcounter_attempts:-retractall(count_attempts(_)),assertz(count_attempts(0)),!.

stepcounter_attempts:-
	clause(count_attempts(Count),true),!,
	CountNew is Count +1,
	retractall(count_attempts(_)),
	assertz(count_attempts(CountNew)).

resetstepcounter_fails:-retractall(count_fails(_)),assertz(count_fails(0)),!.

stepcounter_fails:-
	clause(count_fails(Count),true),!,
	CountNew is Count +1,
	retractall(count_fails(_)),
	assertz(count_fails(CountNew)).

resetstepcounter_oks:-retractall(count_oks(_)),assertz(count_oks(0)),!.
stepcounter_oks:-
	clause(count_oks(Count),true),!,
	CountNew is Count +1,
	retractall(count_oks(_)),
	assertz(count_oks(CountNew)).

tqw(Id,TQWS,tqw(QW,DTF)):-
	member(tqw(QW,DTF),TQWS),
	arg(4,DTF,Id),!.
	
	
adjacent_rels(Relations, Relation, AdjacentRelations):-
	Relation=..[_,IdLDTF,IdRDTF],
	difference(Relations,[Relation],Relations2),
        findall(AdjacentRelation,(member(AdjacentRelation,Relations2),
				   (AdjacentRelation=..[_,IdLDTF,_];
				    AdjacentRelation=..[_,_,IdLDTF];
				    AdjacentRelation=..[_,IdRDTF,_];
				    AdjacentRelation=..[_,_,IdRDTF])
                                 ),
                AdjacentRelations).

adjacent_dtfs(Relations, TQWS, Relation, AdjacentFunctions):-
        Relation=..[_,IdLDTF,IdRDTF],
	difference(Relations,[Relation],Relations2),
	findall(AdjDTF,(member(AdjacentRelation,Relations2),
                           (AdjacentRelation=..[_,IdLDTF,IdAdjDTF];
                            AdjacentRelation=..[_,IdAdjDTF,IdLDTF];
                            AdjacentRelation=..[_,IdRDTF,IdAdjDTF];
                            AdjacentRelation=..[_,IdAdjDTF,IdRDTF]),
			   tqw(IdAdjDTF,TQWS,tqw(_,AdjDTF))
                         ),
        AdjFuncs),
	unique(AdjFuncs,AdjacentFunctions).

next_dtf2(Relations,[tqw(_,DTF)|Tail],NextDTFId):-
	arg(4,DTF,NextDTFId),
	is_dominant(NextDTFId,Relations)
	;
	next_dtf2(Relations,Tail,NextDTFId).

next_dtf2(Relations,[tqw(_,DTF)|_],NextDTFId):-
	arg(4,DTF,NextDTFId),
	\+is_dominant(NextDTFId,Relations),
        findall(Rel,( member(Rel,Relations),
                      Rel=..[RelType|Fs],
		      RelType\==dependent,
                      memberchk(NextDTFId,Fs)
                     ),
                 IndependentRelations),
        IndependentRelations\==[].
%
next_dtf2([Rel|Tail],NextDTFId):-
	Rel=..[dependent,NextDTFId,_],
        is_dominant(NextDTFId,Tail)
        ;
        next_dtf2(Tail,NextDTFId).

next_dtf2([Rel|Tail],NextDTFId):-
	Rel=..[RelType,NextDTFId,_],
	RelType\=dependent,
        \+is_dominant(NextDTFId,[Rel|Tail]),
        findall(R,( member(R,[Rel|Tail]),
                      R=..[RType|Fs],
                      RType\=dependent,
                      memberchk(NextDTFId,Fs)
                     ),
                 IndependentRelations),
        IndependentRelations\==[].
%

next_rel(Relations,dependent(NextDTFId,DTFToMergeId)):-
	select(dependent(NextDTFId,DTFToMergeId),Relations,Reminding),
	is_dominant(NextDTFId,Relations),
	\+memberchk(dependent(_,DTFToMergeId),Reminding).

next_rel(Relations,independent(NextDTFId,DTFToMergeId)):-
	member(independent(NextDTFId,DTFToMergeId),Relations).
next_rel(Relations,concurrent(NextDTFId,DTFToMergeId)):-
	member(concurrent(NextDTFId,DTFToMergeId),Relations).


next_rel2(Relations,[tqw(_,DTF)|Tail],NextRel):-
        arg(4,DTF,NextDTFId),
        is_dominant(NextDTFId,Relations),
	memberchk(dependent(NextDTFId,DTFToMergeId), Relations),
        findall(OtherDTF, (member(dependent(OtherDTF,DTFToMergeId), Relations)), [_]),
	NextRel=dependent(NextDTFId,DTFToMergeId)
        ;
        next_rel2(Relations,Tail,NextRel).

next_rel2(Relations,[tqw(_,DTF)|_],NextRel):-
        arg(4,DTF,NextDTFId),
	memberchk(independent(NextDTFId,DTFToMergeId) ,Relations),
	NextRel=independent(NextDTFId,DTFToMergeId).

next_rel2(Relations,[tqw(_,DTF)|_],NextRel):-
        arg(4,DTF,NextDTFId),
	memberchk(concurrent(NextDTFId,DTFToMergeId) ,Relations),
	NextRel=concurrent(NextDTFId,DTFToMergeId).

is_dominant(Id,Relations):-
        findall(Rel,( member(Rel,Relations),
                      Rel=..[dependent,_,Id]),
                []).

is_dominated(Id,Relations):-
	\+is_dominant(Id,Relations),
        findall(Rel,( member(Rel,Relations),
                      Rel=..[dependent,_,Id]),
                DependentRelations),
         DependentRelations\==[].

is_intermediate(Id,Relations):-
	\+is_dominant(Id,Relations),
	\+is_dominated(Id,Relations).



next_dtf(Relations,NextFunction):- %NextFunction does not depend on another dtf
        findall(Rel,( member(Rel,Relations),
                      Rel=..[dependent,_,NextFunction]),
                DependentRelations),
         DependentRelations=[],!.

next_dtf(Relations,NextFunction):- %NextFuncton has an independent relation with another dtf
        findall(Rel,( member(Rel,Relations),
                      Rel=..[independent|Fs],
                      memberchk(NextFunction,Fs)
                     ),
                 IndependentRelations),
        IndependentRelations\==[],!.

next_dtf(Relations,NextFunction):- %NextFunctions has a concurrent relation with another dtf
        findall(Rel,( member(Rel,Relations),
                      Rel=..[concurrent|Fs],
                      memberchk(NextFunction,Fs)
                     ),
                 ConcurrentRelations),
        ConcurrentRelations\==[],!.

choose_next_dtf_to_merge(Function,Relations,Relation,FunctionToMerge):-
        Relation=..[dependent,Function,FunctionToMerge],
        findall(OtherRel,( member(OtherRel,Relations),
                           OtherRel=..[dependent,OtherFunction,FunctionToMerge],
                           OtherFunction\==Function),
                OtherDependentRelations),
        OtherDependentRelations=[].

choose_next_dtf_to_merge(Function,_,Relation,FunctionToMerge):-
        Relation=..[concurrent,Function,FunctionToMerge].

choose_next_dtf_to_merge(Function,_,Relation,FunctionToMerge):-
        Relation=..[independent,Function,FunctionToMerge].


make_equation(Relation,EQ):-
	Relation=..[RelationType,LeftEQ,RightEQ],
	%+Result
	%arg(7,LeftF,LeftEQ),
	%arg(7,RightF,RightEQ),
	%arg(5,LeftF,LeftEQ),
	%arg(5,RightF,RightEQ),
	%-Result
	((RelationType=dependent,  !, Op=('>>'), concat_all_atoms([LeftEQ,' ',Op,' ',RightEQ],EQ));
         (RelationType=concurrent, !, Op=('><'), concat_all_atoms(['(',LeftEQ,' ',Op,' ',RightEQ,')'],EQ));
         (RelationType=independent,!, Op=('||'), concat_all_atoms(['(',LeftEQ,' ',Op,' ',RightEQ,')'],EQ))
        ).



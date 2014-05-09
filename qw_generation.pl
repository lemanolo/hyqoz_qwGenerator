%QW GENERATION BY RELATIONS COMBINATIONS

%Functor called by the main directive (e.g., test/2)
%[diapo 'QW Generation algorithm']
%PARAMETERS
%[+]Relations: List of relations
%[+]Functions: List of functions
%[?]Function: resulting function of the form 
%               function(id,
%                        Aliases,
%                        Expression,
%                        Projection,
%                        QW) // This is not part of the function definition but is used to
%                            //carry the query workflow composition through the function reduction
%
%DESCRIPTION:
% The generate_qw_by_Relations(Relations,Functions,Function) succeds if the Function is a 
%reduction of the functions of Functions which relations among them are Relations
generate_qw_by_GraphReduction(Relations,TQWS,TQW):-
%+Presentation purposes
%displ%           	nl,write('&&& Original graph     &&&'),
%displ%           	print_matrix_of_relations(Relations,2),
%-Presentation purposes
%
	safe_generation(Safe),
	safe_relations(Safe,Relations, NoDeadlockRelations),
%+Presentation purposes
%displ%           	nl,write('&&& No-deadlock graph  &&&'),
%displ%           	print_matrix_of_relations(NoDeadlockRelations,2),
%displ%           	nl,write('   ITERATION: '),
%displ%           	findall(_,(nth(_,NoDeadlockRelations,Rel)
%displ%           	           ,print_relation_short(Rel,Output),
%displ%           	            write(Output),write(', ')
%displ%           	          ),_),
%-Presentation purposes
        do_generate_qw_by_GraphReduction(NoDeadlockRelations,TQWS,TQW,1). %this is the core of the algo [diapo 'QW generation by graph reduction']

%Functor called by generate_qw_by_Relations/3
%[diapo 'QW Generation algorithm']
%PARAMETERS
%[+]Relations: cf. generate_qw_by_Relations/3
%[+]Functions: cf. generate_qw_by_Relations/3
%[?]Function: cf. generate_qw_by_Relations/3
%[+]Level: integer with the level of the reduction. Just for presentation purposes
%
%DESCRIPTION: This is the core of the generation algorithm cf.generate_qw_by_Relations/3
do_generate_qw_by_GraphReduction(_,[TQW],TQW,_):- %base case: if there is only one function in the Functions thus it has finished
	stepcounter_oks.

do_generate_qw_by_GraphReduction(Relations,TQWS,TQW,Iteration):-
        length(TQWS,L), L>1,
%	((Iteration=1,clear_dtf_ids,!)
%	 ;
%	 true),

	%+Presentation purposes
        %disp% nl,write('============================================ ITERATION: '),write(Iteration),
	%-Presentation purposes

%+nextdtf
%member(NextTQW,TQWS),
%tqw(NextDTFId,TQWS,NextTQW),
%next_dtf(Relations,NextDTFId),
%NextTQW=tqw(QW1,NextDTF),
%
%member(Relation,Relations),
%choose_next_dtf_to_merge(NextDTFId,Relations,Relation,DTFToMergeId),
%tqw(DTFToMergeId,TQWS,TQWToMerge),
%TQWToMerge=tqw(QW2,DTFToMerge),
%Relation=..[RelationType|_],
%-nextdtf

%+nextdtf2
%next_dtf2(Relations,TQWS,NextDTFId),
%tqw(NextDTFId,TQWS,NextTQW),
%NextTQW=tqw(QW1,NextDTF),
%
%member(Relation,Relations),
%choose_next_dtf_to_merge(NextDTFId,Relations,Relation,DTFToMergeId),
%tqw(DTFToMergeId,TQWS,TQWToMerge),
%TQWToMerge=tqw(QW2,DTFToMerge),
%Relation=..[RelationType|_],
%-nextdtf2

	%+Presentation purposes
        %disp%   	nl,write('     NEXT FUNCTION: '),print_function_short(NextFunction),
	%-Presentation purposes

%+next_rel
%nl,write(Relations),nl,
%next_rel(Relations,Relation),
%Relation=..[RelationType,NextDTFId,DTFToMergeId],
%tqw(NextDTFId,TQWS,NextTQW),
%NextTQW=tqw(QW1,NextDTF),
%tqw(DTFToMergeId,TQWS,TQWToMerge),
%TQWToMerge=tqw(QW2,DTFToMerge),
%-next_rel

%+next_rel2
next_rel2(Relations,TQWS,Relation),
Relation=..[RelationType,NextDTFId,DTFToMergeId],
tqw(NextDTFId,TQWS,NextTQW),
NextTQW=tqw(QW1,NextDTF),
tqw(DTFToMergeId,TQWS,TQWToMerge),
TQWToMerge=tqw(QW2,DTFToMerge),
%-next_rel2

	%+Presentation purposes
        %disp%   	nl,write('FUNTCTION TO MERGE: '),print_function_short(DTFToMergeId),
        %disp%   	nl,write('             GRAPH: '),
        %disp%   	print_matrix_of_relations(Relations,2),nl,
	%-Presentation purposes
	merge_dtfs(NextDTF,DTFToMerge,NewDTF),
	
	%+Result
        %arg(6,NewFunction,SubQW), %  gets SubQW variable. When the NewFunction is created SubQW is
	%-Result

        qw_pattern(RelationType,CompositionPattern), %  chose a composition pattern according with the
                                             %RelationType [diapo 'Composition patterns', 'QW Generation algorithm']
        compose_qw(CompositionPattern,QW1,QW2,NewQW), %  The subquery workflows of F1 and F2 are joined to
                                                 %the composition pattern. Thus the NewQW is bounded with the new QW
	%+Result
	%arg(7,NewFunction,EQ),
%arg(5,NewFunction,EQ),
	%-Result
%make_equation(Relation,EQ),

	%+Presentation purposes
        %disp%   	nl,write('          EQUATION: '),write(EQ),
        %disp%   	nl,write('      NEW FUNCTION: '),print_function_short(NewFunction),write('='),print_relation_short(Relation,RelationShort),write(RelationShort),
        %disp%   	nl,write('                QW: '),write(SubQW),
	%-Presentation purposes

%+Adjacent Relations
	adjacent_rels(Relations, Relation, AdjacentRelations),

	%+Presentation purposes
        %disp%   	nl,write('     ADJACENT RELS: '),
        %disp%   	findall(_,(member(AR,AdjacentRelations), nl,write('\t\t'),print_relation_short(AR)),_),
	%-Presentation purposes
%-Adjacent Relations
	
%+Adjacent Functions
	adjacent_dtfs(Relations, TQWS, Relation, AdjacentDTFS),
	%+Presentation purposes
        %disp%   	nl,write('     ADJACENT FUNS: '),
        %disp%   	findall(_,(member(AF,AdjacentFunctions), print_function_short(AF),write(', ')),_),
	%-Presentation purposes
%-Adjacent Functions
	
%+Compute the relations of the NewFunction with each AdjacentFunction
        findall(NewRel,( member(OtherDTF,AdjacentDTFS), %for each reminding function, the relations with the NewFunction are calculated
                         relations([NewDTF,OtherDTF],[NewRel]),
                         \+NewRel=..[fail|_]        %if the resulted relation has a type 'fail' thus there is an anomaly
                    ),
		RelationsWithNewDTF),
	
	length(AdjacentDTFS,N),
	length(RelationsWithNewDTF,N),
	%+Presentation purposes
        %disp%   	nl,write('     NEW RELATIONS: '), print_matrix_of_relations(RelationsWithNewFunction,2),nl,
	%-Presentation purposes
%-Compute the relations of the NewFunction with each AdjacentFunction

%+New Functions and Relations sets
	difference([tqw(NewQW,NewDTF)|TQWS],[NextTQW,TQWToMerge],NewTQWS),
	%+Presentation purposes
        %disp%   	nl,write('   NEW FUNCTION SET: '),
        %disp%   	findall(_,(member(F,NewFunctionsSet), print_function_short(F), write(',')),_),
	%-Presentation purposes

	append(Relations,RelationsWithNewDTF,AllRelations),
	difference(AllRelations,[Relation|AdjacentRelations],NewRelationsSet),
	%+Presentation purposes
        %disp%   	nl,write('          NEW GRAPH: '), print_matrix_of_relations(NewRelationsSet,2),nl,
	%-Presentation purposes

%-New Functions and Relations sets
	Iteration2 is Iteration+1,
%
	safe_generation(Safe),
	safe_relations(Safe,NewRelationsSet,NoDeadlockRelations),
%
	do_generate_qw_by_GraphReduction(NoDeadlockRelations,NewTQWS,TQW,Iteration2).

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


%next_rel(Relations,dependent(NextDTFId,DTFToMergeId)):-
%	memberchk(dependent(NextDTFId,DTFToMergeId),Relations),
%	\+is_dominant(NextDTFId,Relations),
%       	findall(OtherDTF, (member(dependent(OtherDTF,DTFToMergeId),Relations),OtherDTF\=NextDTFId,!), []).

%	member(Rel,Relations),
%	(
%	Rel=..[concurrent,NextDTFId,DTFToMergeId]->true
% 	;
%	Rel=..[independent,NextDTFId,DTFToMergeId]
%	).
%	findall(OtherDTF, (member(dependent(OtherDTF,DTF), (DTF=NextDTFId;DTF=DTFToMergeId)),Relations), []).



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



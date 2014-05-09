clear_memoization:- retractall(mem(_)).

%Function merge(f_a,fa_b)->f_ab [diapo 'Merging Functions']
merge_dtfs(F1,F2,Function):-!,
	arg(1,F1,Aliases1), arg(2,F1,Expression1), arg(3,F1,Projection1), arg(4,F1,Id1),
	arg(1,F2,Aliases2), arg(2,F2,Expression2), arg(3,F2,Projection2), arg(4,F2,Id2),
	unionAll([Aliases1,Aliases2],NAliases),
	unionAll([Expression1,Expression2],NExpression),
	intersection(Aliases1,Aliases2,IAliases),
	intersection(Projection1,Projection2,IProjection),
	findall(Alias::Path,(member(Alias::Path,IProjection),memberchk(Alias,IAliases)),CommonProjections),
	unionAll([Projection1,Projection2],UProjection),
	symmetric_difference(Aliases1,Aliases2,UncommonAliases),
	findall(Alias::Path,(member(Alias::Path,UProjection),memberchk(Alias,UncommonAliases)),OtherProjections),
	unionAll([CommonProjections,OtherProjections],NProjection),
	%Result findall(Type,(member(Alias,NAliases),type(Alias,Type)),Types),
	%Result merge(Types,NType),
	%Result (
	%Result 	(list(NType),!,NTypeList=NType)
	%Result 	;
	%Result 	(\+list(NType),NTypeList=[NType])
	%Result ),
 	%Result findall(NT,(member(Alias::Type,NTypeList),
	%Result         findall(Alias::Path,member(Alias::Path,NProjection),SubProjection),
	%Result         newType(SubProjection,Alias::Type,NT),
	%Result         NT\==[]
	%Result         ),NewType),
%Function=..[dtf,NAliases,NExpression,NProjection],!.
       (
                     atom_concat(Id1,Id2,NewId),
                     Function=..[dtf|[NAliases,NExpression,NProjection,NewId]]
       %              memoization(true) -> atom_concat(Id1,Id2,NewId),
       %                            assertz(mem(Id1,Id2))
       %                         ;
       %                           create_dtf(dtf,NAliases,NExpression,NProjection,Function)
       ),!.


merge_all_dtfs(DTFS,NewDTF):-
	do_merge_all_dtfs(DTFS,DTF_R),
	DTF_R=..[Id,A|Tail],
	findall((DS_OP as Alias),(member(Alias,A),type_name(Alias,DS_OP)),NewA),
	NewDTF=..[Id,NewA|Tail].

do_merge_all_dtfs([DTF_R],DTF_R):-!.
do_merge_all_dtfs([DTF1,DTF2|Tail],DTF_R):-
	merge_dtfs(DTF1,DTF2,DTF),
	do_merge_all_dtfs([DTF|Tail],DTF_R).


test_normal(Suffix):- test_normal(Suffix,true).
test_normal(Suffix,PerResult):-
	set_output(user_output),
	atom_concat(sco,Suffix,Query),
	functor(Functor,Query,1),
	arg(1,Functor,SCO),
	call(Functor),
	clear_dtf_ids,
	clear_memoization,
	clear_types(_),

	derive(SCO,DTFS),

	relations(DTFS,Relations),
	QWSTREAM_REL=user_output,

	
	execute_generation_by_GraphReduction(Relations,DTFS,Suffix,PerResult,QWSTREAM_REL),

	count_attempts(Attempts),     nl(QWSTREAM_REL),write(QWSTREAM_REL,'stats Attempts: '),write(QWSTREAM_REL,Attempts),
	count_oks(Oks),                      write(QWSTREAM_REL,'\tOks: '),write(QWSTREAM_REL,Oks),
	count_fails(Fails),                  write(QWSTREAM_REL,'\tFails: '),write(QWSTREAM_REL,Fails),
	                    nl,write('stats Attempts: '),write(Attempts),
	                       write('\tOks: '),write(Oks),
	                       write('\tFails: '),write(Fails),
	close(QWSTREAM_REL),
	set_output(user_output),
	nl,write('-------------------------------------------------------------------').


generate_ss_for_sco(PerResult):-
       sco(SCO),!,
       generate_ss_for_sco(sco(SCO),PerResult).

generate_ss_for_sco(SCO,PerResult):-
        clear_dtf_ids,
	 clear_memoization,
        clear_types(_),
        derive(SCO,DTFS), %Derive the dt-functions from the SCO expression
        generate_ss_for_dtfs(DTFS,PerResult).

generate_ss_for_dtfs(PerResult):-
       clear_dtf_ids,
       clear_memoization,
       clear_types(_),
       dtypes(TYPES), %Retrieve the list of data types type_name(Alias,Service::Method) defining the aliases of service methods
       findall(_,(member(type_name(Alias,Service::Method), TYPES),assertz(type_name(Alias,Service::Method))),_),
       dtfs(DTFS),!, %Retrieve the list of dt-functions from the fact dtfs/1 asserted in config.pl
	generate_ss_for_dtfs(DTFS,PerResult).

generate_ss_for_dtfs(DTFS,PerResult):-
       findall(tqw(QW,DTF),(member(DTF,DTFS),arg(4,DTF,IdDTF),create_uqw(IdDTF,QW)),TQWS),
       relations(DTFS,Relations),
%+OUTPUT FILE
       ( outputFileName(OutputFileName),OutputFileName\=none -> (outputFileName(OutputFileName),open(OutputFileName, write, QWSTREAM_REL))
			                                         ; (QWSTREAM_REL=user_output)
       ),
%-OUTPUT FILE

%clear_dtf_ids,
%       clear_memoization,
       resetstepcounter_attempts,resetstepcounter_oks,resetstepcounter_fails,
%+EXHAUSTIVE QW GENERATION
	(algorithm(byGraph)            -> execute_generation_by_GraphReduction(Relations,TQWS, PerResult,QWSTREAM_REL);
	(algorithm(byReductionPrunned) ->      executon_reduction_prunned_algo(Relations,TQWS, PerResult,QWSTREAM_REL);
	(algorithm(byReduction)        ->             execution_reduction_algo(Relations,TQWS, PerResult,QWSTREAM_REL);
	(algorithm(naive)              ->                      execution_naive(Relations,TQWS, PerResult,QWSTREAM_REL);
	(algorithm(naive2)             ->                     execution_naive2(Relations,TQWS, PerResult,QWSTREAM_REL); true))))),
%-EXHAUSTIVE QW GENERATION

%+OUTPUT
	count_attempts(Attempts),     nl(QWSTREAM_REL),write(QWSTREAM_REL,'stats Attempts: '),write(QWSTREAM_REL,Attempts),
	count_oks(Oks),                      write(QWSTREAM_REL,'\tOks: '),write(QWSTREAM_REL,Oks),
	count_fails(Fails),                  write(QWSTREAM_REL,'\tFails: '),write(QWSTREAM_REL,Fails),
	                    nl,write('stats Attempts: '),write(Attempts),
	                       write('\tOks: '),write(Oks),
	                       write('\tFails: '),write(Fails),
	close(QWSTREAM_REL),
	set_output(user_output),
	nl,write('GRA QW Sink: '),write(OutputFileName),
       %-OUTPUT
	nl,write('-------------------------------------------------------------------').

generate_qws_from_java:-
%+INITIALIZATION
       clear_dtf_ids,
       clear_memoization,
       clear_types(_),
       dtypes(TYPES), %Retrieve the list of data types type_name(Alias,Service::Method) defining the aliases of service methods
       findall(_,(member(type_name(Alias,Service::Method), TYPES),assertz(type_name(Alias,Service::Method))),_),
       dtfs(DTFS),    %Retrieve the list of dt-functions from the fact dtfs/1 asserted in config.pl
       findall(tqw(QW,DTF),(member(DTF,DTFS),arg(4,DTF,IdDTF),create_uqw(IdDTF,QW)),TQWS),

       findall(activity(IDActivity,DTF),(member(DTF,DTFS),arg(4,DTF,IDActivity)),ACTIVITIES),
       sort(ACTIVITIES),
%-INITIALIZATION

       relations(DTFS,UnsafeRelations),

%+SAFE RELATIONS
	(
        	safe_generation(safe)
		-> safe_relations(UnsafeRelations,RedundantRelations)
              %DEBUG                 ,nl,write('SAFE matrix:'),nl
		; RedundantRelations=UnsafeRelations
              %DEBUG                ,nl,write('UNSAFE matrix:'),nl
	),
       %DEBUG        print_graph(RedundantRelations),
%-SAFE RELATIONS

%	findall(_,(member(dependent(A,B),RedundantRelations),redundant(dependent(A,B),RedundantRelations)),_), nl,

%+REDUNDANT RELATIONS
	(
		no_redundant_relations(true)
		->eliminate_redundant_relations2(RedundantRelations,Relations)
              %DEBUG	  	  ,nl,write('NO redundant matrix:'),nl
		; Relations=RedundantRelations
              %DEBUG		  ,nl,write('REDUNDANT matrix:'),nl
	),
       %DEBUG       	print_graph(Relations),
%-REDUNDANT RELATIONS

%+OUTPUT FILE
       ( outputFileName(OutputFileName),OutputFileName\=none -> (outputFileName(OutputFileName),open(OutputFileName, write, QWSTREAM_REL))
			                                         ; (QWSTREAM_REL=user_output)
       ),
	set_output(QWSTREAM_REL),
%-OUTPUT FILE

%+EXHAUSTIVE GENERATION
       resetstepcounter_attempts,resetstepcounter_oks,resetstepcounter_fails,
       naive2(Relations,TQWS,tqw(QW,DTF),0),
       QW=qw(A,P,V,E,in,out,COST),
       (
             flow(df)-> is_dataflow(E)
                      ; true
       ),
       sort(A),
       sort(P),
       sort(V),
       sort(E),
       nl,write('QW = '),write(qw(A,P,V,E,in,out,COST)),
       nl,write('DTYPES = '),write(TYPES),
       nl,write('ACTIVITIES = '),write(ACTIVITIES),
       fail.
%-EXHAUSTIVE GENERATION


generate_qws_from_java:-!.


execute_generation_by_Relations(UnsafeRels,DTFS,PerResult,QWSTREAM_REL):-
	(
		safe_generation(safe)
		-> safe_relations(UnsafeRels,Relations)
		;  Relations=UnsafeRels
	),
	print_matrix_of_relations(Relations),
	findall(D,(member(D,DTFS),
		   findall(F,(member(R,Relations),R=dependent(D,F)),[])),
		Dominated),
	nl,write('========== '),write(Dominated),
	generate_qw_by_Relations(Relations,DTFS,FinalFunctionF),
	%+Result
        %arg(6,FinalFunctionF,QW),
	%arg(7,FinalFunctionF,EQ),
        arg(4,FinalFunctionF,QW),
	arg(4,FinalFunctionF,EQ),
	%-Result
	arg(4,QW,E),
%disp% nl(QWSTREAM_REL),write(QWSTREAM_REL,'--------------------------------------------------------------------------'),dd
       nl(QWSTREAM_REL),write(QWSTREAM_REL,' R Final F: '),write(QWSTREAM_REL,FinalFunctionF),
       nl(QWSTREAM_REL),write(QWSTREAM_REL,' R Final Eq: '),write(QWSTREAM_REL,EQ), write(QWSTREAM_REL,' -> '),write(QWSTREAM_REL,QW),
       nl(QWSTREAM_REL),write(QWSTREAM_REL,' R Final E: '),write(QWSTREAM_REL,E), 
        %disp% nl(QWSTREAM_REL),write(QWSTREAM_REL,Suffix),write(QWSTREAM_REL,' G Final Q: '),write(QWSTREAM_REL,QW),write(QWSTREAM_REL,' <-- '),write(QWSTREAM_REL,EQ),	
	(PerResult=true) %IF IT IS REQUIRED TO SEE THE RESULTS EACH BY EACH
	;
	(PerResult=false,fail). %FOR EXHAUSTIVITY PURPOSES

execute_generation_by_Relations(_,_,_,_,_):-!.

execution_naive(Relations,TQWS,PerResult,QWSTREAM_REL):-
	nl,write('unsafe matrix:'),nl,
	%print_matrix_of_relations(UnsafeRelations),
        %safe_generation(Safe),
        %safe_relations(Safe,UnsafeRelations,Relations),
	%nl,write('safe matrix:'),nl,
	print_graph(Relations),

	naive(Relations,TQWS,tqw(QW,DTF)),
        QW=qw(_,_,_,E,_,_,Cost),
        nl(QWSTREAM_REL),write(QWSTREAM_REL,' G Final     F: '),write(QWSTREAM_REL,DTF),
        nl(QWSTREAM_REL),write(QWSTREAM_REL,' G Final E: '),write(QWSTREAM_REL,Cost),write(QWSTREAM_REL,'     '),write(QWSTREAM_REL,E),

	(PerResult=true) %IF IT IS REQUIRED TO SEE THE RESULTS EACH BY EACH
        ;
        (PerResult=false,fail). %FOR EXHAUSTIVITY PURPOSES

execution_naive(_,_,_,false,_):-!.

execution_naive2(UnsafeRelations,TQWS,PerResult,QWSTREAM_REL):-
       %DEBUG        nl,write('ORIGINAL matrix:'),nl,
       %DEBUG        print_graph(UnsafeRelations),
       %DEBUG        nl,write('safe matrix:'),nl,

	(
        	safe_generation(safe)
		-> safe_relations(UnsafeRelations,RedundantRelations)
              %DEBUG                 ,nl,write('SAFE matrix:'),nl
		; RedundantRelations=UnsafeRelations
              %DEBUG                ,nl,write('UNSAFE matrix:'),nl
	),
       %DEBUG        print_graph(RedundantRelations),

	findall(_,(member(dependent(A,B),RedundantRelations),redundant(dependent(A,B),RedundantRelations)),_), nl,

	(
		no_redundant_relations(true)
		->eliminate_redundant_relations2(RedundantRelations,Relations)
              %DEBUG	  	  ,nl,write('NO redundant matrix:'),nl
		; Relations=RedundantRelations
              %DEBUG		  ,nl,write('REDUNDANT matrix:'),nl
	),
       %DEBUG       	print_graph(Relations),


        naive2(Relations,TQWS,tqw(QW,DTF),0),
        QW=qw(_,_,_,E,_,_,Cost),
        (
              flow(df)-> is_dataflow(E)
                       ; true
        ),
        nl(QWSTREAM_REL),write(QWSTREAM_REL,'  G Final F: '),write(QWSTREAM_REL,DTF),
        nl(QWSTREAM_REL),write(QWSTREAM_REL,'  G Final E: '),write(QWSTREAM_REL,Cost),write(QWSTREAM_REL,'     '),write(QWSTREAM_REL,E),
        %clear_memoization,

        (PerResult=true) %IF IT IS REQUIRED TO SEE THE RESULTS EACH BY EACH
        ;
        (PerResult=false,fail). %FOR EXHAUSTIVITY PURPOSES

execution_naive2(_,_,false,_):-!.
%        findall(IDF,id(IDF),ALLIDS), length(ALLIDS,LengthALLIDS), nl,write('LengthALLIDS: '),write(LengthALLIDS),
%        findall(mem(ID1,ID2),mem(ID1,ID2),MEMOIZATION), length(MEMOIZATION,LengthMEMOIZATION), nl,write('LengthMEMOIZATION: '),write(LengthMEMOIZATION),!.

execution_reduction_algo(UnsafeRels,TQWS,PerResult,QWSTREAM_REL):-
	nl,write('ORIGINAL matrix:'),nl,
	print_matrix_of_relations(UnsafeRels),
	(
		safe_generation(safe)
		-> safe_relations(UnsafeRels,Relations),nl,write('SAFE matrix:'),nl
		;  Relations=UnsafeRels,nl,write('UNSAFE matrix:'),nl
	),
	print_matrix_of_relations(Relations),
	print_graph(Relations),

	reduction_algo(Relations,TQWS,tqw(QW,DTF)),
	QW=qw(_,_,_,E,_,_,Cost),
       	nl(QWSTREAM_REL),write(QWSTREAM_REL,' G Final F: '),write(QWSTREAM_REL,DTF),
	nl(QWSTREAM_REL),write(QWSTREAM_REL,' G Final E: '),write(QWSTREAM_REL,Cost),write(QWSTREAM_REL,'     '),write(QWSTREAM_REL,E),
	%+Result
        %arg(6,FinalFunctionF,QWF),
        %arg(7,FinalFunctionF,EQ),
	%-Result
       %disp% nl(QWSTREAM_REL),write(QWSTREAM_REL,'--------------------------------------------------------------------------'),
	%disp% nl(QWSTREAM_REL),write(QWSTREAM_REL,Suffix),write(QWSTREAM_REL,' G Final Q: '),write(QWSTREAM_REL,QW),write(QWSTREAM_REL,' <-- '),write(QWSTREAM_REL,EQ),
	%assertz(eq_to_qw(EQ,QWF)),
	%nl,write(Suffix),write(' G Query Workflow:  '),sort(QWF),write(QWF),
	(PerResult=true) %IF IT IS REQUIRED TO SEE THE RESULTS EACH BY EACH
	;
	(PerResult=false,fail). %FOR EXHAUSTIVITY PURPOSES

execution_reduction_algo(_,_,_,false,_):-!.

executon_reduction_prunned_algo(UnsafeRels,TQWS,PerResult,QWSTREAM_REL):-
        nl,write('ORIGINAL matrix:'),nl,
        print_matrix_of_relations(UnsafeRels),
	(
		safe_generation(safe)
		-> safe_relations(UnsafeRels,Relations),nl,write('SAFE matrix:'),nl
		;  Relations=UnsafeRels,nl,write('UNSAFE matrix:'),nl
	),
        print_matrix_of_relations(Relations),
        print_graph(Relations),

        reduction_prunned_algo(Relations,TQWS,tqw(QW,DTF)),
        QW=qw(_,_,_,E,_,_,Cost),
        %+Result
        %arg(6,FinalFunctionF,QWF),
        %arg(7,FinalFunctionF,EQ),
        %-Result
       %disp% nl(QWSTREAM_REL),write(QWSTREAM_REL,'--------------------------------------------------------------------------'),
       nl(QWSTREAM_REL),write(QWSTREAM_REL,' G Final F: '),write(QWSTREAM_REL,DTF),
       nl(QWSTREAM_REL),write(QWSTREAM_REL,' G Final E: '),write(QWSTREAM_REL,Cost),write(QWSTREAM_REL,'     '),write(QWSTREAM_REL,E),
        %disp% nl(QWSTREAM_REL),write(QWSTREAM_REL,Suffix),write(QWSTREAM_REL,' G Final Q: '),write(QWSTREAM_REL,QW),write(QWSTREAM_REL,' <-- '),write(QWSTREAM_REL,EQ),
        %assertz(eq_to_qw(EQ,QWF)),
        %nl,write(Suffix),write(' G Query Workflow:  '),sort(QWF),write(QWF),
        (PerResult=true) %IF IT IS REQUIRED TO SEE THE RESULTS EACH BY EACH
        ;
        (PerResult=false,fail). %FOR EXHAUSTIVITY PURPOSES

executon_reduction_prunned_algo(_,_,_,false,_):-!.

execute_generation_by_GraphReduction(UnsafeRels,TQWS,PerResult,QWSTREAM_REL):-
	nl,write('ORIGINAL matrix:'),nl,
	print_matrix_of_relations(UnsafeRels),
	(
		safe_generation(safe)
		-> safe_relations(UnsafeRels,SafeRelations),nl,write('SAFE matrix:'),nl
		;  SafeRelations=UnsafeRels,nl,write('UNSAFE matrix:'),nl
	),
	print_matrix_of_relations(SafeRelations),
	print_graph(SafeRelations),
	generate_qw_by_GraphReduction(SafeRelations,TQWS,tqw(QW,DTF)),

	QW=qw(_,_,_,E,_,_,Cost),
       %disp% nl(QWSTREAM_REL),write(QWSTREAM_REL,'--------------------------------------------------------------------------'),
       	nl(QWSTREAM_REL),write(QWSTREAM_REL,' G Final F: '),write(QWSTREAM_REL,DTF),
       	nl(QWSTREAM_REL),write(QWSTREAM_REL,' G Final E: '),write(QWSTREAM_REL,Cost),write(QWSTREAM_REL,'     '),write(QWSTREAM_REL,E),
	%disp% nl(QWSTREAM_REL),write(QWSTREAM_REL,Suffix),write(QWSTREAM_REL,' G Final Q: '),write(QWSTREAM_REL,QW),write(QWSTREAM_REL,' <-- '),write(QWSTREAM_REL,EQ),
	%assertz(eq_to_qw(EQ,QWF)),
	%nl,write(Suffix),write(' G Query Workflow:  '),sort(QWF),write(QWF),
	(PerResult=true) %IF IT IS REQUIRED TO SEE THE RESULTS EACH BY EACH
	;
	(PerResult=false,fail). %FOR EXHAUSTIVITY PURPOSES

execute_generation_by_GraphReduction(_,_,_,false,_):-!.



qw_generation(HSQL,V,E,in,out):-
        arg(1,HSQL,FROM),
        arg(2,HSQL,WHERE),
        arg(3,HSQL,SELECT),	
	%+FUNCTIONS DERIVATION
        rename(FROM),
        retrieval(WHERE,AR),
        binding(WHERE,AB),
        projection(SELECT,AP),
        filtering(WHERE,AF),
        correlation(WHERE,AC),
        unionAll([AR,AB,AP,AF,AC],Functions),
	%-FUNCTIONS DERIVATION
	relations(Functions,Relations),
	generate_qw_by_GraphReduction(Relations,Functions,FinalFunctionF),
	arg(6,FinalFunctionF,E),
	findall(FunId,(member(Fun,Functions),arg(1,Fun,FunId)),V),
	sort(V).

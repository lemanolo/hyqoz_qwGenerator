rename([]):-!.
rename([_::_|Tail]):-!, %the api already exists
	rename(Tail).
rename([S::M as Alias| Tail]):-
	%+Dataset
	%api(S::M,Bounded,Free,SType),!,
	%assertz(dataset(Alias,Bounded,Free,SType)),
	api(S::M,_,_,_),!,
	nl,write('assertz(type_name('),write(Alias),write(','),write(S::M),write('))'),
	assertz(type_name(Alias,S::M)),
	%-Dataset
	rename(Tail).


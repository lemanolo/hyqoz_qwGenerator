bounded(Alias,Bounded):-
        type_name(Alias,DSName),
        api(DSName,B,_,_),!,
        dotnot(Alias::B,Bounded).
        
free(Alias,Free):-
        type_name(Alias,DSName),
        api(DSName,_,F,_),!,
        dotnot(Alias::F,Free).

atts(Alias,Atts):-
        bounded(Alias,Bounded),
        free(Alias,Free),
        union(Bounded,Free,Atts).

dotnot(A::Type,[A]):- atom(A), \+list(A),atom(Type), \+list(Type).
dotnot(A,[A]):- atom(A),!.

dotnot(A::List,DotNot):-
        list(List),
        findall(DN,(member(A_i,List),
                    dotnot(A_i,NewA_i),
                    member(DN_Sub_A_i,NewA_i),
                    DN=A::DN_Sub_A_i),
                   DotNot).

clear(Alias):-
	%+Dataset
        %retractall(dataset(Alias,_,_,_)).
        retractall(type_name(Alias,_)).
	%-Dataset

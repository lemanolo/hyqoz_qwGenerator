
is_cyclic(E):-
        findall([X,Y],(member(Edge,E),Edge=..[_|[X,Y]]),AllVertex),
        unionAll(AllVertex,V),
	findall(Vertex,(member(Vertex,V),cycleh(Vertex,E,[Vertex]),!),[Vertex]).
	

cycleh(X,Available,Visited):-  member(a(X,Y),Available),
                               difference(Available,[a(X,Y),a(Y,X)],NewAvailable),
                               (member(Y,Visited) -> !,true;
                                cycleh(Y,NewAvailable,[Y|Visited])).

normalize([],[]):-!.
normalize([a(X,Y)|Tail],[a(X,Y)|NewTail]):-normalize(Tail,NewTail),!.
normalize([e(X,Y)|Tail],[a(X,Y),a(Y,X)|NewTail]):-normalize(Tail,NewTail),!.


normalize_sco(NormalizedEdges):-findall(e(X,Y),correlated_dss(X,Y),Edges),normalize(Edges,NormalizedEdges).

test_cyclic(NonNormilizedE):-
	normalize(NonNormilizedE,E),
        findall(_,(permutation(E,PE),
                   nl,write(PE),write(' '),
                   (is_cyclic(PE) -> write(yes);write(no))
                  ),_).

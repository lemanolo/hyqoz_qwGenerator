:-op(351,xfy,:).

%Atomic as attribute
interpret([A],A:V,V):- atomic(V),!.

%Set or Tuple as attribute
interpret([A],A:V,V):-!.
%interpret([A],A:V,A:V):-!.

%Tuple's attribute
interpret([A|B],A:V,Interpretation):- istuple(V),!,
	firstname(B,A_i),
	memberchk(A_i:V_i,V),
	interpret(B,A_i:V_i,Interpretation).

%Unnamed set's attribute
interpret([],V,V):-!.
interpret([A|B],V,Interpretation):- isset(V),!,
	findall(Inter,(member(A:V_1,V),interpret([A|B],A:V_1,Inter)),Interpretation).

interpret([A|B],A:V,Interpretation):- isset(V),!,
	firstname(B,A_1),
	findall(Inter,(member(A_1:V_1,V),interpret(B,A_1:V_1,Inter)),Interpretation).

firstname([A|_],A).
isset(V):-  list(V),findall(A,  member(A:_,V),All),   unique(All,[_]).
istuple(V):-list(V),findall(A,  member(A:_,V),All), \+unique(All,[_]).

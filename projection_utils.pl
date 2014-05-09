newType([],_,[]):-!.
newType([Path],Type,NewType):-!,
	newType(Path,Type,NewType).

newType([Path1,Path2],Type,NewType):-!,
	newType(Path1,Type,NewType1),
	newType(Path2,Type,NewType2),
	merge(NewType1,NewType2,NewType).

newType([Path1|Tail],Type,NewType):-!,
	newType(Path1,Type,NewType1),
	newType(Tail,Type,NewType2),
	merge(NewType1,NewType2,NewType).

newType(A,A,A):-
	\+list(A),
	\+compound(A),!.

newType(A::B,A::SubType,A::[NewType]):-!,
	newType(B,SubType,NewType).

newType(A::B,Type,A::[NewType]):-
	memberchk(A::SubType,Type),!,
	newType(B,SubType,NewType).

newType(A,Type,A::SubType):-
	atom(A),
	memberchk(A::SubType,Type),!. %A::SubType……… SubType sirve para incluir a todos los subtipos de A en caso de que A sea un tipo complejo
                                      %Si se quiere solo el nombre del tipo complejo hay que cambiar por A::_ 
                                      % y eliminar SubType de la cabeza y solo dejar A (i.e., newType(A,Type,A)

newType(A,Type,A):-
	memberchk(A,Type),!.


merge([],[]):-!.
merge([Head1],Head1):-!.
merge([Head1,Head2],M):-!,
	merge(Head1,Head2,M).
merge([Head1,Head2|Tail],M):-!,
	merge(Head1,Head2,M1),
	merge(Tail,M2),
	merge(M1,M2,M).

merge(A::SubType1, A::SubType2, A::R):-!,
	merge(SubType1,SubType2,R).

merge(A::SubType1, B,[A::SubType1,B]):-
	atom(B),
	A\==B,!.

merge(A, B::SubType2,[A,B::SubType2]):-
	atom(A),
	A\==B,!.

merge(A::SubType1, B::SubType2,B::NewSubType):-
	A\==B,
	memberchk(A::Type,SubType2),!,
	merge(A::SubType1,A::Type,A::R),
	replace(A::_,A::R,SubType2,NewSubType).

merge(A::SubType1, B::SubType2,A::NewSubType):-
	A\==B,
	memberchk(B::Type,SubType1),!,
	merge(B::SubType2,B::Type,B::R),
	replace(B::_,B::R,SubType1,NewSubType).

merge(A::SubType1, B::SubType2,[A::SubType1,B::SubType2]):-
	A\==B,!.
	

merge([],T,T):-!.
merge([Head|Tail],Type2,NewType):-
	list(Type2),!,
	merge(Head,Type2,NewType1),
	merge(Tail,NewType1,NewType).

merge([Head|Tail],Type2,NewType):-
	\+list(Type2),!,
	merge(Head,Type2,NewType1),
	merge(Tail,NewType1,NewType).

merge(A::SubType1, Type2,NewSubType):-
	list(Type2),
	memberchk(A::Type,Type2),!,
	merge(A::SubType1,A::Type,A::R),
	replace(A::_,A::R,Type2,NewSubType).

merge(A, Type2,NewSubType):-
	list(Type2),!,
	union([A],Type2,NewSubType).


%+Bounded
%memberOf(Name,Type):- 
%	atomicMemberOf(Name,Type).
%
%memberOf(Name,Type):-
%	complexMemberOf(Name,Type).
%
%atomicMemberOf(Name,Name):- 
%	atom(Name),
%	\+list(Name).
%
%atomicMemberOf(Name::SubType,Name::ComplexType):-
%	\+list(SubType),
%	atomicMemberOf(SubType,ComplexType).
%
%atomicMemberOf(Name,[Type|_]):-
%	\+list(Name),
%	atomicMemberOf(Name,Type).
%
%atomicMemberOf(Name,[_|Tail]):-
%	\+list(Name),
%	atomicMemberOf(Name,Tail).
%
%
%complexMemberOf(Name,Name::_):-
%	atom(Name).
%
%complexMemberOf(Name::SubType,Name::ComplexType):-
%	\+list(SubType),
%	complexMemberOf(SubType,ComplexType).
%
%complexMemberOf(Name,[Type|_]):-
%	\+list(Name),
%	complexMemberOf(Name,Type).
%
%complexMemberOf(Name,[_|Tail]):-
%	\+list(Name),
%	complexMemberOf(Name,Tail).
%-Bounded

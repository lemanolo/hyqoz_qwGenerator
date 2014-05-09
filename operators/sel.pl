:-op(350,xfy,:).
:-op(360,xfx,==).

select(_,[]):-!.


select([Left:V|_],Filter):-
	atomic(V),
	Filter=..[Op|[Left,Right]],
	Calleable=..[Op|[V,Right]],
	call(Calleable),!.

select([Right:V|_],Filter):-
	atomic(V),
	Filter=..[Op|[Left,Right]],
	Calleable=..[Op|[Left,V]],
	call(Calleable),!.

select([Left:V|_],Filter):-
	list(V),
	Filter=..[Op|[Left:SubParam,Right]],
	NewFilter=..[Op|[SubParam,Right]],
	select(V,NewFilter).

select([Right:V|_],Filter):-
	list(V),
	Filter=..[Op|[Left,Right:SubParam]],
	NewFilter=..[Op|[Left,SubParam]],
	select(V,NewFilter).

select([_|Tail],Filter):-
	select(Tail,Filter),!.


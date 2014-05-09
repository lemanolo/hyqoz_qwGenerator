%EXAMPLES
%project([a:[b:bval, c:cval, d:[e:eval,f:fval]]],[a:c, a:b],Res).
%project([a:[b:bval, c:cval, d:[e:eval,f:fval]]],[a:c, a:b, a:d],Res).
%project([a:[b:bval, c:cval, d:[e:eval,f:fval]]],[a:c, a:b, a:d:f],Res).
%project([a:[b:bval, c:cval, d:[e:eval,f:fval]],z:[y:yval, x:xval]],[a:c, a:b,z],Res).

:-op(350,xfy,':').

project(A:V,ProjExpression,A:V):-
	memberchk(A,ProjExpression).%;
	 %memberchk(A:V,ProjExpression)),!.

project(A:V,ProjExpression,A:NewTupleValue):- list(V),!,
	findall(A_i,member(A:A_i,ProjExpression),SubProjExpression),
	SubProjExpression\==[],
	findall(NTV,(member(Item,V),project(Item,SubProjExpression,NTV)),NewTupleValue).

%project(V,ProjExpression,NewTupleValue):-list(V),!,
%	findall(NTV,(member(Item,V),project(Item,ProjExpression,NTV)),NewTupleValue).
	


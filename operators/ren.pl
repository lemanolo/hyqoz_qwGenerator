%EXAMPLES
%project([a:[b:bval, c:cval, d:[e:rname,f:fval]]],[a:c, a:b],Res).
%project([a:[b:bval, c:cval, d:[e:rname,f:fval]]],[a:c, a:b, a:d],Res).
%project([a:[b:bval, c:cval, d:[e:rname,f:fval]]],[a:c, a:b, a:d:f],Res).
%project([a:[b:bval, c:cval, d:[e:rname,f:fval]],z:[y:yval, x:xval]],[a:c, a:b,z],Res).

:-op(350,xfy,':').
:-op(351,xfx,'::').

%base case
rename(A:V,ProjExpression,A_:V):-atomic(V),!,rname(A,ProjExpression,A_).
%tuple / set
rename(A:V,ProjExpression,A_:NewTupleValue):- list(V),!,
	findall(T::B,(member(A:T::B,ProjExpression)),SubProjExpression),
	SubProjExpression\==[],!,
	rname(A,ProjExpression,A_),
	findall(NTV,(member(Item,V),rename(Item,SubProjExpression,NTV)),NewTupleValue).
%default
rename(A:V,_,A:V):-!.


rname(A,ProjExpression,B):-memberchk(A::B,ProjExpression),!.
rname(A,             _,A):-!.

%rename( profile:[sex:'M', nickname:'Bob', email:'bob@gmail.com', age:40, interests:[stag:[tag:'Art history', score:6.5 ], stag:[tag:'Sports',score:7.5]]],
%        [profile::user],
%        R).

%rename( profile:[sex:'M', nickname:'Bob', email:'bob@gmail.com', age:40, interests:[stag:[tag:'Art history', score:6.5 ], stag:[tag:'Sports',score:7.5]]],
%        [profile:sex::gender],
%        R).

%rename( profile:[sex:'M', nickname:'Bob', email:'bob@gmail.com', age:40, interests:[stag:[tag:'Art history', score:6.5 ], stag:[tag:'Sports',score:7.5]]],
%        [profile:nickname::username],
%        R).

%rename( profile:[sex:'M', nickname:'Bob', email:'bob@gmail.com', age:40, interests:[stag:[tag:'Art history', score:6.5 ], stag:[tag:'Sports',score:7.5]]],
%        [profile:email::mailto],
%        R).

%rename( profile:[sex:'M', nickname:'Bob', email:'bob@gmail.com', age:40, interests:[stag:[tag:'Art history', score:6.5 ], stag:[tag:'Sports',score:7.5]]],
%        [profile:interests::inter],
%        R).

%rename( profile:[sex:'M', nickname:'Bob', email:'bob@gmail.com', age:40, interests:[stag:[tag:'Art history', score:6.5 ], stag:[tag:'Sports',score:7.5]]],
%        [profile:interests:stag::scoredtag],
%        R).

%rename( profile:[sex:'M', nickname:'Bob', email:'bob@gmail.com', age:40, interests:[stag:[tag:'Art history', score:6.5 ], stag:[tag:'Sports',score:7.5]]],
%        [profile:interests:stag:score::val],
%        R).

%rename( profile:[sex:'M', nickname:'Bob', email:'bob@gmail.com', age:40, interests:[stag:[tag:'Art history', score:6.5 ], stag:[tag:'Sports',score:7.5]]],
%        [profile::user, profile:interests:stag:score::val],
%        R).

%rename( profile:[sex:'M', nickname:'Bob', email:'bob@gmail.com', age:40, interests:[stag:[tag:'Art history', score:6.5 ], stag:[tag:'Sports',score:7.5]]],
%        [profile::user, profile:sex::gender, profile:interests::inter, profile:interests:stag:score::val,
%         profile:interests:stag:tag::keyword, profile:interests:stag::scordtag, profile:nickname::username,
%         profile:email::mailto],
%        R).


%rename( profile:[sex:'M', nickname:'Bob', email:'bob@gmail.com', age:40, interests:[stag:[tag:'Art history', score:6.5 ], stag:[tag:'Sports',score:7.5]]],
%        [ profile::user,
%          profile:sex::gender,
%          profile:nickname::username,
%          profile:email::mailto,
%          profile:interests::inter,
%          profile:interests:stag::scortag,
%          profile:interests:stag:tag::keyword,
%          profile:interests:stag:score::val],
%        R).


theta_op('=').  theta_op('>').  theta_op('>=').  theta_op('<').  theta_op('<=').  theta_op('<>').

:-op(800,xfy, and).
:-op(900,  xfx, as).
:-op(950, fx, exists).
:-op(950, fx, forall).
:-op(350,xfy,::).

%Exp=pi(person,[nickname,age,pi(interests,[pi(stag,[score,tag])])]),dotnot_pi(Exp,NewExp).
dotnot_pi(A,pi([A])):-
	atom(A),!.
	
dotnot_pi(pi(A,List),pi(NA)):-
	list(List),!,
	findall(NewA,(member(Item,List),
		      dotnot_pi(Item,pi(NewSubExpList)),
		      member(NewSubExp,NewSubExpList),
	  	      atom_concat(A,'.',NewA1),
		      atom_concat(NewA1,NewSubExp,NewA)),
		NA).

%Exp=sigma(person,[sigma(interests,[sigma(stag,[tag='art'])])]), dotnot_sigma(Exp, NewExp).
dotnot_sigma(Exp,sigma([Exp])):-
	Exp=..[Op,_,_],
	theta_op(Op),!.

dotnot_sigma(exists Exp,exists NewExp):-!, dotnot_sigma(Exp,NewExp).

dotnot_sigma(forall Exp,forall NewExp):-!, dotnot_sigma(Exp,NewExp).

dotnot_sigma(sigma(A,List),sigma(NE)):-
        list(List),!,
        findall(NewExp,(member(Item,List),
                   dotnot_sigma(Item,Sigma),
                   ((Sigma=..[exists,sigma(NewSubExpList)],Quant='E ');
                    (Sigma=..[forall,sigma(NewSubExpList)],Quant='V ');
                    (Sigma=..[sigma,NewSubExpList],        Quant='')),
                   member(NewSubExp,NewSubExpList),
                   atom_concat(A,'.',NewExp1),
                   atom_concat(NewExp1,Quant,NewExp2),
                   NewSubExp=..[Op,Left,Right],
                   atom_concat(NewExp2,Left,NewExp3),
                   NewExp=..[Op,NewExp3,Right]),
                NE).

%dotnot_sigma(sigma(A,List),sigma(NE)):-
%        list(List),!,
%        findall(NewExp,(member(Item,List),
%                   dotnot_sigma(Item,sigma(NewSubExpList)),
%                   member(NewSubExp,NewSubExpList),
%                   atom_concat(A,'.',NewExp1),
%                   NewSubExp=..[Op,Left,Right],
%                   atom_concat(NewExp1,Left,NewExp2),
%                   NewExp=..[Op,NewExp2,Right]),
%                NE).

%Exp=(rho(person::user,[nickname::username,email::mailto,rho(interests::inter,[stag::scoredtag, score::val, tag::keyword]),sex::gender])),dotnot_rho(Exp,NewExp).
%Exp=rho(person :: user,[nickname :: username, email :: mailto,
%                    rho(interests :: inter,[rho(stag :: scoredtag,[score :: val, tag :: keyword])]),
%                    sex :: gender]),dotnot_rho(Exp,NewExp).
dotnot_rho(Name::Alias, rho([Name::Alias])):-!.

dotnot_rho(rho(Name::Alias,List),rho(NewExp)):-
	list(List),
	findall(NewName::NewAlias,(member(Item,List),
				   dotnot_rho(Item,rho(NewItem)),
				   member(NewSubTypeExp,NewItem),
		   		   NewSubTypeExp=..[::,NewSubTypeName,NewSubTypeAlias],
	           		   atom_concat(Name,'.',NewName1),
	           		   atom_concat(NewName1,NewSubTypeName,NewName),
	           		   atom_concat(Alias,'.',NewAlias1),
	           		   atom_concat(NewAlias1,NewSubTypeAlias,NewAlias)),
		NewExp).



dotnot(A,[A]):- atom(A), \+list(A),!.

dotnot(A::List,[A|DotNot]):-
	list(List),
	findall(DN,(member(A_i,List),
		    dotnot(A_i,NewA_i),
		    member(DN_Sub_A_i,NewA_i),
		    atom_concat(A,'.',DN1),
		    atom_concat(DN1,DN_Sub_A_i,DN)),
		   DotNot).
		

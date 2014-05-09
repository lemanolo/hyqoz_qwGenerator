api( whatulike::interests,
    [nickname::string],
    [interests::[interest::
                           [nickname::string,
                                 tag::string,
                               score::real
                           ]
                ]
    ],
    batch
   ).
api( friends::profile,
    [nickname::string],
    [profile::
       [nickname::string,
           email::string,
             sex::string,
	     age::integer
       ]
    ],
    batch
   ).

api( friends::friendsof,
    [nickname::string],
    [friendship::[nickname::string,
                      with::[friend::string]
                 ]
    ],
    batch
   ).


api( whereru::location,
    [nickname::string],
    [location::[nickname::string,
                lat::real,
                lon::real,
                timestamp::integer
               ]
    ],
    stream
   ).

api( whatduthink::posts,
     [nickname::string],
     [posts::[nickname::string,
              post::string,
              timestamp::integer]],
     stream).


api(Alias,Bounded,Free,SType):-
	%+Dataset
	%clause(dataset(Alias,_,_,_),true),
	%dataset(Alias,Bounded,Free,SType).
	clause(type_name(Alias,S_M),true),
	api(S_M,Bounded,Free,SType).
	%-Dataset

%dotnot(A::Type,[A]):- atom(A), \+list(A),atom(Type), \+list(Type).
%
%dotnot(A::List,DotNot):-
%        list(List),
%        findall(DN,(member(A_i,List),
%                    dotnot(A_i,NewA_i),
%                    member(DN_Sub_A_i,NewA_i),
%                    DN=A::DN_Sub_A_i),
%                   DotNot).

%type(DSs,Types):- params(DSs,Types).

%bounded(Alias,Alias::Bounded):-
%        api(Alias,B1,_,_),!,
%	getNames(B1,Bounded).

%free(Alias,Alias::Free):-
%        api(Alias,_,F1,_),!,
%	getNames(F1,Free).


%params([],[]):-!.
%params([Alias|Tail],[Params|ParamsTail]):-!,
%	params(Alias,Params),
%	params(Tail,ParamsTail).

%params(Alias,Alias::Params):-
%	atom(Alias),!,
%	bounded(Alias,Alias::Bounded),
%	free(Alias,Alias::Free),
%        union(Bounded,Free,Params),!.

%getNames([],[]):-!.
%getNames([Name::Type|Tail],[Name|NTail]):-
%	atom(Type),!,
%	getNames(Tail,NTail).
%getNames([Name::Complex|Tail],[Name::CName|NTail]):-
%	list(Complex),!,
%	getNames(Complex,CName),
%	getNames(Tail,NTail).
	

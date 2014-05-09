api( whatulike::interests,
    [nickname::string],
    [interest::[nickname::string,
                     tag::string,
                   score::real]
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

bounded(Alias,Bounded):-
	alias(Alias,DSName),
	api(DSName,B,_,_),!,
	dotnot(Alias::B,Bounded).

free(Alias,Free):-
	alias(Alias,DSName),
	api(DSName,_,F,_),!,
	dotnot(Alias::F,Free).

atts(Alias,Atts):-
	bounded(Alias,Bounded),
	free(Alias,Free),
	union(Bounded,Free,Atts).

dotnot(A::Type,[A]):- atom(A), \+list(A),atom(Type), \+list(Type).

dotnot(A::List,DotNot):-
        list(List),
        findall(DN,(member(A_i,List),
                    dotnot(A_i,NewA_i),
                    member(DN_Sub_A_i,NewA_i),
		    DN=A::DN_Sub_A_i),
%                    atom_concat(A,'.',DN1),
%                    atom_concat(DN1,DN_Sub_A_i,DN)),
                   DotNot).

is_dataflow(Edges):-
       %       paths(in,out,Edges,Paths),
       %       nl,write('     Paths: '),write(Paths),
       findall(Left,(member(arc(Left,_),Edges),atom_concat(r_,_,Left)),Retrievals),
       sort(Retrievals),
       %       nl,write('Retrievals: '),write(Retrievals),
       (
       length(Retrievals,1) -> (true)%,nl,write('   IS DATAFLOW'))
                         ; findall([R1,R2],(sublist([R1,R2],Retrievals),
                                                 (
                                                           (paths(R1,R2,Edges,RPaths),RPaths\=[]) ->true
                                                        ;  (paths(R2,R1,Edges,RPaths),RPaths\=[])
                                                 ),!
                                                 %,nl,write('    RPaths: '),write(RPaths)
                                            ),[])%,nl,write('   IS DATAFLOW')
       ).

test_paths:-
Relations=[dependent(r_b1,c_ab1),dependent(r_a1,c_ab1),independent(r_a1,r_b1),dependent(c_ab1,p_b1),dependent(c_ab1,p_a1),independent(p_a1,p_b1)],
TQWS=[tqw(qw([p_a1],[],[p_a1,in,out],[arc(in,p_a1),arc(p_a1,out)],in,out,cost(0,0,0)),p_a1([a],[],[a::nickname],p_a1)),tqw(qw([p_b1],[],[p_b1,in,out],[arc(in,p_b1),arc(p_b1,out)],in,out,cost(0,0,0)),p_b1([b],[],[b::nickname,b::interests],p_b1)),tqw(qw([r_a1],[],[r_a1,in,out],[arc(in,r_a1),arc(r_a1,out)],in,out,cost(0,0,0)),r_a1([a],[a::nickname='Alice'],[a::nickname,a::interests::interest::nickname,a::interests::interest::tag,a::interests::interest::score],r_a1)),tqw(qw([r_b1],[],[r_b1,in,out],[arc(in,r_b1),arc(r_b1,out)],in,out,cost(0,0,0)),r_b1([b],[b::nickname='Bob'],[b::nickname,b::interests::interest::nickname,b::interests::interest::tag,b::interests::interest::score],r_b1)),tqw(qw([c_ab1],[],[c_ab1,in,out],[arc(in,c_ab1),arc(c_ab1,out)],in,out,cost(0,0,0)),c_ab1([a,b],[a::interests::interest::tag=b::interests::interest::tag],[a::nickname,a::interests::interest::nickname,a::interests::interest::tag,a::interests::interest::score,b::nickname,b::interests::interest::nickname,b::interests::interest::tag,b::interests::interest::score],c_ab1))],
paths(Relations,TQWS,Path),
nl,write('Path:'),write(Path).

paths([Relation],_,[Relation]):-!.

paths(ToVisit,TQWS,[Relation|Visited]):-
        all_dependent(ToVisit),!,
        next_rel2(ToVisit,TQWS,Relation),!,
	Relation=..[_,DTFLId,_],
	findall(Rel,(member(Rel,ToVisit),(Rel=..[_,DTFLId,_];Rel=..[_,_,DTFLId])),UnVisitable),
	difference(ToVisit,UnVisitable,NewToVisit),
        paths(NewToVisit,TQWS,Visited).

paths(ToVisit,TQWS,[Relation|Visited]):-
        next_rel2(ToVisit,TQWS,Relation),
	Relation=..[_,DTFLId,_],
	findall(Rel,(member(Rel,ToVisit),(Rel=..[_,DTFLId,_];Rel=..[_,_,DTFLId])),UnVisitable),
	difference(ToVisit,UnVisitable,NewToVisit),
        paths(NewToVisit,TQWS,Visited).

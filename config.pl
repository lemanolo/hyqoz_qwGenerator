algorithm(naive2).
sco(pi([op4_op4::op4_op4_o_i,op4_op4::op4_op4_o_q,op1_op1::op1_op1_i_a,op1_op1::op1_op1_o_g,op1_op1::op1_op1_o_h,op1_op1::op1_op1_o_k,op1_op1::op1_op1_o_m,op1_op1::op1_op1_o_o],bind([op4_op4::op4_op4_i_a=op1_op1::op1_op1_o_q],sigma(op4_op4::op4_op4_o_g=val_f_op4_op4_o_g,rho(op4_op4::op4_op4 as op4_op4,op4_op4::op4_op4)),sigma(op1_op1::op1_op1_i_a=val_r_op1_op1_i_a,sigma(op1_op1::op1_op1_o_h=val_f_op1_op1_o_h,rho(op1_op1::op1_op1 as op1_op1,op1_op1::op1_op1)))))).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% outputFile/1
%
%VALUES: true | false
%  -   true: uses a file for sinking the results
%  -  false: uses the stdout for sinking the results
%
% outputFileName/1
%
%VALUES: 'string' with the file name for sinking the results
%
outputFile(true). 
outputFileName('output/SS_2_1_0_2_2_0-member_unsafe_false_global_memoization_cf.txt').
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% safe_generation/1
%
%VALUES: safe | unsafe
%  -   safe: the unsafe relations are cleanded.
%  - unsafe: unsafe relations are not verified
%
safe_generation(unsafe).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% no_redundant_relations/1
%
%VALUES: true | false
%  -   true: the redundant relations are cleanded.
%  -  false: the redundant relation not verified
%
no_redundant_relations(false).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% new_relations_computation/1
%
%VALUES:  local | global
%  -   local: only adjacent relations are recomputed
%  -  global: all the relations are recomputed
%
new_relations_computation(global).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% next_relation_selection/1
%
%VALUES: member | next_rel | next_rel2
%  -    member: the member/2 predicate is used to selelect the next relation
%  -  next_rel: the next_rel/2 predicate is used
%  - next_rel2: the next_rel2/3 predicate is used
%
next_relation_selection(member). 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% memoization/1
%
%VALUES: true | false
%  -      true: the qw generation memoizes the pairs of dt-functions already merged
%  -     false: the qw generation ignores the pairs of dt-functions already merged 
%
memoization(true). 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% flow/1
%
%VALUES: df | cf
%  -      df: The generation is done looking for dataflow shapes
%  -      cf: The generation is done looking for controlflow shapes
%
flow(cf). 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

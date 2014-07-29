%+COMMONS
:-initialization(consult('../hyqoz_commons/operators.pl')).
:-initialization(consult('../hyqoz_commons/api_utils.pl')).
:-initialization(consult('../hyqoz_commons/utils.pl')).
:-initialization(consult('../hyqoz_commons/utils_derivation.pl')).
%+COMMONS APIS
:-initialization(consult('../hyqoz_commons/api_exp.pl')).
%-COMMONS APIS
%-COMMONS


%+DTF DERIVATION
:-initialization(consult('../hyqoz_dtfsDerivator/derivation.pl')).
%-DTF DERIVATION


%+CORE
:-initialization(consult('relations.pl')).
:-initialization(consult('composition_patterns.pl')).
:-initialization(consult('merge_function.pl')).
:-initialization(consult('deadlock.pl')).
:-initialization(consult('redundant.pl')).
:-initialization(consult('algorithms.pl')).
:-initialization(consult('is_dataflow.pl')).
%-CORE


:-initialization(consult('qw_generation.pl')).


%+QW COST
:-initialization(consult('../hyqoz_qwWeighter/qos_measures.pl')).
:-initialization(consult('../hyqoz_qwWeighter/qw_cost.pl')).
:-initialization(consult('../hyqoz_qwWeighter/activity_cost.pl')).
:-initialization(consult('../hyqoz_qwWeighter/qw_utils.pl')).
%-QW COST


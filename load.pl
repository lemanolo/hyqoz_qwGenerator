:-initialization(consult('operators.pl')).
%+FACTS
:-initialization(consult('api_exp.pl')).
:-initialization(consult('api_utils.pl')).
%:-initialization(consult('queries.pl')).
:-initialization(consult('queries_exp.pl')).
:-initialization(consult('composition_patterns.pl')).
%-FACTS


%+FUNCTION DERIVATION
%:-initialization(consult('rename.pl')).
%:-initialization(consult('retrieval_utils.pl')).
%:-initialization(consult('retrieval.pl')).
%:-initialization(consult('binding_utils.pl')).
%:-initialization(consult('binding.pl')).
%:-initialization(consult('projection_utils.pl')).
%:-initialization(consult('projection.pl')).
%:-initialization(consult('filtering_utils.pl')).
%:-initialization(consult('filtering.pl')).
%:-initialization(consult('correlation.pl')).
%:-initialization(consult('correlation_utils.pl')).
:-initialization(consult('derivation.pl')).
%-FUNCTION DERIVATION

%+RELATIONS CALCULATION
:-initialization(consult('relations.pl')).
%-RELATIONS CALCULATION

%+CORE
:-initialization(consult('merge_function.pl')).
:-initialization(consult('qw_generation.pl')).
:-initialization(consult('deadlock.pl')).
:-initialization(consult('redundant.pl')).
:-initialization(consult('algorithms.pl')).
%+CORE

:-initialization(consult('utils.pl')).
:-initialization(consult('utils_derivation.pl')).

:-initialization(consult('test_all.pl')).



%COST
:-initialization(consult('../qw_cost/qw_cost.pl')).
:-initialization(consult('../qw_cost/activity_cost.pl')).
:-initialization(consult('../qw_cost/qw_utils.pl')).

%:-initialization(consult('config.pl')).

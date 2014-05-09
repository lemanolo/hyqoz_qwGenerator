cd /Users/aguacatin/Research/HADAS/PhD/Prolog/qw_generation/
/opt/local/bin/gprolog --init-goal "['load_qw_cost.pl']" --entry-goal "run_qw_cost(COST),nl,nl,write('COST = '),write(COST),nl,nl" --query-goal "halt" | egrep "COST"

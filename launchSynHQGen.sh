cd /Users/aguacatin/Research/HADAS/PhD/Prolog/qw_generation/
/opt/local/bin/gprolog --init-goal "['load_create_hq.pl']" --entry-goal "synHQGenerator(SCO,HSQL),nl,nl,write('SCO = '),write(SCO),nl,nl,write('HSQL = '),write(HSQL),write(';'),nl,nl" --query-goal "halt" | egrep "SCO|HSQL"

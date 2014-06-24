export CONFIG_FILE=$1
cd /Users/aguacatin/Research/HADAS/PhD/Prolog/hyqoz_qwGenerator
/opt/local/bin/gprolog --init-goal "['load.pl','${CONFIG_FILE}']" --entry-goal "generate_qws_from_java, nl,nl" --query-goal "halt" | egrep "^ *(QW|DTYPES|ACTIVITIES)"

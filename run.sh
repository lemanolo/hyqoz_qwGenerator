ID="${1}"
#SCO=`echo "${2}"|sed -e "s/\./::/g"`
DTYPES=`echo "${2}"|sed -e "s/\./::/g"`
DTFS=`echo "${3}"|sed -e "s/\./::/g"`
NEXT_RELATION_SELECTION="${4}"
SAFE_GENERATION="${5}"
NO_REDUNDANT_RELATIONS="${6}"
NEW_RELATIONS_COMPUTATION="${7}"
MEMOIZATION="${8}"
FLOW="${9}"
WEIGHTING="${10}"

if [[ "$MEMOIZATION" == "memoization" ]]; then
       echo "memoization"
       MEMOIZATION_VALUE="true"
else
       echo "no memoization"
       MEMOIZATION_VALUE="false"
fi

export MAX_ATOM=$((2**17)) #131072

OUTPUTFILENAME_PREFIX="SS_${ID}-${NEXT_RELATION_SELECTION}_${SAFE_GENERATION}_${NO_REDUNDANT_RELATIONS}_${NEW_RELATIONS_COMPUTATION}_${MEMOIZATION}_${FLOW}_${WEIGHTING}"
OUTPUTFILENAME="output/${OUTPUTFILENAME_PREFIX}.txt"
OUTPUTFILENAME_CLEAN="output/${OUTPUTFILENAME_PREFIX}_clean.txt"
OUTPUTFILENAME_UNIQUE="output/${OUTPUTFILENAME_PREFIX}_unique.txt"
OUTPUTFILENAME_COSTS="output/${OUTPUTFILENAME_PREFIX}_costs.txt"

CLEAN="./clean.sh"
date="$(date)"

CONFIG_FILE_LAYOUT="config.pl.layout"
CONFIG_FILE="config.pl"

TMP_OUTPUTFILENAME=`echo $OUTPUTFILENAME| sed -e "s/\\\\//\\\\\\\\\//"`

#| sed -e "s/#SCO#/${SCO}/"   \
cat ${CONFIG_FILE_LAYOUT}  \
| sed -e "s/#DTYPES#/${DTYPES}/"   \
| sed -e "s/#DTFS#/${DTFS}/"   \
| sed -e "s/#OUTPUTFILENAME#/${TMP_OUTPUTFILENAME}/"  \
| sed -e "s/#SAFE_GENERATION#/${SAFE_GENERATION}/"  \
| sed -e "s/#NO_REDUNDANT_RELATIONS#/${NO_REDUNDANT_RELATIONS}/"  \
| sed -e "s/#NEW_RELATIONS_COMPUTATION#/${NEW_RELATIONS_COMPUTATION}/"  \
| sed -e "s/#NEXT_RELATION_SELECTION#/${NEXT_RELATION_SELECTION}/"  \
| sed -e "s/#MEMOIZATION#/${MEMOIZATION_VALUE}/"  \
| sed -e "s/#FLOW#/${FLOW}/"  \
| sed -e "s/#WEIGHTING#/${WEIGHTING}/"  \
> ${CONFIG_FILE}


#OUTPUTFILENAME=`echo "${OUTPUTFILENAME_PREFIX}" | sed -e "s/\\\//"`

LOADFILE="load.pl"
GOAL="generate_ss_for_dtfs(false)"
EXIT="halt"

COMMAND="gprolog --init-goal ['${LOADFILE}'],['${CONFIG_FILE}'] --entry-goal ${GOAL} --query-goal ${EXIT}"
### echo "   GOAL:" $GOAL
### echo "COMMAND:" $COMMAND
### echo " CONFIG:" $CONFIG_FILE
### echo ""
### cat $CONFIG_FILE | egrep -v "^ *%|^ *$"
### echo ""

STATS="tmp/$$.txt"
LOG="log/${OUTPUTFILENAME_PREFIX}_$$.log"
echo "${date}\c"
echo "   PERFORMING "$ID "...\c"
time="$(time (${COMMAND} | tee ${LOG} |grep "stats" > ${STATS} ) 2>&1 >/dev/null)"

stats="$(cat ${STATS})"
rm ${STATS}

echo "CLEANING ...\c"
cat ${OUTPUTFILENAME} | grep  "Final E:" | ${CLEAN} | sort > ${OUTPUTFILENAME_CLEAN}
number_of_qws="$( cat ${OUTPUTFILENAME_CLEAN}| wc -l )"
echo "DELETING DUPS ...\c"
#cat ${OUTPUTFILENAME_CLEAN} | uniq -c | grep -n "^.*$" >${OUTPUTFILENAME_UNIQUE}
cat ${OUTPUTFILENAME_CLEAN} | uniq -c >${OUTPUTFILENAME_UNIQUE}
#cat ${OUTPUTFILENAME_UNIQUE} | awk -F " " '{print $1 $7}' | sed -E "s/cost\(|\)//g" | sed -E "s/:|,/;/g" | sed "s/\./,/g" > ${OUTPUTFILENAME_COSTS}
cat ${OUTPUTFILENAME_UNIQUE} | awk -F " " '{print $1 $5}' | sed -E "s/cost\(|\)//g" | sed -E "s/:/,/g" > ${OUTPUTFILENAME_COSTS}
cat ${OUTPUTFILENAME_CLEAN} | awk -F " " '{print $5}' | sort -u >${OUTPUTFILENAME_UNIQUE}
number_of_unique_qws="$( cat ${OUTPUTFILENAME_UNIQUE}| wc -l )"

real_time=`echo $time | awk -F " " '{print $2}'`


echo "\t " $ID "\t " $stats "\t QWs: " $number_of_qws "\t UniqueQWs: "$number_of_unique_qws "\t Time: " $real_time 
echo "LOG: ${LOG}"


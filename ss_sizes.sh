FILE="ss_sizes.txt"
#FILE="/Users/aguacatin/Research/HADAS/workspace_aesop/HyQoZTestbed/SyntheticHQs/2_DSs.txt"

counter=0

IS_COMMENTED=0
while read line
do           
    counter=$((counter+1))
    n=$((counter%6))
    case $n in
       1)  ID=$line
          if echo $ID|grep --quiet "^#"; then
              IS_COMMENTED=1
          else
                 DASHES=""
                 #COLS_NUM=`tput cols`
                 COLS_NUM=$((`tput cols`-${#ID}))
                 for i in $(seq 1 $COLS_NUM); do
                     DASHES=`echo "${DASHES}-"`
                 done
	       echo "$ID$DASHES"
          fi
	;;
       2) SCO=`echo $line | sed -e "s/\./::/g"`
              #echo "  SCO: "$SCO
	;;
       3) TYPES=`echo $line | sed -e "s/\./::/g"`
              #echo "TYPES: "$TYPES
	;;
       4) DTFS=`echo $line | sed -e "s/\./::/g"`
              #echo " DTFS: "$DTFS
	;;
       5) HSQL=`echo $line | sed -e "s/\./::/g"`
              #echo " HSQL: "$HSQL
	;;
       0) 
              if [ "$IS_COMMENTED" -eq 0 ]; then
                     #SEL=member    ; SAFE=unsafe ; NO_RED=false  ; COM=global; MEM=memoization;  FLOW=cf; WEIGHTING=cost; STATS=`sh run.sh $ID "${TYPES}" "${DTFS}" $SEL $SAFE $NO_RED $COM $MEM $FLOW $WEIGHTING | grep -v LOG | awk -F "$ID" '{print$3}'|tr '\n' ' '`; echo "$ID\t$SEL\t$SAFE\t$NO_RED\t$COM\t$MEM\t$FLOW\t$WEIGHTING $STATS"
                     #SEL=member    ; SAFE=unsafe ; NO_RED=false  ; COM=global; MEM=memoization;  FLOW=df; WEIGHTING=cost; STATS=`sh run.sh $ID "${TYPES}" "${DTFS}" $SEL $SAFE $NO_RED $COM $MEM $FLOW $WEIGHTING | grep -v LOG | awk -F "$ID" '{print$3}'|tr '\n' ' '`; echo "$ID\t$SEL\t$SAFE\t$NO_RED\t$COM\t$MEM\t$FLOW\t$WEIGHTING $STATS"
                     #SEL=member    ; SAFE=safe ; NO_RED=false  ; COM=local; MEM=memoization;  FLOW=cf; WEIGHTING=cost; STATS=`sh run.sh $ID "${TYPES}" "${DTFS}" $SEL $SAFE $NO_RED $COM $MEM $FLOW $WEIGHTING | grep -v LOG | awk -F "$ID" '{print$3}'|tr '\n' ' '`; echo "$ID\t$SEL\t$SAFE\t$NO_RED\t$COM\t$MEM\t$FLOW\t$WEIGHTING $STATS"
                     SEL=member    ; SAFE=unsafe ; NO_RED=false  ; COM=global; MEM=memoization;  FLOW=df; WEIGHTING=cost; STATS=`sh run.sh $ID "${TYPES}" "${DTFS}" $SEL $SAFE $NO_RED $COM $MEM $FLOW $WEIGHTING | grep -v LOG | awk -F "$ID" '{print$3}'|tr '\n' ' '`; echo "$ID\t$SEL\t$SAFE\t$NO_RED\t$COM\t$MEM\t$FLOW\t$WEIGHTING $STATS"

              fi
              IS_COMMENTED=0
	;; #SCO
    esac
done <$FILE

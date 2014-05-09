FILE="/Users/aguacatin/Research/HADAS/workspace_aesop/HyQoZTestbed/SyntheticHQs/2_DSs.txt"

counter=0

while read line
do           
    counter=$((counter+1))
    n=$((counter%3))
    case $n in
       1)  ID=$line
	   echo $ID
	;;
       2) SCO=`echo $line | sed -e "s/\./::/g"`
	  echo $SCO
	;;
       0) 
SEL=member    ; SAFE=unsafe ; NO_RED=false  ; COM=global; MEM=memoization; STATS=`sh run.sh $ID "$SCO" true $SEL $SAFE $NO_RED $COM $MEM  | grep -v LOG | awk -F "$ID" '{print  $3}'`; echo "$ID\t$SEL\t$SAFE\t$NO_RED\t$COM\t$MEM\t$STATS"
#SEL=member    ; SAFE=safe   ; NO_RED=true   ; COM=local ; STATS=`sh run.sh $ID "$SCO" true $SEL $SAFE $NO_RED $COM  | grep -v LOG | awk -F "$ID" '{print  $3}'`; echo "$ID\t$SEL\t$SAFE\t$NO_RED\t$COM\t$STATS"
#SEL=next_rel  ; SAFE=safe   ; NO_RED=true  ; COM=local ; STATS=`sh run.sh $ID "$SCO" true $SEL $SAFE $NO_RED $COM  | grep -v LOG | awk -F "$ID" '{print  $3}'`; echo "$ID\t$SEL\t$SAFE\t$NO_RED\t$COM\t$STATS"

	;; #SCO
    esac
done <$FILE

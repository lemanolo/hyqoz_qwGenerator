TMP=`mktemp -t cleanSS`
tr "@" "a" | tr "&" "a" | sed -E "s/par_[[:alnum:]|#|$|_|&|@]{1,7}/par/g" | sed -E "s/end_par_[[:alnum:]|#|$|_|&|@]{1,7}/end_par/g" > $TMP
while read l
do
	arc=`echo $l | awk -F "[" '{print $2}' | sed -e "s/\]//" | sed -E "s/) *,arc/)=arc/g"  | tr "=" "\n"| sort| tr "\n" ","` 
	echo $l | awk -v arc=$arc -F "[" '{print $1 "\t\[" arc}' | sed -e "s/, *$/\]/"
done < $TMP

awk -v val=$value '{print val}'

rm $TMP

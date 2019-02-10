#!/usr/local/bin/ksh
#parsecsv.sh
#Example how to parse csv
#look also parsecsv2.sh
# Jukka Inkeri kshji 15.9.2018
# 

cat <<EOF > test.csv
col1;col2;col3
a b;c d;e f
1st;"tool 4""";4 inch
First;"""string with double-quotes""";3th string
1st;"str ""with double-quotes"" string";3th field
fld1;"2nd fld is
multiline";fld3
col1cal;col2val;col3val
EOF


integer linecnt=0 nfields

typeset -a cols
while IFS=";" read -A -S cols
do
        ((nfields=${#cols[@]}))
	((linecnt+=1))
	note=""
	# headerline process
        ((linecnt==1)) && note="Header"

	printf "%s %d: " $note $linecnt 
	# - cols
        for ((col=0; col < nfields;col++)) 
        do
		printf " (%d:) %s" $((col+1)) "${cols[$col]}"
        done 
	print
done < test.csv



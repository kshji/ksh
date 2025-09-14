#!/usr/local/bin/awsh
# parsecsv3.sh
# 
# Example how to parse csv to the variable using 1st line colnames
# In this case you know the colnames, order is dynamic
# Look parsecsv2.sh which handle also colnames to be variable - dynamically
#
# look also parsecsv.sh and parsecsv2.sh
# Jukka Inkeri kshji 14.9.2025
# This work also in the bash. 
# 
# This is also excellent example how sh parse and process the command line
# 1st look is magic ...
#

deli=";"
oifs="$IFS"
inf=/dev/stdin

while [ $# -gt 0 ]
do
	arg="$1"
	case "$arg" in
		-d) deli="$2" ; shift ;;
		-f) inf="$2" ; shift ;;
	esac
	shift
done

# This is nice ... example about command line processing
variable=variables
cnt=0
while IFS="$deli" read $variables
do
	((cnt++))
	IFS="$oifs"
	((cnt == 1)) && variables=${variables//${deli}/ } && continue
	echo "name:$name age:$age girlfriend:$girlfriend random:$random"

done < $inf


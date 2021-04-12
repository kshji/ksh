#!/usr/bin/ksh
# 21.sh
# - also bash compatible
# https://github.com/kshji
# License, read https://github.com/kshji/ksh
#
# Karjalan ATK-Awot Oy 2020, Jukka Inkeri
# 2020-04-16
#
# Modulus 10, weight 21
# https://fi.wikipedia.org/wiki/Luhnin_algoritmi
# https://en.wikipedia.org/wiki/Luhn_algorithm
#

refsrc="$1"
PRG="$0"

######################################################################
usage()
{
	echo "usage:$PRG laskunro ">&2
	echo "usage:$PRG ReferenceNumber ">&2
	echo "max.len 24 - maksimpituus 24 ">&2
}

######################################################################
# MAIN
######################################################################

[ "$refsrc" = "" ] && usage && exit 1
# array 1st element index is 0
mask="212121212121212121212121212121212121212121212121212"
sum=0
i=0
sum=0
len=${#refsrc}

# max 24 numbers
(( len > 24 )) && usage && exit 2

(( loc=len-1 ))
while (( i<len ))
do
	factor=${mask:$i:1}
	number=${refsrc:$loc:1}
	(( loc=loc-1 ))
	(( i=i+1 ))
	(( result=factor*number ))
	if ((result>9)) ; then  # next equal 10
		(( mod=(result%10)))
		(( sum=sum+1 ))
		#echo " - f:$factor number:$number res:$result mod:$mod sum:$sum"
		((result=result-10))
	fi
	(( sum=sum+result ))
	#echo "f:$factor number:$number res:$result mod:$mod sum:$sum"
done
#echo "sum:$sum"

dec=sum
(( mod=sum%10 ))
if ((mod != 0)) ; then  # next equal 10
	(( dec=(sum/10+1)*10 ))
fi
(( checksum = dec-sum ))

# Output Payment reference Number
echo "$refsrc$checksum"


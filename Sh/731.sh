#!/usr/bin/ksh
# 731.sh
# - also bash compatible
# https://github.com/kshji
# License, read https://github.com/kshji/ksh
#
# Karjalan ATK-Awot Oy 2020, Jukka Inkeri
# 2020-04-16
#
# suomalainen pankkiviite 19+1 max.
# Finnish  Payment Reference Calculation (731-crc)
# Payment Reference Number
# max. length 19 + checksum = 20
# https://www.finanssiala.fi/maksujenvalitys/dokumentit/Forming_a_Finnish_reference_number.pdf
#
# How to make International RF Payment Reference ?
# look RF.sh
#

refsrc="$1"
PRG="$0"

######################################################################
usage()
{
	echo "usage:$PRG laskunro ">&2
	echo "usage:$PRG ReferenceNumber ">&2
	echo "max.len 19 - maksimpituus 19 ">&2
}

######################################################################
# MAIN
######################################################################

[ "$refsrc" = "" ] && usage && exit 1
# array 1st element index is 0
mask="731731731731731731731731731731731731731731731731"
sum=0
i=0
sum=0
len=${#refsrc}

# max 19 numbers
(( len > 19 )) && usage && exit 2

(( loc=len-1 ))
while (( i<len ))
do
	factor=${mask:$i:1}
	number=${refsrc:$loc:1}
	(( loc=loc-1 ))
	(( i=i+1 ))
	#echo "f:$factor number:$number"
	(( result=factor*number ))
	(( sum=sum+result ))
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


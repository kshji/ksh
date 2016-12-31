#!/usr/local/bin/awsh

############################################################
JulianDate()
{
 oifs="$IFS"
 IFS="-"
 array=($1)
 d=${array[2]}
 m=${array[1]}
 y=${array[0]}
echo $((d-32075+1461*(y+4800+(m-14)/12)/4+367*(m-2-(m-14)/12*12)/12-3*((y+4900+(y-14)/12)/100)/4 ))
}

############################################################
# date calculation using julian date
# 
fromdate=$( JulianDate 2011-04-01 ) # ISO y-m-d
todate=$( JulianDate 2011-05-04 )

diff=$((todate - fromdate))

echo "Diff: $fromdate $todate $diff"

############################################################
# time format same as date command using +

timestamp=$( printf "%(%Y-%m-%d_%H%M%S)T" now )

############################################################
# length of day (seconds) = 86400
# day length seconds
((day=24*60*60))

############################################################
# Date calculation using epoc
fromdate="04/01/11"
todate="05/04/11"
# datestr => epoc
epoc1=$(printf "%(%#)T" "$fromdate")
epoc2=$(printf "%(%#)T" "$todate")
echo "Diff: $fromdate $todate $(( (epoc2-epoc1) /day)) "


###########################################################
# Yesterday
echo "Yesterday 2015-02-01"
epoc=$(printf "%(%s)T" "2015-02-01")
# now you can calculate and after that convert back to date string
((yesterday=epoc-day))
printf "%(%Y-%m-%d)T" "#$yesterday"

# real yesterday
# Yesterday
epoc=$(printf "%(%s)T" now )
# now you can calculate and after that convert back to date string
((yesterday=epoc-day))
printf "%(%Y-%m-%d)T" "#$yesterday"


###########################################################
# some time values
printf "%(%Y-%m-%d)T\n" now
# change timezone
echo "Timezone"
printf "%(%Y-%m-%d %H:%M:%S %Z)T\n" now GMT
echo "------"
printf "a %(%a)T\n" now
printf "u %(%u)T\n" now
printf "g %(%g)T\n" now
printf "G %(%G)T\n" now




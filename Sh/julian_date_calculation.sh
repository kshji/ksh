#!/usr/local/bin/awsh
# julian_date_calculation.sh
# The following conversion algorithm is due to Henry F. Fliegel and Thomas C. Van Flandern (1968)
# http://www.stiltner.org/book/bookcalc.htm

###########################
Julian2Date()
{
        #  arg1 = julian date
        # output format yyyymmdd
        jd="$1"
        ((l = jd + 68569    ))
        ((n = ( 4 * l ) / 146097    ))
        ((l = l - ( 146097 * n + 3 ) / 4    ))
        ((i = ( 4000 * ( l + 1 ) ) / 1461001    ))
        ((l = l - ( 1461 * i ) / 4 + 31    ))
        ((j = ( 80 * l ) / 2447    ))
        ((d = l - ( 2447 * j ) / 80    ))
        ((l = j / 11    ))
        ((m = j + 2 - ( 12 * l )    ))
        ((y = 100 * ( n - 49 ) + i + l    ))
        (( m<10 )) && m="0$m"
        (( d<10 )) && d="0$d"
        echo "$y$m$d"
}
###########################
Date2Julian()
{
 # arg1 format yyyymmdd
 day=$1
 d=${day:6:2}
 m=${day:4:2}
 y=${day:0:4}
 (( jd = ( 1461 * ( y + 4800 + ( m - 14 ) / 12 ) ) / 4 +
          ( 367 * ( m - 2 - 12 * ( ( m - 14 ) / 12 ) ) ) / 12 -
          ( 3 * ( ( y + 4900 + ( m - 14 ) / 12 ) / 100 ) ) / 4 +
          d - 32075
 ))
 echo "$jd"
}
################################################
for d in 20110401 20220301 20240301 20220101 19000101
do
        mydate=$(Date2Julian $d )
        ((yesterday=mydate-1))
        echo "$d - 1 = $(Julian2Date $yesterday)"
done


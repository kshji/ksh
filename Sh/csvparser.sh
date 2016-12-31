#!/usr/local/bin/awsh
# csvparser.sh
# Jukka Inkeri 10.11.2007
#

# 
# generate some sample.csv to test
echo "$(<<EOF
name;age;girlfriend;random
aa;11;yes;$RANDOM
bb;22;yes;$RANDOM
cc;33;no;$RANDOM
dd;44;no;$RANDOM
ee;55;yes;$RANDOM
ff;44;
;44;no;$RANDOM
aa;55;no;xx;zz
EOF
)" > sample.csv

### csvparser
PRG="$0"
lastfld=0
flds[0]=""
val[0]=""
oifs="$IFS"
defdeli=";"
deli="$defdeli"
outdeli="$deli"
str=""
debug=1
outdeli=" | "
inf=sample.csv   # default inputfile
debug=1  # default is ON  0|1

#####################################
dbg()
{
   ((debug<1)) && return
   echo "$*" >&2
}

#####################################
initcolnames()
{
    Xcnt=$1
    Xdeli=$2
    Xstr=""
    Xfld=1
    while ((Xfld <= Xcnt ))
    do
        Xstr="${Xstr}col${Xfld}$Xdeli"
        ((Xfld+=1))
    done
    echo "$Xstr"
}
#####################################
setvar()
{
   str="$*"
   IFS="$deli"
   val=($str)
   IFS="$oifs"
   last=${#val[@]}
   f=0
   while ((f<=last && f<=lastfld))
   do
        var="${flds[$f]}"
        value="${val[$f]}"
        eval $var=\"$value\"
        ((f+=1))
   done

}

#####################################
showvar()
{
   f=0
   outstr=""
   Xoutdeli="$outdeli"
   while ((f<=lastfld))
   do
        var="${flds[$f]}"
        (( f == lastfld )) && Xoutdeli=""
        eval value=\""\$$var"\"
        outstr="$outstr$value$Xoutdeli"
        ((f+=1))
   done
   echo "$outstr"
}
#####################################
clrvar()
{
   f=0
   while ((f<=lastfld))
   do
        var="${flds[$f]}"
        eval $var=\"\"
        ((f+=1))
   done
}

#####################################
colnames()
{
    nf=0
    while [ $# -gt 0 ]
    do
        opt="$1"
        case "$opt" in
                -c) nf=$2       # no colnames, create
                   shift
                   ;;
                -d) defdeli=$2
                   shift
                   ;;
                *) str="$*" ; break ;;
        esac
        shift
    done

    (( nf > 0 )) && str=$(initcolnames $nf "$defdeli" )
    IFS="$deli"
    flds=($str)
    IFS="$oifs"
    lastfld=${#flds[@]}
    ((lastfld-=1))

    ((debug<1)) && return

    # debug colnames
    f=0
    echo "Colnames:"
    while ((f<=lastfld))
    do
	echo "$f: ${flds[$f]}"
	((f+=1))
    done
    echo "_________________________________"
		

}

#####################################
usage()
{
  echo "$PRG:usage [ -f inputcsv ] [ -D 0|1 (debug) ] [-d InputDelimiter ] [ -o OutputDemimiter ] " >&2
}

#####################################
# MAIN
#####################################
#
#deli=";"   # set input delimeter , or use -d option in colnames
lineno=0

# parse arg + options
while [ $# -gt 0 ]
do
	arg="$1"
	case "$arg" in
		-f) inf="$2" ; shift ;;
		-d) deli="$2" ; shift ;;
		-D) debug="$2" ; shift ;;
		-o) outdeli="$2" ; shift ;;
		-h) usage ; exit 1 ;;
		--) shift; break ;;
		-*) usage ; exit 1 ;;
		*) break ;;
	esac
	shift
done


# 1st line include colnames
while read line
do
    ((lineno+=1))
    (( lineno == 1 )) && colnames -d "$deli" "$line" && continue  # headerline = variable names
    clrvar
    setvar "$line"
    dbg "_______________________________________________"
    ((debug>0)) && printf "Vars:" && showvar

    # example using values colnames as variables
    echo "$name$outdeli$age$outdeli$girlfriend$outdeli$random"
    [ "$name" = "cc" ] && echo "Found: $name, age:$age"
	

done < "$inf"


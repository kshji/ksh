#
# lib.sh
# Jukka Inkeri
# some usable function for ksh (mostly ok also in bash and dash)

###############################################################
parse_str()
{
 [ "$*" = "" ] && return
 eval print --  \""$*"\"
}

###############################################################
round()
{
# any round is possible
# ex. time  round 900 s = 15 mins
# arg1 7642
# arg2 900
#</DEFINITION>
  Xsrc="$1"
  Xtarkkuus="$2"
  ((Xpyorista=Xtarkkuus/2))
  ((Xlkm=(Xsrc+Xpyorista)/Xtarkkuus))
  ((Xtulos=Xlkm*Xtarkkuus))
  echo "$Xtulos"
}
###############################################################
replace()
# arg1 input
# arg2 which string replace
# arg3 newstr
{
        Xstr="$1" 
        Xmika="\\$2"
        Xmilla="\\$3"
        eval print -- "\${Xstr//${Xmika}/${Xmilla}}"
}
###############################################################
trimchar()
# arg1 str
# arg2 trimchar
{
	Xstr="$1"
	Xdeli="$2"
	while [ "${Xstr:0:1}" = "$Xdeli" ] ; do
		Xstr=${Xstr/#$Xdeli/}  #-alkutyhje
	done
	Xlen=${#Xstr}
	((Xlen-=1))
	while [ "${Xstr:$Xlen:1}" = "$Xdeli" ] ; do
		Xstr=${Xstr/%$Xdeli/}  #-lopputyhje
		Xlen=${#Xstr}
		((Xlen-=1))
	done
	print -- "$Xstr"
}

###############################################################
trim()
# remove whitespace
{
	XXstr="$*"
	XXstr=$(trimchar "$XXstr" " ")
	XXstr=$(trimchar "$XXstr" "\013")  #TAB
	print -- "$XXstr"
}


#-----------------------------------------------
parse_file()
{
 # like HERE, file can include variables and commands $( .... )
 # dangerous - use eval
 [ "$*" = "" ] && return
 [ ! -f "$1" ] && return
 eval echo  "\"$(cat $1 | sed 's+\"+\\"+g'   )\""
}
#-----------------------------------------------
show_file()
{
 [ "$*" = "" ] && return
 [ ! -f "$1" ] && return
 cat "$1" 
}
#-----------------------------------------------
ordhex()
{
        # ordhex A =>  41
    printf '%x' "'$1"
}

#-----------------------------------------------
chrhex()
{
        # chrhex 41 => A
    printf \\x"$1"
}

# vastaavat 10-jarj
#-----------------------------------------------
ord()
{
    echo -n $(( ( 256 + $(printf '%d' "'$1"))%256 ))
}

#-----------------------------------------------
chr()
{
    printf \\$(($1/64*100+$1%64/8*10+$1%8))
}

#-----------------------------------------------
toascmulti()
{
for mja in $*
do

	eval Str=\""\$$mja"\" 
	Str=$(toasc "$Str")
	eval $mja=\""$Str"\"
done
}
#-----------------------------------------------
toasc()
{ # -i ja mja-luettelo eli luettelomjia, joille kaikille ...
	[ "$1" = "-v" ] && shift && toascmulti $* && return
	str="$*"
	#eval echo  "\$'${str//'%'@(??)/'\'x\1"'\$'"}'"  2>/dev/null
	eval print -r -- "\$'${str//'%'@(??)/'\'x\1"'\$'"}'"  2>/dev/null
}
#-----------------------------------------------
str2xml()
{
	Xstr="$*"
	Xstr="${Xstr//\&/\&amp;}"
	Xstr="${Xstr//</\&lt;}"
	Xstr="${Xstr//>/\&gt;}"
	echo "$Xstr"
}
#-----------------------------------------------
first_slash()
{
	str="$*"
	len=${#str}
	((len-=1))
	first=${str:0:1}
	[ "$first" = "/" ] && str=${str:1:len}
	print -- "$str"
}
#-----------------------------------------------
last_slash()
{
	str="$*"
	len=${#str}
	((len-=1))
	last=${str:$len:1}
	[ "$last" = "/" ] && str=${str:0:len}
	print -- "$str"
}
#-----------------------------------------------
getdir()
{
	str="$*"
	strorg="$str"
	[ "$str" = "/" ] && str=""
	str=$(last_slash "$str")
	# ei saa poistaa jos on jo hakemisto !!!
	[ -d "$str" ] && print -- "$str" && return
	#[ "$strorg" = "$str" ] && print -- "." && return
	print -- "${str%/*}"
}
getfile()
{
	str="$*"
	print -- "${str##*/}"
}
getbase()
{
	str="$1"
	remove="$2"
	eval print -- "\${str//$2/}"
}
del_spaces()
{
print -- "$*" | sed -e "s/^ *//" -e "s/ *$//"
}

field_first()
{
	Xstr="$1"
	Xdelim="\\$2"
	eval print -- "\${Xstr%%${Xdelim}*}"
}
field_last()
{
	Xstr="$1"
	Xdelim="\\$2"
	#[ "$Xdelim" = "&" ] && Xdelim="\&"
	eval print -- "\${Xstr##*${Xdelim}}"
}
field_notlast()
{
	Xstr="$1"
	Xdelim="\\$2"
	#[ "$Xdelim" = "&" ] && Xdelim="\&"
	eval print -- "\${Xstr%${Xdelim}*}"
}
field_notfirst()
{
	Xstr="$1"
	Xdelim="\\$2"
	#[ "$Xdelim" = "&" ] && Xdelim="\&"
	eval print -- "\${Xstr#*${Xdelim}}"
}

###############################################################
timestamp()
{
     	arg="$*"
        printf "%(%Y%m%d%H%M%S)T" now
        [ "$arg" != "" ] && printf " %s" "$arg"
        printf "\n"

}

###############################################################
dateYMD()
# input yyyymmdd or dd.mm.yyyy
# return always yyyymmdd
{
        Xsyote="$1"
        [ "$Xsyote" = "" ] && echo "" && return 1
        case "$Xsyote" in
                20[0-9][0-9][0-1][0-9][0-3][0-9])  # - already yyyymmdd
                        echo "$Xsyote"
                        return 0
                        ;;
                [0-9]*.[0-9]*.20[0-9][0-9]) :
                        # 
                        ;;
                *) echo "" && return 1 ;;
        esac
        XXoifs="$IFS"
        IFS="."
        set -- $Xsyote
        IFS="$XXoifs"
        pv=$1
        kk=$2
        vuosi=$3
        [ "${#pv}" -lt 2 ] && (( pv < 10 )) && pv="0$pv"
        [ "${#kk}" -lt 2 ] && (( kk < 10 )) && kk="0$kk"
        echo "$vuosi$kk$pv"
}
YMDdate()
# yyyymmdd -> dd.mm.yyyy
{
  a=$1
  Xv=${a:0:4}
  Xk=${a:4:2}
  Xp=${a:6:2}
  echo "$Xp.$Xk.$Xv"
}


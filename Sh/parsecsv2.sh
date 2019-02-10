#!/usr/local/bin/ksh
# parsecsv2.sh
#
# Jukka Inkeri kshji 15.9.2018
# Example show how to parse csv and set variable using column names
# also printout csv format
# look also parsecsv.sh
# 
PRG="$0"
BINDIR="${PRG%/*}"
[ "$PRG" = "$BINDIR" ] && BINDIR="." # - same dir as program
PRG="${PRG##*/}"

integer columns=0 	# number of cols in csv
typeset -a cols 	# inputline values
typeset -a colnames 	# save 1st line colnames
debug=0 		# default, no debug
output=0		# make output, default no
outputcsv=0		# make csv output, default no
inputcsv=test.csv	# input file csv
flddelim=";"		# field delimiter


#################################################
make_csv_file()
{
csv="$(<<EOF 
col1;col2;col3
a b;c d;e f
1st;"tool 4""";4 inch
First;"""string with double-quotes""";3th string
1st;"str ""with double-quotes"" string";3th field
fld1;"2nd fld is
multiline";fld3
col1cal;col2val;col3val
EOF
)"
print "$csv" > test.csv
}


#################################################
dbg()
{
	((debug<1)) && return
	print "$*" >&2
}

#################################################
usage()
{
	print "usage:$PRG [ -c inputcsv ] [ -f delimiterchar ] [ -o 0|1 ] [ -O 0|1 ] [ -d 0|1 ]
		-c csvinputfile
		-o 1 output values , default 0
		-O 1 output values csv format, default 0
		-f DelimiterChar,  default ;
		-d 0|1 debug, default 0
	" >&2
}

#################################################
initcols()
{
	# save colnames to colnames array
	# colnames have to be acceptable for variable = need to check "strings", 
	# can't start with number and orher chars are 0-7 or a-z or A-Z
	# Used regexp  to clean strings
        ((columns=${#cols[@]}))
	dbg "colnames:${cols[@]}"
	Xoutdelim=""
	Xoutstr=""
	for ((col=0; col < columns;col++))
        do
		colname="${cols[$col]}"
		#colname=${colname##*[0-9]}  	# remove numbers from begin of colname using pattern
		colname=${colname/~(E)^[0-9][0-9]*/}  # using regexp
		
		#colname=${colname// /_}  	# spaces to underline   using pattern
		#colname=${colname//~(E) /_}  	# spaces to underline  using regexp
		colname=${colname//~(E)[^[:alnum:]]/_}  	# non ascii to underline
		# colname not include " ; space  ...
		colnames[$col]="$colname"  # maybe acceptable variable name in shell
		dbg " $col: colname:$colname " 
		eval $colname=\"\"
		Xoutstr="$Xoutstr$Xoutdelim$colname"
                #printf " (%d:) %s" $((col+1)) "${cols[$col]}"
		#( ((output > 0 )) && printf "%s%(csv)q"  "$Xoutdelim" "${colnames[$col]}" 
		Xoutdelim="$flddelim"

        done
	(( output > 0 )) && print "$Xoutstr"

	# https://www.regular-expressions.info/posixbrackets.html
}

#################################################
clrvars()
{
	dbg "clrvars"
   	# init col variables
   	f=0
   	while (( f < columns ))
   	do
        	var="${colnames[$f]}"
        	((f+=1))
		[ "$var" = "" ] && continue # empty varname ?
		dbg "  clrvar:$var"
        	eval $var=\"\"
   	done
}

#################################################
setvars()
{
	# if 1st arg is 1, then also print out result = echo input
	Xprintout="$1"
	dbg "setvars:${#cols[@]} : ${cols[@]}"
	clrvars
	Xoutdelim=""
	Xoutstr=""
        for ((col=0; col < columns;col++))   # same number as in 1st line
        do
		Xvar="${colnames[$col]}"
		Xvalue="${cols[$col]}"
		eval $Xvar=\"'$Xvalue'\"
		Xstr=$( printf "%s%(csv)q"  "$Xoutdelim" "$Xvalue" )
		dbg "  setvar $((col+1)): $Xvar = ($Xvalue) - Xstr = ($Xstr) "
		Xoutstr="$Xoutstr$Xoutdelim$Xvalue"
		Xoutdelim="$flddelim"
        done 
	[ "$Xprintout" = "1" ] && print "$Xoutstr"
}

#################################################
showvars()
{
	# - show current values of column variables using printf csv-output - Nice
	#   Output is readable csv, handle " " strings, lf/cr in values, " char in value, ...
	# - https://tools.ietf.org/html/rfc4180 # Common Format and MIME Type for Comma-Separated Values (CSV) Files
	Xoutdelim=""
	Xoutstr=""
	Xoutstrcsv=""
        for ((col=0; col < columns;col++))   # same number as in 1st line
        do
		Xvar="${colnames[$col]}"
		eval Xvalue=\""\$$Xvar"\"
		dbg "col-$((col+1)): $Xvar <$Xvalue>"
		Xstr=$( printf "%s%(csv)q"  "$Xoutdelim" "$Xvalue" )
		Xoutstr="$Xoutstr$Xoutdelim$Xvalue"
		Xoutstrcsv="$Xoutstrcsv$Xstr"
		Xoutdelim="$flddelim"
        done 
	((output > 0 )) && print "$Xoutstr"
	((outputcsv > 0 )) && print "$Xoutstrcsv"
}

##############################################################################
before_line()
{
	:
}

##############################################################################
after_line()
{
	# now you can use variables which are same as column name
	# example if 1st colname is age then you can use current line value $age to handle 1st col value
	
	# demo - show values => cmd line option -o 1 OR -O 1
	showvars
}

#################################################
# MAIN
#################################################


while [ $# -gt 0 ]
do
	arg="$1"
	case "$arg" in
		-c) inputcsv="$2" ; shift ;;
		-d) debug="$2" ; shift ;;
		-f) flddelim="$2" ; shift ;;
		-O) outputcsv="$2" ; shift ;;
		-o) output="$2" ; shift ;;
		--) shift ; break ;;
		-*) usage ;;
		*) break ;;
	esac
	shift
done


# - make demo csv file
make_csv_file

while IFS="$flddelim" read -A -S cols
do
	((linecnt+=1))
	note=""
	# headerline process
        ((linecnt==1)) && note="Header" && initcols ${cols[@]} && continue

	# dataline
	# - clear and set variables
	dbg "$note $linecnt "

	# before line parse do something
	before_line

	# parse line
	setvars 

	# now we have setup variables, we can use those
	after_line

done < "$inputcsv"



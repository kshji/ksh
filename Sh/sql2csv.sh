#!/usr/local/bin/awsh
# sql2csv.sh
# Jukka Inkeri 2019-02-10
# sql2csv.sh -s sql/sqlfile.sql > csv/output.csv
#

PRG="$0"
BINDIR="${PRG%/*}"
[ "$PRG" = "$BINDIR" ] && BINDIR="." # - same dir as program
PRG="${PRG##*/}"


LC_ALL=fi_FI.utf8
export LC_ALL

mkdir -p tmp 2>/dev/null
chmod 1777 tmp 2>/dev/null

#################################################################
usage()
{
        echo "usage:$PRG -s sqlfile [ -e csv_erotinmerkki ] [ -c configfile ] " >&2
}

#################################################################
usagesql()
{
	echo "usage:pgsql [ -t ] input
		input is sql file name or - = stdin
		" >&2
		
}


#################################################################
parse_file()
{
 [ "$*" = "" ] && return
 [ ! -f "$1" ] && return
 eval echo  "\"$(cat $1 | sed 's+\"+\\"+g'   )\""
}

#################################################################
pgsql()
{
	# param is file or using stdin = file -
	# -t tell for pgsql trailer on/off
	# pgsql -t input.sql
	# echo "..." | pgsql -t -
 
	inf=tmp/$$.sql

	lippu=""
        [ "$1" = "-t" ] && flag=" -t " && shift
        sfile="$1"
	[ "$sfile" = "" ] && usagesql && exit 10
	[ "$sfile" != "-" ] && cat "$sfile" > $inf
	[ "$sfile" = "-" ] && cat  > $inf


	echo "  $inf"
	parse_file  $inf

	echo "
\a
\\f '$deli'
\pset footer off

	COPY (
        	$(parse_file $inf)
	) TO STDOUT WITH CSV HEADER DELIMITER '$deli' 
;
" | psql -h "$PGHOST" -p "$PGPORT" -U "$PGUSER"  -q $flag "$PGDATABASE"
        status=$?
	rm -f tmp/$inf 2>/dev/null
        return $status
}


####################################################
#MAIN
####################################################

sqlfile=""
deli=";"
header=""
batchfile="./batch.cfg"

while [ $# -gt 0 ]
do
        arg="$1"
        case "$arg" in
                -s) sqlfile="$2" ;;
                -c) batchfile="$2" ;;
                -e) deli="$2" ;;
                -h0) header="-t" ;;
                -t) header="-t" ;;
                --) shift; break ;;
        esac
        shift
done

[ "$sqlfile" = "" ] && usage && exit 2
[ ! -f "$sqlfile"  ] && echo "file not readable  $sqlfile">&2   && exit 3

[ ! -f "$batchfile"  ] && echo "need config $batchfile" >&2 && exit 4
. "$batchfile"

pgsql $header "$sqlfile"
exit $?

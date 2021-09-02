#!/usr/bin/ksh
# or bash or ...
# csv.sh
# dump Oracle table to the csv
# csv.sh -t TABLE
# csv.sh -t TABLE -d "|"
# Ver: Jukka Inkeri 2021-09-02
#


CONNECT='username/password@"(DESCRIPTION =(ADDRESS= (PROTOCOL = TCP)(HOST=xx.xx.xx.xx)(PORT = 1521)) (CONNECT_DATA=(SID = dbname)))"'

########################################################################
# - setup sqlplus for csv output
init_oracsv()
{
echo "
TITLE OFF
BTITLE OFF
REPHEADER OFF
SET NEWPAGE 0
SET SPACE 0
SET PAGESIZE 99999999
SET PAGESIZE 0
SET MARKUP HTML OFF
SET ECHO OFF
SET NEWPAGE 0
SET SPACE 0
SET FEEDBACK OFF
SET TRIMSPOOL ON
SET TAB OFF
SET LINESIZE 32000
SET HEADSEP OFF
----SET MARKUP HTML PREFORMAT ON
SET WRAP OFF
----SET MARKUP HTML PREFORMAT ON SPOOL ON
SET MARKUP HTML OFF
SET VERIFY OFF ;
SET SQLPROMPT ''
ALTER SESSION SET NLS_TIMESTAMP_FORMAT = 'YYYY-MM-DD HH:MI:SS.FF';
ALTER SESSION SET NLS_DATE_FORMAT = "YYYY-MM-DD";
SET HEADING ON
"
}

########################################################################
usage()
{
	echo "usage:$PRG -t tablename [ -d delimiter ]" >&2 && exit 1
}

########################################################################
# MAIN
########################################################################
tablename=""
deli="|"
while [ $# -gt 0 ]
do
	arg="$1"
	case "$arg" in
		-t|--table) tablename="$2" ; shift ;;
		-d|--delimiter) deli="$2" ; shift ;;
		-*) usage ; exit 2 ;;
		--) shift; break ;;
		*) break ;;
	esac
	shift
		
done
	
[ "$tablename" = "" ] && usage && exit 1

# csvout include csv and some other output 
mkdir -p csvout
# remove previous output
rm -f csvout/$tablename.* 2>/dev/null

# set values ...
init_oracsv > csvout/$tablename.sql

# create sql set
cat <<EOF >> csvout/$tablename.sql

-- build to file dynamic SELECT, fld same order as in the headerline
spool on
spool csvout/$tablename.sel
SET COLSEP ' '
SELECT 'SELECT','' FROM dual 
UNION ALL 
SELECT 
	CASE WHEN ROWNUM>1 THEN ',' END,
	column_name  
FROM all_tab_columns WHERE table_name = '$tablename' 
UNION ALL 
SELECT 'FROM $tablename',';' FROM dual ;
spool off;

spool on
SET COLSEP '$deli'
spool csvout/$tablename.tmp
-- columnnames 
SELECT LISTAGG(column_name,'$deli') WITHIN GROUP (ORDER BY ROWNUM) FROM 
(SELECT ROWNUM,column_name FROM all_tab_columns WHERE table_name= upper('$tablename') 
) 
;
-- datalines
--SELECT * FROM $tablename
@csvout/$tablename.sel

spool off;
/
exit;

EOF

# execute
sqlplus  "$CONNECT" @csvout/$tablename.sql > /dev/null


# trim cols
cat csvout/$tablename.tmp | sed -e "s/ *$deli/$deli/g" -e "s/$deli */$deli/g" -e "s/^ *//g" | sed -n -e "1p" -e '3,$p' > csvout/$tablename.csv

echo "Done: $tablename => csvout/$tablename.csv" >&2


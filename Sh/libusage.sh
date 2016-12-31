#!/usr/local/bin/awsh
#libusage.sh
# This include example to use lib.sh library function
#

[ ! -f ./lib.sh ] && echo "No lib.sh" >&2 && exit 1

. ./lib.sh

getfile  /etc/passwd
getdir  /usr/local/bin/awsh
getbase img.some.jpg .jpg
trimmed=$(trim "   xxx yyy     ")
echo "<$trimmed>"
replace "sourcestring" "ces" "xxxx"

field_first "123.456.789.abc"  "."
field_last "123.456.789.abc"  "."
field_notlast "123.456.789.abc"  "."
field_notfirst "123.456.789.abc"  "."
timestamp
echo ""
chr 65
echo ""
ord A
echo ""

##############################################################
# parse_file testing
tmpf=$$.tmp
echo '
This is example
getfile /etc/passwd will return $(getfile /etc/passwd).
$PWD - $HOME - $(date)
' > $tmpf

echo "My file:"
cat $tmpf

echo "Parse it:"
parse_file $tmpf

# rm tmp file
rm -f "$tmpf" 2>/dev/null


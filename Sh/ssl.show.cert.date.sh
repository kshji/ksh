#!/usr/local/bin/awsh
# some ksh
# ssl.show.cert.date.sh
# Jukka Inkeri 2021-02-05
# ssl.show.cert.date.sh  somedomain.dom:443
#
# License: https://github.com/kshji/ksh/blob/master/LICENSE.md under The Unlicense
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
        echo "usage:$PRG host:port " >&2
}

#################################################################
# MAIN
host="$1"

[ "$host" = "" ] && usage && exit 1

oifs="$IFS"
start=""
end=""
openssl s_client -showcerts -connect "$host" < /dev/null 2>/dev/null | openssl x509 -noout -dates | \
while IFS="=" read var value
do
	IFS="$oifs"
	case "$var" in
		notBefore|notbefore) start=$(printf "%(%Y-%m-%d %H%M%S)T" "$value" ) ;;
		notAfter|notafter) end=$(printf "%(%Y-%m-%d %H%M%S)T" "$value"  ) ;;
	esac
done
echo "$start $end"

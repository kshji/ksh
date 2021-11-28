#!/usr/local/bin/awsh
# ssl.check.period.validity.sh
# Jukka Inkeri 2021-11-28
#
# ssl.check.period.validity.sh  -h some.dom:443 -p 7 -e some.email@mydomain.some -s "Cert. exp. "
#
# License: https://github.com/kshji/ksh/blob/master/LICENSE.md under The Unlicense
# 
# If exist value is > 99 then need renew

PRG="$0"
BINDIR="${PRG%/*}"
[ "$PRG" = "$BINDIR" ] && BINDIR="." # - same dir as program
PRG="${PRG##*/}"


LC_ALL=fi_FI.utf8
export LC_ALL

mkdir -p tmp 2>/dev/null
chmod 1777 tmp 2>/dev/null

. ./setup

#################################################################
usage()
{
        echo "usage:$PRG -h host:port [ -p days_before_expiration  -e email -s subject ] " >&2
        echo "           default is 7 days before expiration  " >&2
}

#################################################################
# MAIN
host=""
email=""
dayleft=7  # how many days before ending make event/alert
subject="Certificate expiration notice for domain "

while [ $# -gt 0 ]
do
	arg="$1"
	case "$arg" in
		-h) host="$2"; shift ;;
		-p) dayleft="$2" ; shift ;;
		-s) subject="$2" ; shift ;;
		-e) email="$2" ; shift ;;
		--) shift; break ;;
		-*) usage ; exit 1 ;;
		*) break ;;
	esac
	shift
		
done

[ "$host" = "" ] && usage && exit 1

oifs="$IFS"
start=""
epocstart=0
epocend=0
today=$(printf "%(%Y-%m-%d %H%M%S)T" now )
epoctoday=$(printf "%(%#)T" now )
((day=24*60*60))

openssl s_client -showcerts -connect "$host" < /dev/null 2>/dev/null | openssl x509 -noout -dates | \
while IFS="=" read var value
do
	IFS="$oifs"
	case "$var" in
		notBefore|notbefore) start=$(printf "%(%Y-%m-%d %H%M%S)T" "$value" ) 
				epocstart=$(printf "%(%#)T" "$value" )
				;;
		notAfter|notafter) end=$(printf "%(%Y-%m-%d %H%M%S)T" "$value"  ) 
				epocend=$(printf "%(%#)T" "$value" )
				;;
	esac
done

#echo "$start $end"

((daycap = epocend/day-epoctoday/day))
(( daycap> dayleft )) && echo "ok $end - $daycap" && exit 0

echo "renew $end - $daycap"
echo "Not so much time to renew certificate!" >&2
echo "Certificate is valid to $end" >&2


# if no email address then exit
[ "$email" = "" ] && exit 100

mkdir -p tmp 2>/dev/null
chmod 1777 tmp 2>/dev/null

# - make email alert
tf="$PWD/tmp/$$.tmp"
cat <<EOF > $tf
Certificate expiration notice for domain $host 
last date: $end

EOF

# Send email example using Mutt via Gmail app apiuserkey

Mutt/sendemail.sh -D gmail.com -u my.user@gmail.com -r Mutt/gmail.muttrc -t "$email" -s "$subject $host $(date)" -m "$tf" -f my.user@gmail.com  -p MYAPPKEY

rm -f "$tf" 2>/dev/null

exit 101

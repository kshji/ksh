#!/usr/local/bin/awsh
# sendmail.sh
# https://github.com/kshji/ksh/tree/master/Sh/Mutt
# Jukka Inkeri https://awot.fi
# Ver:2020-12-20
#
# Tested also with
#   -Google gmail smtp using app password
#   -Office 365 smtp using app password and older smtp auth
#
# send email using mutt
#  - mutt can handle auth login
#
# sendmail.sh -D mydomain.fi -u useraccount -p app_password -m message.latin1.txt -r example.muttrc -c cc.person@email.xx \
#             -t to.person@gmail.com -f from.user@mudomain.fi -s "Subject text" -a example.pdf -p app_password -d 1
#
PRG="$0"
BINDIR="${PRG%/*}"
[ "$PRG" = "$BINDIR" ] && BINDIR="." # - same dir as program
PRG="${PRG##*/}"

mkdir -p tmp 2>/dev/null
chmod 1777 tmp 2>/dev/null
# -b = bcc
# -c = cc
# -F muttrc $HOME/.muttrc=default
# 

######################################################################
usage()
{
	echo "usage:$PRG -r muttrc -D domain -u useraccount -t to_email -f from_email  -s Subject -m message_file [ -a attachmentfile -b bcc_mailto -c cc_mailto ]" >&2
}

######################################################################
parse_file()
{
 [ "$*" = "" ] && return
 [ ! -f "$1" ] && return
 eval echo  "\"$(cat $1 | sed 's+\"+\\"+g'   )\""
}

######################################################################
# MAIN
######################################################################
mailto=""
sender=""
useraccount=""
account=""
attachment=""
subject=""
option=""
bcc=""
cc=""
muttrc=""
message=""
debug=0
domain=""
attachments=""
# - EN: set SmtpAuthPassword using env variable SMTPAUTHPASS or ask from user
# - FI: voit antaa SMTPAUTHPASS muuttujassa authpasswd tai kysyy tassa kohtaa jattamatta muistiin
# - Gmail smtp not need SMTPAUTHPASS, use application password, also Office 365 is possible to use application password
authpasswd="$SMTPAUTHPASS"

while [ $# -gt 0 ]
do
	arg="$1"
	case "$arg" in
		-t) mailto="$2"; shift ;;
		-b) bcc="-b $2"; shift ;;
		-c) cc="-c $2"; shift ;;
		-f) sender="$2" ; shift ;;
		-m) message="$2" ; shift ;;
		#-a) attachment="$2" ; option="-a" ; shift ;;
		-a) attachments="$attachments -a $2" ; shift ;;
		-r) muttrc="$2" ; shift ;;
		-p) authpasswd="$2" ; shift ;;
		-s) subject="$2" ; shift ;;
		-D) domain="$2" ; shift ;;
		-d) debug="$2" ; shift ;;
		-u) useraccount="$2" ; shift ;;
		-*) usage; exit 2 ;; 
	esac
	shift
done

[ "$mailto" = "" ] && usage && exit 3
[ "$sender" = "" ] && usage && exit 4
[ "$subject" = "" ] && usage && exit 5
[ "$muttrc" = "" ] && usage && exit 5
[ "$message" = "" ] && usage && exit 5
[ "$domain" = "" ] && usage && exit 6
[ "$useraccount" = "" ] && usage && exit 7

if [ "$authpasswd" = "" ] ; then
	printf "user $useraccount password:" 
	stty -echo
	read authpasswd
	stty echo
	echo 
	echo "sending ..."
fi

# - which muttrc to use, 
tmpf="tmp/$$.rc"
parse_file "$muttrc" > "$tmpf"

# - use temporary muttrc
# Examlpe to use mutt
# - no attachments
# mutt -F $tmpf -s "Sub 99015361, Cust 3610" -b "some.bcc@domain.eu" "$mailto" <<EOF
# Some ...
# EOF
# with attachnents
# mutt -F $tmpf -s "$subject" -c "cc.joku@domain.joku" -b "joku.bcc@domain.eu" "$mailto" -a mallilasku.pdf -a attachment2.pdf <<EOF
# Some ...
# EOF

# send mail
mutt -F $tmpf -s "$subject" $bcc $cc  "$mailto" "$option" $attachment $attachments <<EOF

$(parse_file $message)

EOF

# - remove temporary muttrc
((debug>0)) && cat "$tmpf"
rm -f "$tmpf"     2>/dev/null


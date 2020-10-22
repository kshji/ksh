#!/usr/local/bin/awsh
# laheta.sh
# lahettaa spostia mutt-ohjlmella, joka osaa auth kirjautumisen smtp palvelimelle
#
# laheta.sh -m lasku.latin1.txt -r malli.muttrc -c jukka@inkeri.eu -t jukka.inkeri@gmail.com -f jukka.inkeri@bromangroup.fi -s "Otsikko3" -a mallilasku.pdf -d 1
#
PRG="$0"

. /.www/textfile

mkdir -p tmp
chmod 1777 tmp 2>/dev/null
# -b = bcc
# -c = cc
# -F muttrc $HOME/.muttrc=default
# 

######################################################################
usage()
{
	echo "usage:$PRG -r muttrc -t to_email -f from_email  -s Subject -m message_file [ -a attachmentfile -b bcc_sposti -c cc_sposti ]" >&2
}


######################################################################
# MAIN
######################################################################
sposti=""
lahettaja=""
liite=""
otsikko=""
optio=""
bcc=""
cc=""
muttrc=""
viesti=""
debug=0
liitteet=""

while [ $# -gt 0 ]
do
	arg="$1"
	case "$arg" in
		-t) sposti="$2"; shift ;;
		-b) bcc="-b $2"; shift ;;
		-c) cc="-c $2"; shift ;;
		-f) lahettaja="$2" ; shift ;;
		-m) viesti="$2" ; shift ;;
		-a) liite="$2" ; optio="-a" ; shift ;;
		-l) liitteet="$liitteet -a $2" ; shift ;;
		-r) muttrc="$2" ; shift ;;
		-s) otsikko="$2" ; shift ;;
		-d) debug="$2" ; shift ;;
		-*) usage; exit 2 ;; 
	esac
	shift
done

[ "$sposti" = "" ] && usage && exit 3
[ "$lahettaja" = "" ] && usage && exit 4
[ "$otsikko" = "" ] && usage && exit 5
[ "$muttrc" = "" ] && usage && exit 5
[ "$viesti" = "" ] && usage && exit 5

# - voit antaa salasanan muuttujassa SALA tai kysyy tassa kohtaa jattamatta muistiin
sala=$SALA
if [ "$sala" = "" ] ; then
	printf "Salasana:" 
	stty -echo
	read sala
	stty echo
	echo 
	echo "lahetys ..."
fi

# - mika muutrc tempate kaytossa, laventaa siihen tuon salasanan
tmpf="tmp/$$.rc"
parse_file "$muttrc" > "$tmpf"

# - kaytetaan valiaikaista muttrc konffausta
# - ei liitetta
#mutt -F $tmpf -s "Laskumme 99015361, asiakas 3610" -b "joku.bcc@domain.eu" "$sposti" <<EOF
main
# liitteen kera
#mutt -F $tmpf -s "$otsikko" -c "cc.joku@domain.joku" -b "joku.bcc@domain.eu" "$sposti" -l mallilasku.pdf -l liite2.pdf <<EOF

# kaytetaan annettuja arvoja ...
mutt -F $tmpf -s "$otsikko" $bcc $cc  "$sposti" "$optio" $liite $liitteet <<EOF

$(parse_file $viesti)

EOF

# - poistetaan valiainen muttrc
((debug>0)) && cat "$tmpf"
rm -f "$tmpf"     2>/dev/null

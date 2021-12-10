#!/usr/local/bin/awsh
# pankkivirtuaaliviivakoodi.sh
# virtuaaliviivakoodi maksuviite Suomessa
# https://www.finanssiala.fi/wp-content/uploads/2021/03/Pankkiviivakoodi-opas.pdf
#  ./pankkivirtuaaliviivakoodi.sh -v 1119 -e 211129 -s 24000 -t "FI19 1999 9999 9999 99" -d 1
#  = 419199999999999990002400000000000000000000001119211129
# Voit tarkistaa
# https://www.laskupiste.fi/virtuaaliviivakoodin-luonti/

PRG="$0"
BINDIR="${PRG%/*}"
[ "$PRG" = "$BINDIR" ] && BINDIR="." # - same dir as program
PRG="${PRG##*/}"

###################################################################
usage()
{
	echo "usage:$PRG -t tilinro -v viite -e vvkkpp -s summa [ -d 0|1 ] " >&2
	echo "           $*" >&2
}

###################################################################
dbg()
{
	((debug<0)) && return 0
	echo "$*" >&2
}

###################################################################
chr()
{
    printf \\$(($1/64*100+$1%64/8*10+$1%8))
}

###################################################################
tarkiste_128c()
{
        Xtxt="$1"

        Xpit=${#txt}
        dbg "txt:$Xtxt pit:$Xpit" 
        i=0

        Xmerkisto=105  	# C
        #FNC1=102  	# FNC1 merkki
	XSTOP=105	# loppumerkki STOP 105 = sama kuin merkisto
        Xpaino=1
        ((Xsumma=Xmerkisto + Xmerkisto*Xpaino))
        Xpaino=2
        while ((Xi<Xpit))
        do
                Xm=${txt:$Xi:2}
                ((Xcode=Xm))
                ((Xi=Xi+2))
                ((Xsumma=Xsumma+Xpaino*Xm))
                ((Xpaino+=1))
        done
        ((Xtarkiste=Xsumma%103))
	echo "$Xtarkiste"
	
}



###################################################################
# MAIN
###################################################################

debug=0
# module103 laskenta
tarkiste=0
paino=0
tulo=0


versio=4  	# 1
tilinro=""	# 16
euro=0		# 6
sentti=00	# 2
varalla=000	# 3
viitenumero=""  # 20
erapvm=""	# 6 vvkkpp
tarkiste2=""	# 1
loppumerkki=""	# 1
		# 54
merkisto=105	# 128C
loppu=105	# STOP = sama kuin alkumerkki

while [ $# -gt 0 ]
do
	arg="$1"
	case "$arg" in
		-d) debug="$2"; shift ;;
		-v) viite="$2"; shift ;;
		-e) erapvm="$2"; shift ;;
		-s) summa="$2"; shift ;;
		-t) tilinro="$2"; shift ;;
		-*) usage; exit 1 ;;
		*) break ;;
	esac
	shift
done

[ "$viite" = "" ] && usage "viite puuttuu" && exit 10
[ "$erapvm" = "" ] && usage "erapvm puuttuu" && exit 10
[ "$tilinro" = "" ] && usage "tilinro puuttuu" && exit 10
[ "$summa" = "" ] && usage "summa puuttuu" && exit 10
summa=${summa//\./} 			# remove .
summa=${summa//,/} 			# remove ,
summa=$(printf "%08d" $summa)   	# etunollat
summalen=${#summa}
((eurolen=summalen-2))
euro=${summa:0:$eurolen}
((eurolen+1))
sentti=${summa:$eurolen:2}
tilinro=${tilinro// /}			# tyhjeet
tilinro=${tilinro/FI/}			# FI pois
viite=${viite// /}			# tyhjeet
viite=$(printf "%020d" $viite)   	# etunollat

str="$versio$tilinro$euro$sentti$varalla$viite$erapvm"
dbg "summa:$summa euro:$euro sentti:$sentti erapvm:$erapvm viite:$viite"
dbg "str $str"

tarkiste2=$(tarkiste_128c $str)
virtuaaliviivakoodi="$str"
str128c="$(chr $merkisto)$virtuaaliviivakoodi$tarkiste2$(chr $loppu)"
# command barcode or JSBarcode is better to make code128 barcode using value virtuaaliviivakoodi
echo "$virtuaaliviivakoodi"


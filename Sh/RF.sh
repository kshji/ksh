#/usr/local/bin/awsh
# RF.sh
# - bash compatible
# RF creditor conversion and RF checking
#
# https://github.com/kshji
# License, read https://github.com/kshji/ksh
#
# Karjalan ATK-Awot Oy 2020 Jukka Inkeri
# 2020-04-16
# 
# RF - Reference number - kansainvalinen viitenumero - ISO-11649 standard
#
# Kansainvalinen viitenumero RF 
# - https://www.finanssiala.fi/maksujenvalitys/dokumentit/kansainvalisen_viitteen_rakenneohje.pdf
#
# Javascript https://github.com/EDumdum/iso-11649-js
# Php,  https://github.com/kmukku/php-iso11649/blob/master/src/phpIso11649.php
# Java, https://github.com/terokallio/reference-numbers/blob/master/src/main/java/com/terokallio/referencenumbers/RFCreditorReference.java
# Online testing ex. Nordea testing both: international N/Y   = Create Finnish Payment Ref or International RF 
#    https://pankki.nordea.fi/en/corporate-customers/payments/invoicing-and-payments/reference-number-calculator.flex
#    https://www.nordea.fi/en/business/our-services/accounts-payments/reference-numbers-calculator.html


# array which include conversion chars to numbers 
typeset -A chars
chars["A"]=10
chars["B"]=11 
chars["C"]=12 
chars["D"]=13 
chars["E"]=14 
chars["F"]=15 
chars["G"]=16 
chars["H"]=17 
chars["I"]=18 
chars["J"]=19 
chars["K"]=20 
chars["L"]=21 
chars["M"]=22 
chars["N"]=23 
chars["O"]=24 
chars["P"]=25 
chars["Q"]=26 
chars["R"]=27 
chars["S"]=28 
chars["T"]=29 
chars["U"]=30 
chars["V"]=31 
chars["W"]=32 
chars["X"]=33 
chars["Y"]=34 
chars["Z"]=35


############################################################
dbg()
{
	((debug < 1 )) && return
	echo "dbg: $*" >&2
}

############################################################
conv2number()
{
	# convert chars to numbers and number=number
	Xstring="$*"
	# remove spaces
        Xstring=${Xstring// /}
	# remove start 0's
        while [ "${Xstring:0:1}" = "0" ]
        do
                Xstring=${Xstring:1}
        done

	Xsource=$Xstring
	dbg "     XSource:$Xsource"
	Xresult=""
	while (( ${#Xsource} > 0 ))
        do
                # take 1st char
                Xchr=${Xsource:0:1}
                Xconvert2nr=${chars[$Xchr]}
                [ "$Xconvert2nr" = "" ] && Xconvert2nr=$Xchr # it was already number
		dbg "        Xchr:$Xchr Xconvert2nr:$Xconvert2nr Xsource:$Xsource" 
                # remove 1st char
                Xsource=${Xsource:1}
                Xresult="${Xresult}$Xconvert2nr"
	dbg "          Xresult:$Xresult"
        done
	echo "$Xresult"

}

############################################################
convert_731_to_RF()
{
	typeset -u Xbase
	#Xbase  finnish creditor, 731-checksum
	#Xbase testing  2348236
	#Refnumber is any ref, not only Finnish Payment Ref
	Xbase="$*" 
	# remove spaces
	Xbase=${Xbase// /}
	# remove start 0's
	while [ "${Xbase:0:1}" = "0" ]
	do
		Xbase=${Xbase:1}
	done
	X731="$Xbase"
	dbg "X731:$X731" 
	# add 2715 and 00 to end
	#Xbase=${Xbase}271500"   # rf00
	Xbase="${Xbase}RF00" 
	Xbasenr=$(conv2number "$Xbase" )
	dbg "Xbasenr:$Xbasenr"
	# test 2348236 Xbase mod97 is 65
	#((mod97=Xbasenr%97))
	#mod97=$(echo "$Xbasenr % 97" | bc)
	mod97=$(bc <<< "$Xbasenr % 97" )
	dbg "mod97:$mod97" 
	(( Xcheck=98-mod97 ))
	# 2 number is checksum
	(( Xcheck < 10 )) && Xcheck="0$Xcheck"  
	
	dbg "Xcheck:$Xcheck" 
	RF="RF${Xcheck}${X731}"
	echo "$RF"
	
}

############################################################
check_RF()
{
	typeset -u Xbase
	Xbase="$*"
	# remove spaces
        Xbase=${Xbase// /}
	Xend=${Xbase:0:4}
	Xstart=${Xbase:4}
	Xstr="${Xstart}${Xend}" # value + string RFnn

	# convert it to the number
	Xres=$(conv2number "$Xstr" )
	dbg "Xstart:$Xstart Xend:$Xend Xsource:$Xsource Xstr:$Xstr Xres:$Xres"
	dbg "Xres:$Xres" 
	#((mod97 = Xres % 97 ))  # long number overflow 
	mod97=$(echo "$Xres % 97" | bc)
	dbg "mod97: $mod97" 
	((mod97 == 1 )) && return 0  # ok
	return 1
}

############################################################
usage()
{
   echo "
usage:$PRG  [-d 0|1 ] -m ref | -c RF
      -m ref  Make RF
      -c RF   Check RF
      -d 0|1  Debug on off, default off, 1st option on the cmdline !!!
">&2

}

############################################################
# MAIN
############################################################
# suomalainen pankkiviite - finnish payment ref.number 2348236
# You can use this also convert any ref.numbers to the RF format
# Ex. Finnish Payment Ref.

[ "$1" = "" ] && usage && exit 4
debug=0

while [ $# -gt 0 ]
do
        arg="$1"
        case "$arg" in
                -m) convert_731_to_RF "$2" ; exit ;;
                -c) check_RF "$2"
                        status=$?
                        ((status == 0 )) && echo "RF OK"
                        ((status != 0 )) && echo "RF err"
                        exit $status
                        ;;
		-d) debug="$2" ; shift ;;
                -t*) break ;;  # test loops
                -*) usage; exit 2 ;;
                *) usage ; exit 3
        esac
        shift
done

# - testing ...

echo "
____________________________________________________________________________
Make RF
"
# finnish ref.number (viitenumero) examles: 2348236 2228 520161027399702
for ref731 in 2228 2348236 " 234 8236" "0000 0234 8236" 520161027399702 "TU06FX" "X2HU4TC28XTYLHASYWT91"
do
	echo "____:$ref731 ____________________"
	convert_731_to_RF "$ref731"
done

echo "
____________________________________________________________________________
Check RF
"
for rf in  RF852228  RF712348231  RF332348236 "RF71 2348 231" "RF720HYA6" RF06520161027399702 "RF96TU06FX" "RF19GAX8WS5JYOOUJ87" "RF14X2HU4TC28XTYLHASYWT91"
do
	echo "____RF:$rf ____________________"
	check_RF "$rf"
	status=$?
	((status == 0 )) && echo "RF OK"
	((status != 0 )) && echo "RF err"
done

exit
 # some test cases
520161027399702 => RF06520161027399702
TU06FX => RF96TU06FX
X2HU4TC28XTYLHASYWT91 => RF14X2HU4TC28XTYLHASYWT91

RF720HYA6 ok
RF14X2HU4TC28XTYLHASYWT91 ok
RF96TU06FX  ok
RF19GAX8WS5JYOOUJ87 not ok

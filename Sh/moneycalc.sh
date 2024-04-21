#!/usr/local/bin/awsh
# - set your shell to the previous line: bash, ksh, ... my awsh = ksh93
# moneycalc.sh
# ver 2024-04-20
# (c) Jukka Inkeri
# https://github.com/kshji
# https://github.com/kshji/ksh/blob/master/LICENSE.md
# https://github.com/kshji/ksh/blob/master/Sh/moneycalc.sh 
#
# This package contains calculation models on how money and related calculations are done using 
# integer rather than floating point calculations.
# Risk? Because floating point does not provide the right answers in all situations. 
# 
#
# More
#  https://en.wikipedia.org/wiki/Floating-point_error_mitigation
# 
# Round function is generic, you can use it any rounding level, look examples
#
# Test without debug output
#    moneycalc.sh -t
# Test with debug output
#    moneycalc.sh -d -t
# Example
#     round using 900 = ex. 900 s = 15 min
#     	moneycalc.sh -m 900 1600 # 1600 s
#     	1800 # half hour
#
#       moneycalc.sh -m 900 4260 # 3600 + 660 s = 1h 11 min => 4500 s = 1 h 15 min
#       4500  # 1 h 15 min
#
#     round money 12.54 rounding nearest .10
#	moneycalc.sh -m 10 1255
#       1260
#	moneycalc.sh -m 5 1257
#       1255
#	moneycalc.sh -m 5 1258
#       1260
#
#     round money 12.54 rounding nearest integer
#  	moneycalc.sh -m 100 1255
#       1300
#
#     test using default 3 decimal = multiplier 1000
#	moneycalc.sh -t
#
#     test using default 2 decimal = multiplier 100
#	moneycalc.sh -m 100 -t
#
#     VAT price calculation
#	calc_vat_price 100.98 24.5  
#	125.72
#

multiplier=1000 # use 3 decimals
debug=0
#((maxint=((2**63)-1) )) # max in bash, ksh has no limit
#[ "$KSH_VERSION" != "" ]  && ((maxint=((2*100)) ))

#############################################################################
dbg()
{
  	((debug<1)) && return
  	echo "$*" >&2
}

#############################################################################
des2int() 
{
    	Xdes=$1

    	if [ "$KSH_VERSION" != "" ] ; then # builtin floatpoint calc
		(( Xresdes=Xdes*multiplier ))
	else # bash or ...
		Xresdes=$(bc <<<"$Xdes*$multiplier")	
	fi
    	Xresdes=$(printf "%.0f\n" $Xresdes)
	dbg "  des2int $Xdes = $Xresdes"
    	echo "$Xresdes"
}

#############################################################################
int2des()
{
	Xint=$1
	Xmlen=${#multiplier}
	Xintlen=${#Xint}
	((Xnumlen=Xintlen-Xmlen+1))
	Xnumber=${Xint:0:Xnumlen}
	Xdespart=${Xint:$Xnumlen}
	dbg "   int2des $Xint = $Xnumber.$Xdespart"
	echo "$Xnumber.$Xdespart"
}

#############################################################################
round()
{
	# any round is possible
	# ex. time  round 900 s = 15 mins
	# arg1 7642
	# arg2 900
    	Xsrc="$1"
    	Xint="$1"
	# rounding accuracy
        Xacc="$2"
	Xusedef=0
debug=0
	[ "$KSH_VERSION" != "" ] && typeset int Xint Xacc Xround multiplier
	[ "$Xacc" = "" ] && ((Xacc=multiplier/100)) && Xusedef=1
dbg "round    Xacc:$Xacc"

    	(( Xusedef > 0 )) && Xint=$(des2int $Xsrc) 
  	((Xround=Xacc/2))
dbg "round    Xround:$Xround"
  	((Xcnt=(Xint+Xround)/Xacc))
dbg "round    Xcnt:$Xcnt"
  	((Xresrnd=Xcnt*Xacc))
dbg "round    Xresrnd:$Xresrnd"
	# back to source format?
	((Xusedef > 0 )) && Xresrnd=$(int2des $Xresrnd)
	dbg "  round $Xsrc $Xacc = $Xresrnd"
debug=0
  	echo "$Xresrnd"
}

#############################################################################
floor()
{
	# any round is possible
	# ex. time  round 900 s = 15 mins
	# arg1 7642
	# arg2 900
    	Xsrc="$1"
    	Xint="$1"
	# rounding accuracy
        Xacc="$2"
	Xusedef=0
debug=0
	[ "$KSH_VERSION" != "" ] && typeset int Xint Xacc Xround multiplier
	[ "$Xacc" = "" ] && ((Xacc=multiplier/100)) && Xusedef=1
    	(( Xusedef > 0 )) && Xint=$(des2int $Xsrc) 
  	((Xround=Xacc/2))
dbg "floor    Xround:$Xround"
  	((Xcnt=(Xint)/Xacc))
	
dbg "floor    Xcnt:$Xcnt"
  	((Xresrnd=Xcnt*Xacc))
dbg "floor    Xresrnd:$Xresrnd"
	# back to source format?
	((Xusedef > 0 )) && Xresrnd=$(int2des $Xresrnd)
	dbg "  floor $Xsrc $Xacc = $Xresrnd"
debug=0
  	echo "$Xresrnd"
}

#############################################################################
calc_vat_price()
{
	Xprice="$1"
	Xvatpros="$2"
	
	dbg "-calc_vat_price" 
	hundred=100
	[ "$KSH_VERSION" != "" ] && typeset int Xvat Xpriceint multiplier hundred Xpricevat
	(( Xvat=multiplier + $(( $(des2int $Xvatpros)/hundred ))  ))
	Xpriceint=$(des2int $Xprice)
	((Xpricevat=Xpriceint*Xvat/multiplier))
	Xpricevatdes=$( int2des $((Xpricevatdes=$(round $Xpricevat 10)  )) )
	#Xpricevatdes=$( printf "%.2f\n" $(int2des $Xpricevat ))  # this work in ksh and bash - include round
	dbg "  calc_vat_price $Xprice $Xvatpros = $Xpricevatdes"
	printf "%0.2f\n" "$Xpricevatdes"
}
#############################################################################
examples()
{

	#price=100.00
	#vat=1245
	#read priceint<<<$(des2int price)
	#((pricevat=price*vat))
	#echo "$price $vat $(int2des $pricevat)"
	calc_vat_price 100.00 24.5  # 124.50
	calc_vat_price 200.00 24.5  # 249.00
	calc_vat_price 100.98 24.5  # 125.72
	calc_vat_price  99.99 24.5  # 124.49
	calc_vat_price   0.10 24.5  # 0.12
	calc_vat_price   0.09 24.5  # 0.11
	calc_vat_price   0.11 24.5  # 0.14
	calc_vat_price 30000.00 24.5  # 37350.00
	# max value is about:
	calc_vat_price 7000000000000.00 24.5  #  8715000000000.00
}


#############################################################################
testset2()
{
	round 1.0300 
	round 1.0350 
	round 1.0360 
	round 1035 10
	round 1034 5 # 1035
	round 1036 5 # 1035
	round 1038 5 # 1040
	echo "________________"
	floor 1.0300 
	floor 1.0310 
	floor 1.0301 
	floor 1.0350 
	floor 1.0360 
	floor 1.0400 
	floor 1036 5 # 1035
	floor 1034 5 # 1030
	floor 1035 10
	echo "_______________"
	floor 1030 5
	floor 1031 5
	floor 1034 5
	floor 1035 5
	floor 1036 5
	floor 1039 5
	echo "________________"
	round 1010 5
	round 1012 5
	round 1013 5
	round 1015 5
	round 1016 5
	round 1019 5
	round 1020 5
	round 4400 900
	echo "________________"
	floor 1010 5
	floor 1012 5
	floor 1013 5
	floor 1015 5
	floor 1016 5
	floor 1019 5
	floor 1020 5
	floor 4400 900
	floor 4600 900
	floor 3700 900
	
}

#############################################################################
testset()
{
	des2int 1
	des2int 1.2 # 
	des2int 1.23
	des2int 1.234
	des2int 1.2345
	des2int 91.2345
	int2des 1000
	int2des 1200
	int2des 1230
	int2des 1234
	int2des 91234
	echo "*Round"
	# use default = multiplier / 100
	round 1 	# 1.000
	round 1.5   	# 1.500
	round 1.55 	# 1.550
	round 1.555	# 1.560 
	round 1.5555	# 1.560 
	round 1.55555   # 1.560
	round 1.05555   # 1.060
	round 1.00555   # 1.010
	round 1.00055	# 1.000 
	round 1.00005   # 1.000
	round 12.65    	# 12.650
	round 91.2345 	# 91.240
	round 912345 10 # 912350
	echo "*Floor"
        floor 2.0250 10
        floor 2.0235 10
        floor 2.0535 10
        floor 2.0435 10
	echo "*Round"
	# 12.65 neareast .10
	round 1265 10  # 1270
	# 12.65 neareast integer
	round 1265 100 # 1300
	round 61 60
	round 59 60
	round 3601 60	# 3600
	round 3599 60	# 3600
	round 3571 60	# 3600
	round 3570 60	# 3600
	round 3569 60 	# 3540
	round 3540 60 	# 3540
	round 3539 60 	# 3540
	#       4260 # 3600 + 660 s = 1h 11 min => 4500 s = 1 h 15 min
	#       4500  # 1 h 15 min
	round 4260 900 # 4500
}

#############################################################################
#  MAIN
#############################################################################

LC_NUMERIC=C
while [ $# -gt 0 ]
do
	arg="$1"
	case "$arg" in
		-d) debug=1 ;;
		-m) multiplier=$2; shift ;;
		-t) testset ;;
		-2) testset2 ;;
		-e) examples ;;
		*) break ;;
	esac
	shift
done


# parse values
while [ $# -gt 0 ]
do
	val=$1
	shift
	round "$val" $multiplier
done



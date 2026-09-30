#!/usr/local/bin/awsh
# - set your shell to the previous line: bash, ksh, ... my awsh = ksh93
# moneycalc2.sh
# ver 2026-09-30
# (c) Jukka Inkeri
# https://github.com/kshji
# https://github.com/kshji/ksh/blob/master/LICENSE.md
# https://github.com/kshji/ksh/blob/master/Sh/moneycalc2.sh
#
# This package contains calculation models on how money and related calculations are done using
# integer rather than floating point calculations.
# Risk? Because floating point does not provide the right answers in all situations.
#
#
# More
#  https://en.wikipedia.org/wiki/Floating-point_error_mitigation
#  https://floating-point-gui.de/languages
#  https://docs.oracle.com/cd/E19957-01/806-3568/ncg_goldberg.html
#
# Round function is generic, you can use it any rounding level, look examples
#
# Test without debug output
#    	moneycalc2.sh -t
# using examples:
# 	moneycalc2.sh round 3540 900
# 	moneycalc2.sh round 101951 50
# 
#################################
# Look also moneycalc.sh
#################################
#
# Fixed-point monetary calculations using pure integer arithmetic.
#
# Base scale: Tenths of a cent (0.001 EUR / 1 milli-euro)
#   1 Euro         = 1000 units
#   10 Cents       = 100 units
#   5 Cents (cash) = 50 units
#   1 Cent         = 10 units
#
# FI:
#   Rahalaskenta kokonaisluvuilla - ei missään nimessä liukulukuina, jollei halua pyöristysvirheitä
#
#   1 euro = 1 000 yksikköä (sentin kymmenesosaa)
#   1 sentti = 10 yksikköä
#   5 senttiä = 50 yksikköä
#   50 senttiä = 500 yksikköä
#
#
# --- TRUNC ---
# Truncates a monetary value towards zero by a given step.
#
# Arguments:
#   $1 - Amount in tenths of a cent (e.g., 100.85 EUR = 100850)
#   $2 - Step / Precision (optional, defaults to 1000 = whole euros)
#
# Examples:
#   _trunc 101954        => 101000  (truncates cents to full euros)
#   _trunc 101954 100    => 101900
#   _trunc -101954 100   => -101900
#
# FIN: Katkaisee luvun kohti nollaa annettuun tarkkuuteen.
# Jos tarkkuutta ei anneta, oletus on 1000 (täydet eurot).

function _trunc {
    typeset -i val=$1
    # default 1000
    typeset -i step=${2:-1000}

    print -- "$(( (val / step) * step ))"
}

# --- FLOOR ---
#
# Rounds a monetary value down towards negative infinity by a given step.
#
# Arguments:
#   $1 - Amount in tenths of a cent
#   $2 - Step / Precision (optional, defaults to 1000 = whole euros)
#
# Examples:
#   _floor 101954 100    => 101900
#   _floor -101954 100   => -102000 (rounds down away from zero)
#
# FI:Pyöristää aina alaspäin (kohti miinus ääretöntä).
#    Oletustarkkuus 1000 (eurot), ellei toisin anneta.
function _floor {
    typeset -i val=$1
    typeset -i step=${2:-1000}
    typeset -i rem=$(( val % step ))

    # Negative values with a remainder need an extra step subtraction
    # FI: Negatiivisilla luvuilla jakojäännös vaatii vähennyksen alaspäin mentäessä
    if (( rem < 0 )); then
        print -- "$(( ((val / step) - 1) * step ))"
    else
        print -- "$(( (val / step) * step ))"
    fi
}

# --- ROUND ---
#
# Rounds to the nearest multiple of step using standard commercial rounding
# (half away from zero).
#
# Arguments:
#   $1 - Amount in tenths of a cent
#   $2 - Step / Precision (optional, defaults to 50 = 5 cents cash rounding)
#
# Examples:
#   _round 101954 50     => 101950  (rounds to nearest 5 cents)
#   _round 101954 500    => 102000  (rounds to nearest 50 cents)
#   _round 101954 1000   => 102000  (rounds to nearest 1 euro)
#   _round -101954 50    => -101950
# ------------------------------------------------------------------------------
#
# FI: Pyöristää lähimpään (puolikas aina nollasta poispäin, ns. kaupallinen pyöristys).
#     Oletustarkkuus 50 (5 senttiä / Suomen käteissääntö).
function _round {
    typeset -i val=$1
    typeset -i step=${2:-50}
    typeset -i half=$(( step / 2 ))

    if (( val >= 0 )); then
        print -- "$(( ((val + half) / step) * step ))"
    else
        print -- "$(( ((val - half) / step) * step ))"
    fi
}

# --- CEIL ---
# 
# ceil (ceiling)
#
# Rounds a monetary value up towards positive infinity by a given step.
#
# Arguments:
#   $1 - Amount in tenths of a cent
#   $2 - Step / Precision (optional, defaults to 1000 = whole euros)
#
# Examples:
#   _ceil 101951 1000   => 102000
#   _ceil 101920 1000   => 102000
#   _ceil 101001 1000   => 102000  (any fraction pushes it up)
#   _ceil 101000 1000   => 101000  (exact match stays unchanged)
#   _ceil -101951 1000  => -101000 (towards positive infinity)
# ------------------------------------------------------------------------------
#
function _ceil {
    typeset -i val=$1
    typeset -i step=${2:-1000}
    typeset -i rem=$(( val % step ))

    if (( rem > 0 )); then
        print -- "$(( ((val / step) + 1) * step ))"
    else
        print -- "$(( (val / step) * step ))"
    fi
}

# --- FORMAT EURO ---
function format_euro {
    typeset -i val=$1
    typeset sign=""
    if (( val < 0 )); then
        sign="-"
        val=$(( -val ))
    fi

    typeset -i eur=$(( val / 1000 ))
    # only sents (2 digits)
    # FI:otetaan vain sentit (2 numeroa)
    typeset -i sub=$(( (val % 1000) / 10 ))  

    printf "%s%d,%02d €\n" "$sign" "$eur" "$sub"
}


################################################
function test_money {
	# 1. TRUNC 
	#    defaults to cutting off to whole euros = 1000
	#    FI: oletuksena leikkaa täysiin euroihin = 1000
	_trunc 101954
	# Output: 101000

	# 2. FLOOR 
	#    with a precision of 100 = 10 cents
	#    FI: tarkkuudella 100 = 10 senttiä
	_floor 101954 100
	# Output: 101900

	# For negative numbers, floor always rounds down:
	#   FI: Negatiivisen luvun floor menee aina alaspäin
	_floor -101954 100
	# Output: -102000


	# 3. ROUND
	#    Rounding to the nearest 5 cents (step = 50)
	#    FI: Pyöristys 5 sentin tarkkuuteen (step = 50)
	_round 101954 50
	# Output: 101950

	# Rounding to the nearest 50 cents (step = 500):
        #   (101954 is closer to 102000 than 101500)
	# FI: Pyöristys 50 sentin tarkkuuteen (step = 500):
	#   (101954 on lähempänä 102000 kuin 101500)
	_round 101954 500
	# Output: 102000

	# Rounding to the nearest whole euro (step = 1000)
	# FI: Pyöristys täyteen euroon (step = 1000):
	_round 101954 1000
	# Output: 102000

	format_euro 101954        # Output: 101,95 €
	format_euro $(_round 101954 50)  # Output: 101,95 €
	format_euro $(_trunc 101954)     # Output: 101,00 €
	format_euro $(_round 101954 1000)     # Output: 102,00 €
	format_euro $(_round 101954 10000)     # Output: 100,00 €
	# Ceil to 1 euro
	format_euro $(_round $((101954+500)) 1000)     # Output: 102,00 €
	format_euro $(_round $((101901+500)) 1000)     # Output: 102,00 €
	format_euro $(_ceil 101954 1000)     # Output: 102,00 €
	format_euro $(_ceil 101901 1000)     # Output: 102,00 €


	LC_NUMERIC=C
	typeset -F a b c d e 
	a=0.7
	b=0.9
	c=0.2
	echo "b-c: $b - $c = $((b-c))"
	d=100.01
	((e=d*a))
	echo "e: d*a : $d * $a = $e"
	((e=e*100.0))
	echo "e:$e"
	typeset -i ff aa bb cc dd
	ff=$e*100
	echo "ff:$ff"
	format_euro $(_round $ff 50)
	echo $ff
	aa=70
	bb=90
	cc=20
	dd=100010
	((ee=dd*aa/10))
	echo "ee:$ee"
	format_euro $(_round $ee 50)

	echo "(0.1+0.7)*10:" $(( (0.1+0.7)*10 ))
	a=0.7
	b=0.1
	echo "(0.1+0.7)*10:" $(( (a+b)*10 ))






}


################################################
function test_time {
	# test rounding secs
	_round 61 60
        _round 59 60
        _round 3601 60   # 3600
        _round 3599 60   # 3600
        _round 3571 60   # 3600
        _round 3570 60   # 3600
        _round 3569 60   # 3540
        _round 3540 60   # 3540
        _round 3539 60   # 3540
        #       4260 # 3600 + 660 s = 1h 11 min => 4500 s = 1 h 15 min
        #       4500  # 1 h 15 min
	#       rounding to the nearest 15 min = 1/4 hour
        _round 4260 900 # 4500
	
}

################################################
# MAIN #########################################
################################################
while [[ $1 == -* ]]
do
	arg="$1"
	case "$arg" in
		-t) 
			test_money
			test_time
			;;
	esac
	shift
done
[ "$1" = "" ] && exit 0
$1 $2 $3

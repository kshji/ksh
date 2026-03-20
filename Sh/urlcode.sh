#!/usr/local/bin/awsh
# urlcode.sh
# https://github.com/kshji
# URL decode/encode

PRG="$0"
BINDIR="${PRG%/*}"
[ "$PRG" = "$BINDIR" ] && BINDIR="." # - same dir as program
PRG="${PRG##*/}"
debug=0

###############################################
function url_decode
{
	# arg or stdin
        str=${*:-$(<&0)} 
        # Swap '+' for a space
        str="${str//+/ }" 
       
        # Escape any backslashes by doubling them, so printf doesn't trip up
        str="${str//\\/\\\\}"

        #Find the encoded characters %XX and turn them into \xXX
        str="${str//%@([0-9a-fA-F][0-9a-fA-F])/\\x\1}"

        # ksh93 printf` handles those \xHH sequences automatically
        printf "$str"
}

###############################################
url_encode()
{
	Xname="url_encode"
	Xin="$*"
	((debug>0)) && echo "\ndbg $Xname: $Xin" >&2
	# both version works fine
	#printf "%#H\n" "$*"
	printf "%(url)q\n" "$*"
}
    
###############################################
to_html()
{
	Xname="to_html"
	Xin="$*"
	((debug>0)) && echo "\ndbg $Xname: $Xin" >&2
	printf '%(html)q\n' "$*"
}

###############################################
usage()
{
	echo "usage: $PRG [ -t ] | [ -e string ] | [ -d string ] | [ -h string ] [ --debug 0|1 ]
	-t     		# test set, examples
	-e  string   	# encode url
	-d  string   	# decode url
	-h  string	# convert to the html
" >&2
}


###############################################
# MAIN
###############################################
decodestr=""
encodestr=""
while [ $# -gt 0 ]
do
	arg="$1"
	case "$arg" in
		--debug) debug="$2"
			;;
		-e|--encode) encodestr="$2"
			url_encode "$encodestr"
			;;
		-d|--decode) decodestr="$2"
			shift
			url_decode "$decodestr"
			;;
		-h|--html) htmlstr="$2"
			shift
			to_html "$htmlstr"
			;;
		-t|--test)
			((debug++))
			input="Matti Meikäläinen > Kekäläinen & Höytiäinen"
			to_html "$input"
			input="http%3A%2F%2Fstackoverflow.com%2Fsearch%3Fq%3Durldecode%2Bksh"
			echo "===========================e==================================="
			echo "$input => decode"
			url_decode "$input"
			echo 
			echo "===========================2==================================="
			echo "$input => decode"
			echo "$input" | url_decode 

			echo 
			input="system=serkku&tunniste=2026&format=json&nimi=Matti Meikäläinen&kaupunki=Helsinki/pääkaupunkisystem=serkku&tunniste=2026"
			echo "$input => encode"
			url_encode "$input"
			echo
			echo "===========================3==================================="
			input="system%3Dserkku%26tunniste%3D2026%26format%3Djson%26nimi%3DMatti%20Meik%C3%A4l%C3%A4inen%26kaupunki%3DHelsinki%2Fp%C3%A4%C3%A4kaupunkisystem%3Dserkku%26tunniste%3D2026"
			echo "$input => decode"
			url_decode "$input"
			echo
			echo "===========================4==================================="
			input="http://stackoverflow.com/search?q=urldecode+ksh"
			echo "$input => encode"
			answer=$(url_encode "$input")
			echo "$answer"
			echo "$answer => decode"
			url_decode "$answer"

			echo
			echo "===========================5==================================="
			input="test%20%21%22%23%24%25%3f%2f%2e%5ctest"
			echo "$input => decode"
			echo "$input" | url_decode   
			echo 
			
			;;
		-*) usage; exit 1 ;;
	esac
	shift
done


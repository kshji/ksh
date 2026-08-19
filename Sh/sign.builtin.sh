#!/usr/bin/ksh93
#  sign.builtin.sh
#  make some sign using ksh93 builtin properties
#  ver: 2026-08-19 / Jukka Inkeri
#  https://github.com/kshji
#

SECKEY="SomeSecret123OrNot"

####################################################################################
function sign_old {
        # +/ merkit muutetaan ettei koodata %XX merkeiksi
        # ja lopusta otetaan pois base64 "mainos" =
        # +/ char changed => not encoded %XX
        # remove = base64 "fingerprint"
        typeset day value msg mac
        day="$1"
        value="$2"
        msg="$day|$value"
        mac=$(printf '%s' "$msg" \
                | openssl dgst -sha256 -hmac "$SECKEY" -binary \
                | openssl base64 -A )\
                #| tr '+/' '-_' | tr -d '=')
        mac=${mac//+/-}
        mac=${mac//\//_}
        mac=${mac//=/}
        printf '%s.%s' "$day" "$mac"
}

####################################################################################
function fast_mac32 {
    typeset str="$1"
    # 32-bit FNV offset basis and prime
    typeset -uli hash=16#811c9dc5
    typeset -uli prime=16#01000193
    typeset -i k=0 i=0

    for (( i=0; i < ${#str}; i++ )); do
        printf -v k "%d" "'${str:i:1}"
        # Pidetään luku 32-bittisenä maskilla 0xFFFFFFFF, jolloin ylivuotoa ei tule
        # Keep number 32-bits using mask 0xFFFFFFFF, no overflow
        (( hash = ((hash ^ k) * prime) & 16#FFFFFFFF ))
    done

    printf '%x' "$hash"
}

####################################################################################
function sign {
	# if we have builtin cmd sum, use it, if not - use FNV-32
	# also possible to use external command ....
	#builtin sum 2>/dev/null || { sign_old $* ; return   ; }

	typeset day value msg mac
	day="$1"
       	value="$2"
	msg="$day|$value"

	if builtin sum 2>/dev/null ; then
		print "   we have builtin sum!" >&2
		mac=$(printf "$SECKEY:$msg:$SECKEY" | sum -x sha256)
		# possible to use md4, md5, sha1, sha256, sha384, sha512, att, ast4, bsd, crc, prng
		# Look: Ksh source src/lib/libsum/sumlib.c
	else # use 32-bit FNV
		print "   we use fast_mac32" >&2
		mac=$( fast_mac32 "$SECKEY:$msg:$SECKEY" )
		print "   mac:$mac" >&2
	fi
	printf '%s.%s' "$day" "$mac"
}


####################################################################################
# MAIN
####################################################################################

printf -v today "%(%Y-%m-%d)T"

ip=192.168.33.12

sigstr=$(sign_old "$today" "$ip")
print "sigstr:$sigstr"

sigstr=$(fast_mac32 "$SECKEY$today|$ip$SECKEY")
sigstr=$(fast_mac32 "$SECKEY$today$ip$SECKEY")
print "sigstr:$sigstr"

sigstr=$(sign "$today" "$ip")
print "sigstr:$sigstr"

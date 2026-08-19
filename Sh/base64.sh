#!/usr/bin/ksh93
# base64.sh
# Use ksh93 builtin to handle <=> base64 data
# LC_ALL=C have to use to support multibyte chars like UTF-8 character set
#
# ver=2026-08-19
# https://github.com/kshji
#

############################################################################
example_using()
{
	typeset -b b64data
	str="Hello World"
	# read make conversion!!! = it's part of io-library
	read -r -N${#str} b64data<<<$str
	print "base64:$b64data"
	# base64 decode to string
	printf -v text %B b64data
	print "text:$text"
	[[ "$str" != "$text" ]] && print "not worked?" >&2  || print "it works!" >&2
}

############################################################################
# --- ENCODE (string -> base64) ---
# -- 2. param variable nameref which get the value
#    if not set nameref variable, print result to the stdout
#    - nice ...
function b64_encode {
    typeset LC_ALL=C
    typeset -b _b64
    [[ "$2" != "" ]] && typeset -n _out=$2   # nameref for result
    typeset _str="$1"
    
    # read bytes from stdin
    read -r -N${#_str} _b64 <<< "$_str"
    [[ "$2" == "" ]] && print "$_b64" && return
    _out="$_b64"
}

############################################################################
# --- DECODE (base64 -> string) ---
function b64_decode {
    typeset LC_ALL=C
    typeset -b _b64="$1" # copy base64 binarydata to the binary data
    [[ "$2" != "" ]] && typeset -n _out=$2
    
    # use special for %B - binary convert to the ascii text
    [[ "$2" == "" ]] && printf %B _b64 && return
    printf -v _out %B _b64
}

############################################################################
# --- MAIN TEST
############################################################################

example_using

typeset -b encoded   # include base64 binarydata
typeset decoded

echo "_____________________________________"
echo "nameref solution"
b64_encode "Hello World! Taalla ksh93 Kuka siella?" encoded
print "Base64:  $encoded"

b64_decode "$encoded" decoded
print "Decoded: $decoded"

b64_encode "Hello World! Täällä ksh93 Kuka siellä?" encoded
print "Base64:  $encoded"

b64_decode "$encoded" decoded
print "Decoded: $decoded"

####################################
echo "_____________________________________"
echo "stdout return version"
encoded=$(b64_encode "Hello World! Taalla ksh93 Kuka siella?")
print "Base64:  $encoded"

decoded=$(b64_decode "$encoded")
print "Decoded: $decoded"


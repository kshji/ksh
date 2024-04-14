#!/usr/local/bin/awsh
# uuidv7.sh
# https://github.com/kshji/ksh/tree/master/Sh
# Jukka Inkeri 2024-04-14
#
# This version use ksh printf %T properties to get epoch timestamp
# and variable SRANDOM
# https://github.com/ksh93/ksh
# My awsh has build using https://github.com/ksh93/ksh
#

#####################################################
usage()
{
        echo "usage: $0 -v7 | -s | -t | -r uuidv7" >&2
        exit 1
}

#####################################################
uuid_ssl()
{
        #v4
        uuid=$(openssl rand -hex 16)
        echo ${uuid:0:8}-${uuid:8:4}-4${uuid:12:3}-${uuid:16:4}-${uuid:20:12}
}

#####################################################
uuidV7()
{
        s0=$(printf "%(%10s%3N)T" now)   # epoch + nano
        st=$(printf "%(%Y-%m-%d %H:%M:%S.%3N)T" now)
        s1=${s0:0:10} ## epoch
        ((s2=(s1*1000) >> 16 ))
        ((s4=( s0 & (0xffff)) ))
        ((rand1=0x7000 + (SRANDOM % 0x0fff) ))
        ((rand2=0x8000 + (SRANDOM % 0x3fff) ))
        ((rand3= (SRANDOM ) >> 8 ))
        ((rand4= (SRANDOM ) >> 8 ))
        printf '%08x-%04x-%04x-%04x-%06x%06x %s %s\n' $s2 $s4 $rand1 $rand2 $rand3 $rand4 "$st" $s0
}

#####################################################
uuidv72timestamp()
{
        Xuuidv7="$1"
        epochhex=0x${Xuuidv7:0:8}${Xuuidv7:9:4}
        #echo $epochhex
        bigint=$(printf "%ld\n" $epochhex)
        ((epoch=bigint/1000))
        ((epochnano=bigint%1000))
        printf "%(%Y-%m-%d %H:%M:%S)T.%03d\n" "#$epoch" $epochnano
}

#####################################################
test_uuid()
{
        for i in {1..10}
        do
                uuidV7
        done
        sleep 1
        for i in {1..10}
        do
                uuidV7
        done
        uuidv72timestamp $(uuidV7)
}

#####################################################
# MAIN
#####################################################
echo "SRAND:$SRANDOM"

cnt=0
while [ $# -gt 0 ]
do
        arg="$1"
        ((cnt++))
        case "$arg" in
                -r|--timestamp) uuidv72timestamp "$2" ; shift ;;
                -t|--test) test_uuid ;;
                -v7|--v7) uuidV7 ;;
                -s|--ssl|--uuidssl) uuid_ssl ;;
                -h|-?|--help) usage ;;
                *) usage ;;
        esac
        shift
done
# default without options
(( cnt < 1 )) && uuidV7


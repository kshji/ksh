#!/usr/bin/ksh
# Or use bash 
#
# allowdynamic.sh
# Fix UFW or iptable rules show that it allow your dynamic ip
# 
# example using:
#  allowdynamic.sh --hostname mydyn.duckdns.org
# 
# Look template rule file
#
# need root access to execute
# 
# Ver: Jukka Inkeri 2021-06-16
# https:/awot.fi
# https://github.com/kshji
#

PRG="$0"
BINDIR="${PRG%/*}"
[ "$PRG" = "$BINDIR" ] && BINDIR="." # - same dir as program
PRG="${PRG##*/}"


##########################################################################
usage()
{
	echo "$(<<EOF
usage:$PRG --hostname somehostname [ --template templaterulefile ]  [ --debug 0|1 ]
      $*
EOF
	)" >&2

}

##########################################################################
err()
{
	[ "$*" = "" ] && return 0
	echo "$*" >&2
}

##########################################################################
dbg()
{
	((debug<1)) && return 0
	err "$*"
}

##########################################################################
myip()
{
	dig -4 +short myip.opendns.com @resolver1.opendns.com
	# or
	#dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | tr -d '"'
}

##########################################################################
lookupip()
{
	Xhostname="$1"
	[ "$Xhostname" = "" ] && err "lookupip need hostname" && return 1
	Xip=$(dig -4 +short $Xhostname)
	# if not found, it'll be empty
	echo "$Xip"
}



##########################################################################
# MAIN
##########################################################################


# - hostdir include rule templates and previous ip's
hostdir="/usr/local/etc/allowdynamic"
template="$hostdir/rule.template"
mkdir -p "$hostdir"
[ ! -d "$hostdir" ] && err "need $hostdir access" && exit 2

hostname=""
ip_prev=""
ip_new=""
debug=0
ip_thishost=$(myip)

FORCE=0
previp=""

while [ $# -gt 0 ]
do
	arg="$1"
	case "$arg" in
		--debug|-d) # debug level
			debug="$2" ; shift 
			;;
		--hostname|-h) # hostname
			hostname="$2" ; shift 
			;;
		--template|-t) # template file
			template="$2" ; shift 
			;;
		--previp|-p) # reset prev ip - set something else as current
				previp="$2" ; shift 
			;;
		-*) usage ; exit 1 ;;
		*) break ;;
	esac
	shift
done

[ "$hostname" = "" ] && usage "Need hostname" && exit 2
[ "$ip_thishost" = "" ] && err "Can't resolve this host ip" && exit 3
dbg "This host ip:$ip_thishost"

ip=$(lookupip "$hostname")
[ "$ip" = "" ] && err "can't resolve $hostname" && exit 4
dbg "$hostname ip:$ip"


file_ip_prev="$hostdir/$hostname.ip"
[ "$previp" != "" ] && echo "ip_prev=$previp" > $file_ip_prev
((debug>0)) && echo "file_ip_prev $file_ip_prev" >&2
[ ! -f "$file_ip_prev" ] && ip_prev="999.999.999.999"
[  -f "$file_ip_prev" ] && . "$file_ip_prev"


dbg "using template $template"
[ ! -f "$template" ] && err "error: can't open template $template" && exit 6

dbg "Previous ip:$ip_prev Now ip:$ip"
[ "$ip_prev" = "$ip" ] && exit 0  # no changes

new_ip="$ip"
((debug>0)) && echo "new_ip $new_ip - $ip" >&2

export new_ip ip ip_prev
# excute rule template
. "$template"

# save ip
echo "ip_prev=$ip" > "$file_ip_prev"
dbg "ip $ip saved to file $file_ip_prev"



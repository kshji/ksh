#!/usr/bin/ksh
# sms.sh
# Using pushbullet.com gateway api to send sms using your Android phone 
# Basic lisence 100 message / months , 0 e
# Pro unlimited, https://www.pushbullet.com/pro, some $ / month

#  sms.sh -p +35804001001001 -s "My message 4u"
#  sms.sh -u  # user
#  sms.sh -d  # devices
#  sms.sh --debug 1  # debug 0|1
# 
# api doc https://docs.pushbullet.com/
# 
# Jukka Inkeri 2020-04-13

# You need Access Token , look on the page 
# https://www.pushbullet.com/#settings/account
#
PRG="$0"
BINDIR="${PRG%/*}"
[ "$PRG" = "$BINDIR" ] && BINDIR="." # - same dir as program
PRG="${PRG##*/}"

apikey="Your Access Token"  	   #  https://www.pushbullet.com/#settings/account
smsiden="Your Android Phone Iden"  #  look your Android device den value from device list

mkdir -p data tmp done
chmod 1777 tmp 2>/dev/null

#########################################################################
usage()
{
   echo "usage:$PRG -p phonenro -s sms_message | -u user | -d devices [ --debug 0|1  ] " >&2
}

#########################################################################
devices()
{
	curl -s --header "Access-Token: $apikey" https://api.pushbullet.com/v2/devices --output data/device.json
	jq . data/device.json
}

#########################################################################
user()
{
	curl -s --header "Access-Token: $apikey" https://api.pushbullet.com/v2/users/me --output data/user.json

	jq . data/user.json
        iden=$(jq .iden data/user.json)
	iden=${iden//\"}
        echo "iden:$iden"
}

#########################################################################
sms_send()
{

Xphonenr="$1" # also comma separated list is possible
Xmsg="$2"
[ "$Xphonenr" = "" ] && return 1
[ "$Xmsg" = "" ] && return 2

guid="$(printf "%(%Y%m%d_%H%M%S)T" now).$RANDOM.$$"
tmpin="tmp/$guid.json"
tmpout="tmp/$guid.answer.json"
cat <<JSON > $tmpin
{"data":{"addresses":["$Xphonenr"],
	"guid":"$guid",
	"message":"$Xmsg",
	"target_device_iden":"$smsiden"
	}
}
JSON

((debug > 0 )) && cat $tmpin

curl  -q -X POST -H "Access-Token: $apikey" -H 'Content-Type: application/json' -d @$tmpin https://api.pushbullet.com/v2/texts --output $tmpout
	stat=$?

	jq . $tmpout

	((stat < 1 )) && cp $tmpout done/$guid.sendsms.json 2>/dev/null
	((stat < 1 )) && rm -rf $tmpout $tmpin 2>/dev/null
	((stat >0 )) && echo "error, look $tmpin  $tmpout" >&2
}

#########################################################################
# MAIN
#########################################################################

phonenr=""
debug=0
export apikey smsiden phonenr debug
while [ $# -gt 0 ]
do
	arg="$1"
	case "$arg" in
		-u) user ;;
		-d) devices ;;
		 # also comma separated list of phonenumbers is legal
		-p) phonenr="$2"; shift ;;
		-s) sms_send "$phonenr" "$2"; shift ;;
		--debug) debug=$2; shift ;;
		--) shift; break ;;
		-*) usage; exit 1 ;;
		*) break ;;
	esac
	shift
done


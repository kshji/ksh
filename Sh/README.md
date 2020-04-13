# KSH Scripts #

Here is some my scripts for you.

I use ksh /usr/local/bin/awsh in my scripts. Copy working ksh to the /usr/local/bin/awsh or change it to the your ksh path ex. /usr/bin/ksh

## ip2dec2ip ##

Convert ip address to the decimal format and reverse


```sh
	ip2dec2ip --dec 192.168.10.10
	3232238090 1111111111111111111111111111111111000000101010000000101000001010 192.168.10.10 11000000.10101000.1010.1010 192.168.10.10
	# dec binary ipaddr ipaddrbin

	# bact to ipaddress
	ip2dec2ip --ip 3232238090
	192.168.10.10
```

## parsercsv.sh ##

Simple csv parser using read -S optins. So simple.

## parsercsv2.sh ##

Example to parser csv, using 1st line to get variable names.
=> Parse columns to variables, variable names are readed from 1st line.

## printout_csv.sh ##

Example how to RFC format csv files. 
 * handle correctly multiline values
 * handle correctly values which include quotation mark


## sql2csv.sh ##

Example how to convert Postgresql data to the csv. 

## sms.sh ##

Shell script to send sms messages using your Android Phone and https://www.pushbullet.com/ gateway.
  * Basic lisence is free, limit 100 sms / month
  * Pro lisense is unlimited, only some dollars / month



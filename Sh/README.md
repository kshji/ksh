# KSH Scripts #

Here is some my scripts for you.

I use ksh /usr/local/bin/awsh in my scripts. Copy working ksh to the /usr/local/bin/awsh or change it to the your ksh path ex. /usr/bin/ksh

Most of my scripts works also using some other "about" posix shells: bash, zsh and dash. Dash is 100% Posix.

## Mutt - sendemail.sh ##
Send email using using smtp-servers (Gmail, Office365, ...).

 * [Sendemail.sh](Mutt)

## 731.sh ##
Finnish Payment Reference Number Calculation. Modulus 10 using weight 731.
 * [Payment Reference](https://www.finanssiala.fi/maksujenvalitys/dokumentit/Forming_a_Finnish_reference_number.pdf)

Example: 
 * reference Number 7 => Payment Ref 71
 * reference Number 333 => Payment Ref 3337

Look RF.sh. Solution convert Finnish Payment Reference to the International RF-format.

```sh
	731.sh 333
        3337
```
Look 731.sql. Same calculation using PostgreSQL function.

## 21.sh ##
Modulus 10 using weight 21. Swedish payment reference number calculation.
Credit card numbers, SMI card numbers, ....

 * [Luhn algorithm](https://en.wikipedia.org/wiki/Luhn_algorithm)

```sh
	21.sh 9999
        99994
```

## Barcode printing using only javascript and html - SVG ##

**barcode.js.html** is example how to make browser based label printing with barcodes.

Previously I have used command **barcode** and **zint**. Problem is image quality, because those command
create image. **Fly** you can make image using drawing command. 128table.txt include bitmaps rules for 
[fly](http://www.w3perl.com/fly/) to create ex. code128 gifs (or png).

For [QR-code](https://github.com/fukuchi/libqrencode).

On the webpage the best quality has done using pure javascript to create vector barcode (SVG) using 
[JsBarcode](https://github.com/lindell/JsBarcode)
 * Code128
 * EAN
 * Code39
 * ITF
 * MSI
 * Pharmacode
 * Codabar

## pankkivirtuaaliviivakoodi.sh ##
Finnish Payment Virtualbarcode.

```sh
	pankkivirtuaaliviivakoodi.sh -v 1119 -e 211129 -s 24000 -t "FI19 1999 9999 9999 99"
	# 419199999999999990002400000000000000000000001119211129
```


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

## Date calculation datecalc.sh and julian_date_calculation.sh
 * datecalc.sh which use ksh printf and command GNU date calculation

 * julian_date_calculation.sh use conversion algorithm is due to Henry F. Fliegel and Thomas C. Van Flandern (1968).  [Julian and Gregorian Day Numbers](http://www.stiltner.org/book/bookcalc.htm). 
This calendar is not so limited, usable time period is huge.

## parsercsv.sh ##

Simple csv parser using read -S optins. So simple.

## parsercsv2.sh ##

Example to parser csv, using 1st line to get variable names.
=> Parse columns to variables, variable names are readed from 1st line.

## printout_csv.sh ##

Example how to RFC format csv files. 
 * handle correctly multiline values
 * handle correctly values which include quotation mark

## allowdynamic.sh ##
Tools for those who need update firewall (iptable, UFW, ...) to change dynamic ip rules.
  * look example rules in example dir

```sh
	# example I have DynDNS using duckdns and my domain/host has named mydyn
	allowdynamic.sh --hostname mydyn.duckdns.org
```
  * add execute to cron , ex. 10 06 * * * /some/path/allowdynamic.sh --hostname mydyn.duckdns.org 

## RF.sh 
International Payment Reference Number Calculation. 
Use this also to convert Finnish Payment Refrence Number To the RF format.

```sh
	# make Finnish Payment Ref from value 234823
	731.sh 234823
	2348236

	# make RF from 2348236
	RF.sh -m 2348236
	RF332348236
```


Check RF is valid
```sh
	RF.sh -c RF332348236   
```

### More RF documents, online testing ###
 * [Kansainvälinen RF viite](https://www.finanssiala.fi/maksujenvalitys/dokumentit/kansainvalisen_viitteen_rakenneohje.pdf)

## sms.sh 

Shell script to send sms messages using your Android Phone and https://www.pushbullet.com/ gateway.
  * Basic lisence is free, limit 100 sms / month
  * Pro lisense is unlimited, only some dollars / month
  * Android Phone you need App Pushbullet and setup SMS gateway on
  * Userid is your Google account
  * Your linked devices has done installing Pushpullet App to your Android device
  * Your [devices](https://www.pushbullet.com/#devices)
  * You can send SMS using API, but also install Pushpullet Client (Windows, Android, Chrome and Firefox)
  * In API using you need Access Token, which are created on page [Settings](https://www.pushbullet.com/#settings/account) using button **Get Access Token**

### 1st run 
Need to get your devices list
```sh
sms.sh -a "your_access_token" -d
# look Mobile gateway device **iden** value
# "iden": "xyx6uoPPabx72443sdsdxs",
```
### Send SMS ###

```sh
#sms.sh -a "your_access_token" -m "gatewayy_mobiledevice iden" -p smsphonenumber -s "SMS_message"
sms.sh -a "your_access_token" -m "xyx6uoPPabx72443sdsdxs" -p 358999999 -s "Hello World, my message 4u"
```

## SSL certificate managing using openssl 

sslopen is excellent command to make cert files and read cert information.
I have used sslopen also to make [JWT Tokens](https://github.com/kshji/jwt).

```sh
# read your cert file
openssl req -text -noout -verify -in some.csr

# validate period
openssl x509 -noout -in some.pem -dates

# read SSL
#WITH SNI
openssl s_client -showcerts -servername host.my.dom -connect www.other.dom:443 </dev/null

#WITHOUT SNI 
openssl s_client -showcerts -connect somehost:443 </dev/null

echo | openssl s_client -servername -servername host.my.dom -connect www.other.dom:443 2>/dev/null | openssl x509 -text

# get cert and write it using some format, example
openssl s_client -showcerts -connect host.my.dom:443 < /dev/null | openssl x509 -outform DER

# other 
openssl s_client -showcerts -connect host.my.dom:443 < /dev/null | openssl x509 -text
openssl s_client -showcerts -connect host.my.dom:443 < /dev/null 2>/dev/null | openssl x509 -noout -dates


```


## ssl.show.cert.date.sh HOST:PORT 
This command read host cert and write out period of validity.



```sh
	ssl.show.cert.date.sh somehost:443
	# output
	2020-12-23 230932 2021-03-23 230932
	
```

## ssl.check.period.validity.sh 
Check certificate period of validity and make alert using email.

```sh
	#  Chech certiticate, if validity will end under 14 days, make email alert to the address alerttome.email@mydomain.dom
	ssl.check.period.validity.sh -h mydomain.dom:443 -p 14 -e alerttome.email@mydomain.dom -s "SSL CERT Alert Domain:"
	
```

## oracle2csv.sh
Dump Oracle database table to the csv file.
Create csvout directory. Output data to the csvout directory.

```sh
	# use default delimiter
	oracle2csv.sh -t tablename
	# set delimiter
	oracle2csv.sh -t tablename -d ";"
```

	
## uuidv7.sh 
Uuidv7 begin with timestamp = sort is easy using uuidv7 and no need to save timestamp.

Set shell to the 1st line. Works with ksh and bash. Epochtime and random has done different methods.
Done using only builtin commands.

  * [IETF](https://www.ietf.org/archive/id/draft-peabody-dispatch-new-uuid-format-04.html)
  * [Why uuidv7 is better ...](https://itnext.io/why-uuid7-is-better-than-uuid4-as-clustered-index-edb02bf70056)
  * [Good bye integers, welcome uuids](https://buildkite.com/blog/goodbye-integers-hello-uuids)
  * [My Postgresql uuidv7](https://github.com/kshji/postgresql)
  * [My uuid tools collection](https://github.com/kshji/uuid/) - Go, Javascript, C
  

uuidv7.sh return:
 * uuidv7
 * timestamp
 * epoch + 3 number from nanoseconds

```sh
uuidv7.sh
018ee027-15c8-7815-9b85-bf97799251a3|2024-04-15 08:07:21.672|1713157641672

# reverse, take timestamp from uuidv7
uuidv7.sh -r 018ee027-15c8-7815-9b85-bf97799251a3
2024-04-15 08:07:21.672

# uuidv4 using OpenSSL rand
uuidv7.sh -s
acbfee75-cbb4-441a-b5f5-a0841a528e64
```

## moneycalc.sh

Package contains calculation models on how money and related calculations are done using
integer rather than floating point calculations.
Risk? Because floating point does not provide the right answers in all situations.

[Read more]( #  https://en.wikipedia.org/wiki/Floating-point_error_mitigation)

**Round** and **floor** function are generic, you can use it any rounding level, look examples.

```bash
# Test without debug output
    moneycalc.sh -t
# Test with debug output
    moneycalc.sh -d -t
# Example
#     round using 900 = ex. 900 s = 15 min
       moneycalc.sh -m 900 1600 # 1600 s
       1800 # half hour

       moneycalc.sh -m 900 4260 # 3600 + 660 s = 1h 11 min => 4500 s = 1 h 15 min
       4500  # 1 h 15 min

#     round money 12.54 rounding nearest .10
       moneycalc.sh -m 10 1255
       1260

#     round money 12.54 rounding nearest integer
       moneycalc.sh -m 100 1255
       1300

#     test using default 3 decimal = multiplier 1000
        moneycalc.sh -t

#     test using default 2 decimal = multiplier 100
        moneycalc.sh -m 100 -t

#     round 12.03 to nearest .05
	round 1203 5
	1205
#     floor 12.03 to nearest .05
	floor 1203 5
	1205

```bash



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

## allowdynamic.sh ##
Tools for those who need update firewall (iptable, UFW, ...) to change dynamic ip rules.
  * look example rules in example dir

```sh
	# example I have DynDNS using duckdns and my domain/host has named mydyn
	allowdynamic.sh --hostname mydyn.duckdns.org
```
  * add execute to cron , ex. 10 06 * * * /some/path/allowdynamic.sh --hostname mydyn.duckdns.org 

## RF.sh ##
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
 * [Javascript](https://github.com/EDumdum/iso-11649-js)
 * [Php](https://github.com/kmukku/php-iso11649/blob/master/src/phpIso11649.php)
 * [Java](https://github.com/terokallio/reference-numbers/blob/master/src/main/java/com/terokallio/referencenumbers/RFCreditorReference.java)
 * Ksh and bash  my *731.sh* and *RF.sh*
 * [Nordea online generator both format](https://pankki.nordea.fi/en/corporate-customers/payments/invoicing-and-payments/reference-number-calculator.flex)


## sql2csv.sh ##

Example how to convert Postgresql data to the csv. 

## sms.sh ##

Shell script to send sms messages using your Android Phone and https://www.pushbullet.com/ gateway.
  * Basic lisence is free, limit 100 sms / month
  * Pro lisense is unlimited, only some dollars / month
  * Android Phone you need App Pushbullet and setup SMS gateway on


## SSL certificate managing using openssl ##

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


## ssl.show.cert.date.sh HOST:PORT ##
This command read host cert and write out period of validity.



```sh
	ssl.show.cert.date.sh somehost:443
	# output
	2020-12-23 230932 2021-03-23 230932
	
```

## ssl.check.period.validity.sh ##
Check certificate period of validity and make alert using email.

```sh
	#  Chech certiticate, if validity will end under 14 days, make email alert to the address alerttome.email@mydomain.dom
	ssl.check.period.validity.sh -h mydomain.dom:443 -p 14 -e alerttome.email@mydomain.dom -s "SSL CERT Alert Domain:"
	
```


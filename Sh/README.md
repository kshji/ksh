# KSH Scripts #

Here is some my scripts for you.

I use ksh /usr/local/bin/awsh in my scripts. Copy working ksh to the /usr/local/bin/awsh or change it to the your ksh path ex. /usr/bin/ksh

## 731.sh ##
Finnish Payment Reference Number Calculation.
 * [Payment Reference] (https://www.finanssiala.fi/maksujenvalitys/dokumentit/Forming_a_Finnish_reference_number.pdf)

Example: 
 * reference Number 7 => Payment Ref 71
 * reference Number 333 => Payment Ref 3337

Look RF.sh. Solution convert Finnish Payment Reference to the International RF-format.

```sh
	731.sh 333
        3337
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

## RF.sh ##
International Payment Reference Number Calculation. 
Use this also to convert Finnish Payment Refrence Number To the RF format.

```sh
	# make Finnish Payment Ref from value 234823
	731.sh 234823
	2348236

	# make RF from 2348236
	RF.sh -m 2348236
	RF852228
```


Check RF is valid
```sh
	RF.sh -c RF852228
```

### More documents, online testing ###
 * [Kansainvälinen RF viite] (https://www.finanssiala.fi/maksujenvalitys/dokumentit/kansainvalisen_viitteen_rakenneohje.pdf)
 * [Javascript] (https://github.com/EDumdum/iso-11649-js)
 * [Php] ( https://github.com/kmukku/php-iso11649/blob/master/src/phpIso11649.php)
 * [Java] (https://github.com/terokallio/reference-numbers/blob/master/src/main/java/com/terokallio/referencenumbers/RFCreditorReference.java)
 * Ksh and bash  my *731.sh* and *RF.sh*
 * [Nordea online generator both format] (https://pankki.nordea.fi/en/corporate-customers/payments/invoicing-and-payments/reference-number-calculator.flex)


## sql2csv.sh ##

Example how to convert Postgresql data to the csv. 

## sms.sh ##

Shell script to send sms messages using your Android Phone and https://www.pushbullet.com/ gateway.
  * Basic lisence is free, limit 100 sms / month
  * Pro lisense is unlimited, only some dollars / month
  * Android Phone you need App Pushbullet and setup SMS gateway on



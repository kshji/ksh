#!/usr/local/bin/awsh
# printout_csv.sh
# Output use RFC4180 standard

a='123'
b='5" is same as 5 inch'
c='string"quotation marks"string'
d="somestring
multiline
3th line"

delim=";"

printf "%(csv)q%s"  "$a" "$delim"
printf "%(csv)q%s"  "$b" "$delim"
printf "%(csv)q%s"  "$c" "$delim"
printf "%(csv)q%s"  "$d"
printf "\n"
printf "%(csv)q%s"  "$a" "$delim"
printf "%(csv)q%s"  "$b" "$delim"
printf "%(csv)q%s"  "$d" "$delim"
printf "%(csv)q%s"  "$c"
printf "\n"

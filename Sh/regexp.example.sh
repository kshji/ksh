#!/usr/local/bin/awsh
# regexp.example.sh
# 
# Look:
#    http://blog.fpmurphy.com/2009/01/ksh93-regular-expressions.html
#    http://stackoverflow.com/questions/3833804/setting-another-variable-with-a-regular-expression-in-ksh
#
echo "Ver1, parse to array"
var='orl,bdl,lap'
saveIFS=$IFS
IFS=','
array=($var)
newvar="${array[*]:1}"
IFS=$saveIFS
echo "newvar:$newvar"

echo "Ver2, parse and set environment variables"
var='orl,bdl,lap'
saveIFS=$IFS
IFS=','
set -- $var
shift
newvar="$*"
echo "newvar:$newvar"
IFS=$saveIFS

echo "Ver3 regexp pattern"

var='orl,bdl,lap'
pattern='^[^,]*,(.*)$'
[[ $var =~ $pattern ]]
newvar=${.sh.match[1]}
echo "newvar:$newvar"

echo "More regexp examples"
# ksh93 include lot of not so well documented regexp extensions ...
b="orl,bdl,lap"
a=${b/~(E),*orl} a=${a/~(E)^,*}
print $a
#bdl,lap
a=${b/~(E),*bdl} a=${a/~(E)^,*}
print $a
#orl,lap
a=${b/~(E),*lap} a=${a/~(E)^,*}
print $a
#orl,bdl

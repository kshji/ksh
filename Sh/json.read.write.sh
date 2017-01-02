#!/usr/local/bin/awsh
# json.read.write.sh
# read and print support compund item format json
# This is very new and this is fexed in version 2014-12-24 o # older include many bugs
# Version ABIJM 93v- 2014-12-24 is oldest which work correctly
#
LANG=C;
export LANG
echo ${.sh.version} 

###########################################################
tstout()
{
print "-------------------------------"
print "$person"
print "-------------------------------"
print -r "$person"
print "-------------------------------"
print ${person.email}
print "-------------------------------"
print ${person.lotto[*]}
print "-------------------------------"
print -j person
print "-------------------------------"

unset person
}

###########################################################
echo "==================== compound item , print JSON =============="
compound person
person=(firstname="John" lastname="Some" age=32)
print -j person
print "-------------------------------"
printf "%(json)B\n" person
print "-------------------------------"

echo "=============== JSON compound item ==========================="
unset person
compound person
read -m json person <<EOF
{
    "first" : "My",
    "email" : "My.Name@gmail.com"
}
EOF
echo "print -j person:"
print -j person
echo
echo 'print -r "person"'
print -r "$person"
echo
echo 'print ${person.email}'
print ${person.email}


echo "=============== JSON compound item ==========================="
compound person

# read JSON person object and parse it. Use compound variable
read -m json person <<EOF
{
    "first" : "My",
    "last" : "Name",
    "email" : "My.Name@gmail.com",
    "lucky" : 13,
    "quarter" : 0.25,
    "children" : [ boy, girl ],
    "empty" : null,
    "nerd" : true,
    "lotto" : [ 9, 12, 17, 38, 45, 46 ]
}
EOF



tstout

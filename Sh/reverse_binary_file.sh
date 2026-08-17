#!/usr/local/bin/awsh
# Source https://blog.fpmurphy.com/2017/08/manipulating-binary-data-using-the-korn-shell.html
# https://blog.fpmurphy.com  is not available anymore
#
# reverse a binary file
#
inf=$0.in
outf=$0.out
cat <<EOF > $inf
1
2
3
4
5
EOF
 
typeset -b byte
 
redirect 3< $inf || exit 1
iof=$(3<#((EOF)))
echo "iof:$iof"
 
redirect 4> $outf || exit 1
# oof=0
 
read -r -u 3 -N 1 byte
3<#(( --iof ))
print -u 4 -f  "%B" byte
# (( oof++ ))
 
while (( iof > 0 ))
do
    # print "At offset $iof $oof"
 
    read -r -u 3 -N 1 byte
    3<#(( --iof))
    print -u 4 -f "%B" byte
    # (( oof++ ))
done
 
read -r -u 3 -N 1 byte
print -u 4 -f "%B" byte
 
redirect 3<&- || echo 'cannot close FD 3'
redirect 4>&- || echo 'cannot close FD 4'
 
exit 0





#!/usr/local/bin/awsh
# This is nice support for csv reading
IFS=";" read -S a b c d <<EOF
"a1";"b""2";"c3";d5
EOF

echo "$a - $b - $c - $d"
# output:
# a1 - b"2 - c3 - d5
# 

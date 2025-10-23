#!/bin/bash
#
# Shell Parameter Expansion
# some examples
x=123_456_789
echo $x '${x##*_}': ${x##*_} # last  
# 789
echo $x '${x#*_}':  ${x#*_}  # not 1st
# 456_789
echo $x '${x%%_*}': ${x%%_*} # 1st 
# 123
echo $x '${x%_*}':  ${x%_*}  # not last
# 123_456

x="path/abc/file.names"
echo $x '${x##*/}': ${x##*/}  # last
filename=${x##*/}
echo $filename '${filename%.name*}': ${filename%.name*}  # not last = basename accept also .name* ex. .names
echo $filename '${filename%.name}':  ${filename%.name*}  # before .name = basename   accept only ending .name


prosnum="processes=4"
echo ${prosnum##*=}  # last fld, delimiter =


# Look Parameter Expansion:
# https://github.com/ksh93/ksh/tree/dev/docs/ksh
# https://www.gnu.org/software/bash/manual/bash.html#Command-Substitution
# https://www.ibm.com/docs/en/aix/7.1.0?topic=shell-parameter-substitution-in-korn-posix
# https://pubs.opengroup.org/onlinepubs/9799919799.2024edition/utilities/V3_chap02.html  
# https://www.oreilly.com/library/view/korn-shell-unix/0201675234/0201675234_app05lev1sec12.html

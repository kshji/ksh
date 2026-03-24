#!/usr/bin/ksh
#Original doc source http://blog.fpmurphy.com and ksh src test patterns
#Extended Patterns
#
#
x=B10

for x in "B10" "B100" "BA1"
do
        echo "$x"
        [[ $x =~ B[0-9]{2} ]] && echo match || echo nomatch
        [[ $x =~ B[[:digit:]]{2} ]] && echo match || echo nomatch
        [[ $x =~ B(\d){2} ]] && echo match || echo nomatch
done

#################################
str='An extended pattern expression'
 
print "replace e=>#  ${str//e/#} "
print "replace not e => #  ${str//[^e]/#}"
print "replace 1-n e => # ${str//+(e)/#}"


#########################################

: '
The following table show a number of pattern matching interval quantifiers.

{n}(pattern)	Match if found exactly n times where n is a non-negative number
{n,m}(pattern)	Match if found between n and m times where n and m are non-negative integers and n <= m
Here is an example of how to use the above interval quantifiers to match various strings.
'
   [[ aaaa == {4}(a) ]] && echo yes || echo no
   [[ aaaa == {,4}(a) ]] && echo yes || echo no
   [[ aaaa == {3,}(a) ]] && echo yes || echo no
   [[ aaaa == {2,4}(a) ]] && echo yes || echo no
   [[ abc == {1,4}(ab)c ]] && echo yes || echo no
   [[ abcabc == {,2}(abc) ]] && echo yes || echo no
   [[ abababcc == {1,4}(ab){1,2}(c) ]] && echo yes || echo no
   [[ abc == {1,4}(ab){1,2}(c) ]] && echo yes || echo no
   [[ abcdcdabcd == {3,6}(ab|cd) ]] && echo yes || echo no
   [[ abcdcdabcde == {5}(ab|cd)e ]] && echo yes || echo no

: '
By default an extended pattern attempts to match the longest possible string consistent with generating the longest overall match.  This is known as a greedy or maximal match.  A non-greedy (or minimal) match is one that matches the shortest possible string.  Perl was the first scripting langauge to popularize non-geedy matching.  By the way, ksh93 and zsh are the only shells that support non-greedy matching.

You can use the ‘-‘ qualifier to indicate to the shell that you want to use non-geedy matching as shown in the table below.

?-(pattern)	Shortest match if found 0 or 1 times
*-(pattern)	Shortest match if found 0 or more times
+-(pattern)	Shortest match if found 1 or more times
@-(pattern1|…)	Shortest match if any of the patterns found
{n,m}-(pattern)	Shortest match if found between n and m times
Alternatively, you can use the ~(-g) subpattern to indicate to ksh93 that you want to use non-geedy matching.  The following examples show both methods.
'
str="bcdabdcbabcd"
 
print "    Greedy: ${str/+(*ab)/_}"
print "Non-greedy: ${str/+-(*ab)/_}"
 
str="heleelloo hello"
 
print "    Greedy: ${str//he*l/_}"
print "Non-greedy: ${str//~(-g)he*l/_}"
print "    Greedy: ${str//?(he*ll)/_}"
print "Non-greedy: ${str//~(-g)?(he*ll)/_}"
print "Non-greedy: ${str//?-(he*ll)/_}"
print "    Greedy: ${str//+(he*ll)/_}"
print "Non-greedy: ${str//+-(he*ll)/_}"
print "    Greedy: ${str//*(he*ll)/_}"
print "Non-greedy: ${str//*-(he*ll)/_}"
print "    Greedy: ${str//{1,2}(he*ll)/_}"
print "Non-greedy: ${str//~(-g){1,2}(he*l)/_}"

: '
A pattern-list is a list of one or more patterns separated from each other by either a & or a |.  A & (denoting logical AND) means that all patterns must be matched whereas | (denoting logical OR) means that only one pattern need be matched.  Composite patterns can also be created as shown below.

?(pattern-list)	Optionally matches any one of the patterns
*(pattern-list)	Matches zero or more occurrences of the patterns.
+(pattern-list)	Matches one or more occurrences of the patterns.
{n}(pattern-list)	Matches exactly n occurrences of the patterns.
{m,n}(pattern-list)	Matches m to n occurrences of the patterns.  If m is omitted, 0 is used. If n is omitted at least m occurrences are matched.
@(pattern-list)	Matches exactly one of the patterns.
!(pattern-list)	Matches anything except one of the patterns.
Again, by default, matching is greedy.  Each pattern in the pattern-list attempts to match the longest string possible consistent with generating the longest overall match.  If more than one match is possible, the match starting closest to the beginning of the string will be chosen.  However, for each of the above compound patterns a − can be inserted in front of the ( to specify that the shortest match to the specified pattern-list should be used.

Finer grained control of extended pattern matching is possible using sub-patterns of the form ~(options:pattern-list) where :pattern-list is optional and options consists of one or more of the following option flags:

+	Enable following options (default)
–	Disable following options
E	Remainder of the pattern uses ERE pattern syntax
F	Remainder of the pattern uses fgrep-like pattern syntax.
G	Remainder of pattern uses BRE pattern syntax
K	Remainder of pattern uses ksh93 pattern syntax (default)
i	Case insensitive match
g	Greedy match (default)
l	Left anchor pattern.
r	Right anchor pattern.
If both options and :pattern-list are specified, then the specified options apply only to :pattern-list.  Otherwise, the specified options remain in effect until disabled by a subsequent ~(…) sub-pattern or at the end of the sub-pattern containing ~(…).

You can also handle newlines in patterns matching. Consider the following example:
'

x=$'foo\nbar'
 
print ${x/~(E)foo.*bar/AHA}
print -r "${x/~(Em)foo.*bar/AHA}"
print -r "${x/~(E)foo$/AHA}"
print -r "${x/~(Em)foo$/AHA}"

: '
and the output:
AHA
foo
bar
foo
bar
AHA
bar

The REG_NEWLINE flag is off by default for ~(E). The m option modifier turns it on. If REG_NEWLINE is not set, then a newline in a pattern or string is treated as an ordinary character.

ksh93 provides a way to translate extended patterns into regular expressions and vice-versa by means of two printf options.
'
printf "%R\n" "*[!0-9]*"
# [^0-9]
printf "%P\n" "([0-9]+\.){3}"
# *{3}(+([0-9])\.)*


: '
?(pattern)	Match if found 0 or 1 times
*(pattern)	Match if found 0 or more times	
+(pattern)	Match if found 1 or more times	
@(pattern1|…)	Match if any of the patterns found	
!(pattern)	Match if no pattern found



'


str="Joe Mike and Dave are all good friends"

print ${str//a?(re)/_}
# output: Joe Mike _nd D_ve _ _ll good friends

print ${str//g*(o)/_}
# output: Joe Mike and Dave are all _d friends

print ${str//+(o)/_}
# output: J_ Mike and Dave are all g_d friends

print ${str//@(Joe|Mike|Dave)/_}
# output: _ _ and _ are all good friends

print ${str//@(Joe|Mike|g*(o))/_}
# output: _ _ and Dave are all _d friends

print ${str//!(Joe)/_}
# output: _

print ${str//!(Joe|Mike|Dave)/_}
# output: _


str="    some1 some2      "
print  ".${str/~(E)^ */_}."




t=1234567890
echo "t=$t"
[[ $t == @({10}(\d)) ]] && echo yes  || echo no
[[ att_ == ~(E)(att|cus)_.* ]] && echo yes  || echo no
[[ att_ =~ (att|cus)_.* ]] && echo yes  || echo no     
[[ abc =~ a(b)c ]]  && echo yes  || echo no  
[[ abc =~  \babc\b ]] && echo yes  || echo no   
[[ $t =~ 456 ]]  && echo yes  || echo no
[[ $t =~ 123 ]]  && echo yes  || echo no
[[ $t == 123* ]]  && echo yes  || echo no

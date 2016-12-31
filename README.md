# Ksh/bash scripts for using #

I have done lot of stuff using ksh/awk/sed ... today it's more hoppy.

I try to tell for less ksh used persons how powerfull scripting language it's.

Why I like it ? Only some commands but enough. No librarys or plugins. Static bin include everything.
Nice HERE template.

Thanks for Bourne Shell and Korn Shell. All posix-sh are nice (ksh, bash, dash, ...), but for
scripting I have used ksh93.

## My Repo ##
   * [Awk] (https://github.com/kshji/awk)
   * [Ksh] (https://github.com/kshji/ksh)
   * Postgresql is coming

## Install ksh ##
   * Ubuntu, Debian, Windows Linux Subsystem (bash), ...
       ``` apt-get install ksh ```
   * many *nix system include ksh88 and also ksh93
       * maybe ksh93/posix-sh is in some special directory ex. /usr/xpg4/bin/sh
   * [build from source] (https://github.com/att/ast)

Why my script using **/usr/local/bin/awsh** , not /bin/sh or /bin/ksh ?
I have made a big mistake in my history: a *nix /bin/sh was some special sh, but system include also file ksh93, 
I copied it to /bin/sh. Result wasn't so nice: Next boot, no boot ...

After that I have copied correct ksh93 version to the /usr/local/bin/awsh in every host and use it in my script.
=> I know exactly which version I have used in my scripts and system upgrade not update it automatically.

## /usr/local/bin/awsh ##
Read previous section.

Change my "awsh" to your ksh path as you need it.

## More info ##
   * [My shell script guide] (http://awot.fi/sf/browser/showdocs?cust=ka&subdir=koulutus/shell)
   * [Unix&Linux Forums] (http://www.unix.com/shell-programming-and-scripting/) 
   * [Posix-sh] (http://pubs.opengroup.org/onlinepubs/9699919799/nframe.html)
     * [Posix Shell Commands] (http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html)
   * [Bash Reference manual] (https://www.gnu.org/software/bash/manual/bashref.html)
   * [Learning The Korn Shell] (http://docstore.mik.ua/orelly/unix3/korn/index.htm)

## What I have for you ##

   * CSV parser - dynamically parse csv and use set variables same name as columns name
   * date calculation - it's easy
   * ...


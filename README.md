# Ksh/bash scripts for using #

Sh/Ksh/... user since 1984.

I have done lot of stuff using ksh/awk/sed ... today it's more hoppy.
  * website with templates (HEREdoc), (cgi)
  * textfile database: object format was shellscript = easy to parse :) 
  * tcp/ip servers, ...
  * named pipes with Postgresql
  * ...

I try to tell for less ksh used persons how powerfull scripting language it's.
Net include lot of real old Bourne shell stuff even ksh, bash, ... (posix shells) include lot
of built in properties. ex, calculations without expr, parsing without awk/sed/cut, ...

Unfortunately, fpmurphy.com site is gone now. Finnbarr P. Murphy’s site had a ton of examples of what ksh can do—stuff the manual didn't tell you, at least not directly.

Finnbarr P. Murphy Archives:
* https://web.archive.org/web/20130306112955/http://blog.fpmurphy.com/tag/ksh
* https://web.archive.org/web/20130306112333/http://blog.fpmurphy.com/tag/korn-shell
* https://web.archive.org/web/20130306112338/http://blog.fpmurphy.com/tag/ksh93
* ... 
* [ALL in PDF-docs](https://www.scribd.com/user/8477352/Finnbarr-P-Murphy/uploads)

Why I like it ? Only some commands but enough. No libraries or plugins. Static bin include everything.
  * Nice HERE template 
  * Very simple and nice socket support 
  * event based scripting is possible using **trap**
  * For object persons compount item is supported
  * lowlevel cgi support 
  * regexp 
  * Trap

### *nix / real life

After fork() and once born, it's naturally a brand new child process that inherits its parent’s environment—until it decides to exec() and strike out on its own.
All the parent can do is pray it never turns into a zombie or gets orphaned, 
leaving init to adopt it and reap it with a wait() call!

#### Sama suomeksi tulkattuna

Fork():n jälkeen lapsen synnyttyähän kyseessä on tietenkin uusi lapsiprosessi, joka perii vanhempansa ympäristön, kunnes päättää tehdä oman exec():n ja lähteä omille teilleen. 
Vanhemman tehtäväksi jää vain toivoa, ettei siitä tule koskaan zombieta tai orpoa,
jota init joutuu adoptoimaan ja korjaamaan wait():llä!"

## Thanks for Bourne Shell and Ksh

Thanks for Bourne Shell and 
[Korn Shell](https://www.usenix.org/legacy/publications/library/proceedings/vhll/full_papers/korn.ksh.a). 
All posix-sh are nice (ksh, bash, dash, ...), but for scripting I have used ksh93. Dash is full Posix-sh compatible,
ksh93, bash, ... includes some extensions. Steve Bourne and David Korn are the main persons behind this shells.

## My Repo ##
   * [Awk](https://github.com/kshji/awk)
   * [Ksh](https://github.com/kshji/ksh)

## My env ##
I use Windows 10/11 laptop with Linux Subsystem for development (WSL2).
It's full Ubuntu. Ubuntu 18.04 LTS is current version.
I use also many Debian x64 and Ubuntu servers. My history include many *nix: Ultrix, SCO Open Server, 
MS Xenix, SCO Xenix,  SCO UNixware, HP/UX, SunOS, Solaris, ICL6000, AIX, SNIRM, SNITG, ... ,
Linux distros: SuSe, Debian, Centos, RedHat, Ubuntu, Raspbian, ...

   * [Install Linux Subsystem for Windows 10/11](https://msdn.microsoft.com/en-us/commandline/wsl/install_guide)
   * [Install Linux Subsystem and Xming](http://www.hongkiat.com/blog/bash-ubuntu-windows-10/)
   * [Change bash to ksh default shell (Win10 Linux Subsystem)](http://blog.fpmurphy.com/2016/05/korn-shell-launcher-for-windows-subsystem-for-linux-2.html)

Windows 10/11 Linux Subsystem has been nice. The Best Windows software for me with Xming. 
Mostly Windows is only desktop/window manager/gui for me. **Ssh** , **sh** , **psql** and **vi** is my main tools.

Win10/11 WSL2 (x64) is binary compatible with Ubuntu and Debian. I tested:
  * build att ksh93 from source, standalone version.
  * copy ksh93 to the Win10 bash and run it

## Install ksh ##
   * Ubuntu, Debian, Windows Linux Subsystem (bash), ...
       ``` apt-get install ksh ```
   * many *nix system include ksh88 and also ksh93
       * maybe ksh93/posix-sh is in some special directory ex. /usr/xpg4/bin/sh
   * [build from source](https://github.com/ksh93/ksh) - current active dev version (u+m)
   * ksh-2020 is buggy dev version, don't use it - not active anymore
   * [build from source - old org Ast version](https://github.com/att/ast/tree/beta) - last AST dev vesion ksh93 v-, not stable
   * [All ksh download](https://pkgs.org/download/ksh) for CentOS, Debian, Fedora, Mageia, OpenMandriva, openSUSE, PCLinuxOS, ROSA, Ubuntu.
	* [Old AST Beta](http://gsf.cococlyde.org/download) Has saved by GSF
   
If you download ex. ksh_amd64.deb, you can install it:
```sh
sudo dpkg -i  ksh_amd64.deb
```

### ksh source ###
    
   * [build from source](https://github.com/ksh93/ksh)
   * read compiling info from Github page

### Ksh examples
   * [Ksh](https://github.com/kshji/ksh), my scripts
   * [Ksh old docs](https://github.com/ksh93/ksh/tree/dev/docs/ksh) Ksh old docs by David Korn
   * [Ksh test pattern](https://github.com/ksh93/ksh/tree/dev/src/cmd/ksh93/tests) include lot of nice examples




## /usr/local/bin/awsh ##
Why my script using **/usr/local/bin/awsh** , not /bin/sh or /bin/ksh ?
I have made a big mistake in my history: a *nix /bin/sh was some special sh, but system include also file ksh93, 
I copied it to /bin/sh. Result wasn't so nice: Next boot, no boot ...

After that I have copied correct ksh93 version to the /usr/local/bin/awsh in every host and use it in my script.
=> I know exactly which version I have used in my scripts and system upgrade not update it automatically.

Change my "awsh" to your ksh path as you need it.

## More info ##
   * [My shell script guide](http://awot.fi/sf/browser/showdocs?cust=ka&subdir=koulutus/shell) finnish
   * [My shell script guide](http://awot.fi/sf/browser/showdocs?cust=ka&subdir=koulutus/shell/quickref) My english - sorry ...
   
   * [Unix&Linux Forums](https://community.unix.com/c/shell-programming-and-scripting/20)
   * archive: [Unix&Linux Forums](http://www.unix.com/shell-programming-and-scripting/) 
   * [Posix-sh](http://pubs.opengroup.org/onlinepubs/9699919799/nframe.html)
     * [Posix Shell Commands](http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html)
   * [Bash Reference manual](https://www.gnu.org/software/bash/manual/bashref.html)
   * [Learning The Korn Shell](http://docstore.mik.ua/orelly/unix3/korn/index.htm)
   * [IBM KornShell](https://www.ibm.com/docs/en/aix/7.3.0?topic=shells-korn-shell)
   * [SHELLdorado](http://www.shelldorado.com/)
   * [fpmurphy](http://blog.fpmurphy.com/2009/01/ksh93-regular-expressions.html) Super RegExp examples - page are not available anymore :(

## What I have for you ##

   * CSV parser - dynamically parse csv and use set variables same name as columns name
   * date calculation - it's easy
   * lib.sh include some function, libusage.sh is example to use it
   * ...

## Guru scripts  - Reference manual - HowTo ##

The ksh (ksh93) manual page is only a small scratch on the surface of everything you can do with ksh. 
It is a full-fledged programming language once you grasp the brilliance of its core.

When the fpmurphy.com website disappeared, a vast amount of excellent examples of what can be achieved with ksh93 was lost.

The most important insight is to realize that one should strive to use ksh's builtin commands instead of heavy piping of external commands.

For example, you see this far too often:
(awk, sed, grep, cut, tr, ...)
```bash
# convert +=>- / => _ and remove =
# two subprocess, lot of extra io, env copy, ...
print "$mac" | tr  '+/' '-_' | tr -d '='

# get fieds 2 and 4, delimiter |, output delimiter space
str="fld1|fld2|fld3|fld4|fld5"
print "$str" | cut -d "|" -f 2,4 | tr "|" " "
```


...when the same thing could be done much more efficiently with builtins without heavy child processes.

```bash
# convert +=>- / => _ and remove =
mac=${mac//+/-}
mac=${mac//\//_}
mac=${mac//=/}

# get fieds 2 and 4, delimiter |, output delimiter space  
# lot of builtin solutions, here is two example
# change default input field separator (IFS) = white spaces to the |
IFS="|" read fld1 fld2 fld3 fld4 fld5 xstr <<<$str
# why xtsr? if there are more than 5 flds, extra data is in the xstr, not in the fld5
# or more dynamic method parse the input
IFS="|" array=($str)
print "array:${array[@]}"
fld2=${array[1]}  # 0 = 1st index
fld4=${array[3]}
print $fld2 $fld4
```


If ksh93 is compiled with the option `ALL_LIBCMD=1`, then builtins truly blow the possibilities of ksh93 wide open. 
In this case, all the essential commands that are normally invoked as external commands are available as builtins.

For instance, base64, sha256, md5, and others... all as internal builtin commands.

If need look a lot of builtin "examples", look ksh93 test patterns scripts.

   * [Ksh test patterns ](https://github.com/ksh93/ksh/tree/dev/src/cmd/ksh93/tests)



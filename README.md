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

Why I like it ? Only some commands but enough. No libraries or plugins. Static bin include everything.
  * Nice HERE template 
  * Very simple and nice socket support 
  * event based scripting is possible using **trap**
  * For object persons compount item is supported, own methods,  [fpmurphy] (http://blog.fpmurphy.com/2010/05/ksh93-using-types-to-create-object-orientated-scripts.html)
  * lowlevel cgi support 
  * regexp 
  * [DEBUG Trap] (http://blog.fpmurphy.com/2014/07/korn-shell-debug-trap.html)

Thanks for Bourne Shell and 
[Korn Shell] (https://www.usenix.org/legacy/publications/library/proceedings/vhll/full_papers/korn.ksh.a). 
All posix-sh are nice (ksh, bash, dash, ...), but for scripting I have used ksh93. Dash is full Posix-sh compatible,
ksh93, bash, ... includes some extensions. Steve Bourne and David Korn are the main persons behind this shells.

## My Repo ##
   * [Awk] (https://github.com/kshji/awk)
   * [Ksh] (https://github.com/kshji/ksh)
   * Postgresql is coming

## My env ##
I use Windows 10 laptop with Linux Subsystem (bash) for development. 
It's full Ubuntu. Ubuntu 14.04.5 LTS is current version.
I use also many Debian x64 servers. My history include many *nix: Ultrix, SCO Open Server, 
MS Xenix, SCO Xenix,  SCO UNixware, HP/UX, SunOS, Solaris, ICL6000, AIX, SNIRM, SNITG, ... ,
Linux distros: SuSe, Debian, Centos, RedHat, Ubuntu, Raspbian, ...

   * [Install Linux Subsystem for Windows 10] (https://msdn.microsoft.com/en-us/commandline/wsl/install_guide)
   * [Install Linux Subsystem and Xming] (http://www.hongkiat.com/blog/bash-ubuntu-windows-10/)
   * [Change bash to ksh default shell] (http://blog.fpmurphy.com/2016/05/korn-shell-launcher-for-windows-subsystem-for-linux-2.html)

Windows 10 Linux Subsystem has been nice. The Best Windows software for me with Xming. 
Mostly Windows is only desktop/window manager/gui for me. **Ssh** and **vi** is my main tools.

Cygwin and Virtual Machines are history for me.
Windows 7 laptop includes all those ...

Win10 bash (x64) is binary compatible with Ubuntu and Debian. I tested:
  * build att ksh93 from source, standalone version.
  * copy ksh93 to the Win10 bash and run it

## Install ksh ##
   * Ubuntu, Debian, Windows Linux Subsystem (bash), ...
       ``` apt-get install ksh ```
   * many *nix system include ksh88 and also ksh93
       * maybe ksh93/posix-sh is in some special directory ex. /usr/xpg4/bin/sh
   * [build from source] (https://github.com/att/ast)

```sh
# build ksh from and all other ast stuff
# Tested Debian, Windows Linux Subsystem 
git clone --branch beta https://github.com/att/ast.git
cd ast
./bin/package make
# example I have linux.i386-64, install as root:
install -v -m755 arch/linux.i386-64/bin/ksh /usr/local/bin 
install -v -m644 arch/linux.i386-64/man/man1/sh.1 /usr/local/share/man/man1/ksh.1 
install -v -m755 -d /usr/local/share/doc/ksh-2014-12-24 
install -v -m644 lib/package/{ast-ksh,INIT}.html /usr/local/share/doc/ksh-2014-12-24
```


Why my script using **/usr/local/bin/awsh** , not /bin/sh or /bin/ksh ?
I have made a big mistake in my history: a *nix /bin/sh was some special sh, but system include also file ksh93, 
I copied it to /bin/sh. Result wasn't so nice: Next boot, no boot ...

After that I have copied correct ksh93 version to the /usr/local/bin/awsh in every host and use it in my script.
=> I know exactly which version I have used in my scripts and system upgrade not update it automatically.

## /usr/local/bin/awsh ##
Read previous section.

Change my "awsh" to your ksh path as you need it.

## More info ##
   * [My shell script guide] (http://awot.fi/sf/browser/showdocs?cust=ka&subdir=koulutus/shell) finnish
   * [My shell script guide] (http://awot.fi/sf/browser/showdocs?cust=ka&subdir=koulutus/shell/quickref) My english - sorry ...
   
   * [Unix&Linux Forums] (http://www.unix.com/shell-programming-and-scripting/) 
   * [Posix-sh] (http://pubs.opengroup.org/onlinepubs/9699919799/nframe.html)
     * [Posix Shell Commands] (http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html)
   * [Bash Reference manual] (https://www.gnu.org/software/bash/manual/bashref.html)
   * [Learning The Korn Shell] (http://docstore.mik.ua/orelly/unix3/korn/index.htm)
   * [IBM KornShell] (http://www.ibm.com/support/knowledgecenter/ssw_aix_72/com.ibm.aix.osdevice/korn_shell.htm)
   * [SHELLdorado] (http://www.shelldorado.com/)
   * [fpmurphy] (http://blog.fpmurphy.com/2009/01/ksh93-regular-expressions.html) Super RegExp examles
	* 

## What I have for you ##

   * CSV parser - dynamically parse csv and use set variables same name as columns name
   * date calculation - it's easy:w
   * lib.sh include some function, libusage.sh is example to use it
   * ...


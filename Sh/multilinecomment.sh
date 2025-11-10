#!/usr/local/bin/awsh
# multilinecomment.sh
# ver 2025-11-10
# github kshji
# Multi-Line Comment in Shell Script

echo "
*Multi-Line Comment in Shell Script*
tested: bash, ksh, dash, zsh
result: version 5 not work using zsh
"

: || <<+++
	Comment text is stored. Version 1.
	This text doesn't show up anywhere. It's a way to write a comment that goes on multiple lines.
+++

echo "But this part does show up. version 1."


: || {
	Comment text is stored. Version 2.
	This text doesn't show up anywhere. It's a way to write a comment that goes on multiple lines.
}

echo "But this part does show up. version 2."

if [ 1 = 2 ] ; then
	Comment text is stored. Version 3.
	This text doesn't show up anywhere. It's a way to write a comment that goes on multiple lines.
fi

echo "But this part does show up. version 3."

true || {
	Comment text is stored. Version 4.
	This text doesn't show up anywhere. It's a way to write a comment that goes on multiple lines.
}

echo "But this part does show up. version 4."

<<//
	Comment text is stored. Version 5.
	This version not work in zsh
	This text doesn't show up anywhere. It's a way to write a comment that goes on multiple lines.
//

echo "But this part does show up. version 5."

: '
	Comment text is stored. Version 6.
	This text doesn't show up anywhere. It's a way to write a comment that goes on multiple lines.
'

echo "But this part does show up. version 6."

: '/*
	Comment text is stored. Version 7.
	This text doesn't show up anywhere. It's a way to write a comment that goes on multiple lines.
	Same as version 6, but easier to understand as a comment.
*/'

echo "But this part does show up. version 7."

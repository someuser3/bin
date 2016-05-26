# .bashrc

# User specific aliases and functions

# After adding an alias run the following:
#
# . ~/.bashrc
#
# Do not forget to uncomment the line...

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias consoles='console && exit'
alias CS225='ssh root@cloud.acs.edcc.edu -p 12345'

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

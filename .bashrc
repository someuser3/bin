# .bashrc

# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias consoles='console && exit'

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

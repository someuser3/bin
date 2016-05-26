# .bash_profile

# Get the aliases and functions if running bash:
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# User specific environment and startup programs

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

HISTFILESIZE=10000
HISTSIZE=10000
export PATH

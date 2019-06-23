# Bash customizations

# use 256 colors
if which tput > /dev/null 2>&1 &&  [[ $(tput -T$TERM colors) -ge 8 ]]; then
    export TERM=xterm-256color
fi

alias topc='top -cu $USER'


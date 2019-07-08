# Bash customizations
function is_defined() {
    if which "$1" > /dev/null 2>&1; then
        return 0
    fi
    if alias "$1" > /dev/null 2>&1; then
        return 0
    fi
    return 1
}

# set aliases only if they do not match existing aliases or tools
! is_defined topc && alias topc='top -cu $USER'
! is_defined ll   && alias ll='ls -al'
! is_defined ltr  && alias ltr='ls -ltr'

## use 256 colors
if is_defined tput ; then
    [[ $(tput -T$TERM colors) -ge 8 ]] && export TERM=xterm-256color
    export PS1="\w>\[$(tput sgr0)\]"
fi

# set custom dircolors
if [[ -f ~/.dircolors ]]; then
    eval $(dircolors ~/.dircolors)
fi


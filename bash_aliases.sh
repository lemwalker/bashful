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

# TODO: build out PS1
#   move color check somewhere else. i only use color terminals
#   if ssh variables are defined, add something like "$(hostname):$(PWD)>" with colors
#   https://unix.stackexchange.com/questions/9605/how-can-i-detect-if-the-shell-is-controlled-from-ssh


## use 256 colors
if is_defined tput ; then
    [[ $(tput -T$TERM colors) -ge 8 ]] && export TERM=xterm-256color
    # "$(PWD)>" in green
    export PS1="\[\033[38;5;120m\]\w>\[$(tput sgr0)\]"
fi


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'

# TODO grep colors
# TODO less colors
fi

# Windows specific cusomizations
if [[ $(uname -v) =~ Microsoft ]]; then
    [[ -f ~/.cyg_aliases ]] && source ~/.cyg_aliases
fi

# TODO: source in local aliases?

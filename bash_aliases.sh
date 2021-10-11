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

if ! is_defined pbcopy && ! is_defined pbpaste && is_defined xclip ; then
    alias pbcopy='xclip -i'
    alias pbpaste='xclip -o'
fi

os_name="$(sed -rn "s/^PRETTY_NAME=\"([^\"]+)\"$/\1/p" /etc/os-release)"
if [[ "${os_name,,}" =~ "raspbian" ]] ; then
    dist_name="raspbian"
elif [[ "${os_name,,}" =~ "mint" ]] ; then
    dist_name="mint"
elif [[ "${os_name,,}" =~ "ubuntu" ]] ; then
    dist_name="ubuntu"
elif [[ "$os_name,,}" =~ "(stretch)" ]]; then
    # Chrome OS (stretch)
    dist_name="chromeos"
else
    dist_name="generic"
fi

## use 256 colors
if is_defined tput ; then
    [[ $(tput -T$TERM colors) -gt 8 ]] && export TERM=xterm-256color
    # "$(PWD)>" in green
    #export PS1="\[\033[38;5;120m\]\w>\[$(tput sgr0)\]"
    export GREP_COLORS='sl=49;38;5;255:cx=49;38;5;145:mt=49;92:fn=49;38;5;221:ln=49;38;5;75:bn=49;38;5;213:se=49;38;5;208';
    # less
    export LESS=-R
    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\E[38;5;147m\E[48;5;17m' # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

    case "$dist_name" in
        "mint"      ) u_col=113; h_col=157 ; d_col=149;; # mint green: 107/113 , 149, 157  ;;
        "ubuntu"    ) u_col=166; h_col=208 ; d_col=202;; # ub orange:  166/202 208,   ;;
        "raspbian"  ) u_col=161; h_col=77  ; d_col=245;; # red: 161 , green, 77 ;;
        "chromeos"  ) u_col=63 ; h_col=105 ; d_col=245;; # 63, 105 ;;
        "generic"   ) u_col=71 ; h_col=75  ; d_col=245;; # green: 71, blue: 75;;

    esac
fi

if [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" || -n "$SSH_CONNECTION" ]]; then
    export PS1="\[\033[38;5;${u_col}m\]\u\[\033[38;5;${h_col}m\]@\h:\[$(tput sgr0)\]\[\033[38;5;${d_col}m\]\w>\[$(tput sgr0)\]"
else
    export PS1="\[\033[38;5;${u_col}m\]\u\[\033[38;5;${h_col}m\]@\h:\[$(tput sgr0)\]\[\033[38;5;${d_col}m\]\w>\[$(tput sgr0)\]"
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'

fi

# Windows specific cusomizations
if [[ $(uname -v) =~ Microsoft ]]; then
    [[ -f ~/.cyg_aliases ]] && source ~/.cyg_aliases
fi

# TODO: source in local aliases?

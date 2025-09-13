#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ -f /etc/bashrc ]] && source /etc/bashrc

# Homebrew bash completion
if [[ "$OSTYPE" == *'darwin'* ]] ; then
    if [[ -x /opt/homebrew/bin/brew ]]; then
        HOMEBREW_PREFIX="/opt/homebrew";
    elif [[ -x /usr/local/Homebrew/bin/brew ]]; then
        HOMEBREW_PREFIX="/usr/local";
    fi

    [[ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]] &&
      source "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" 2> /dev/null
fi


# Don't use ^D to exit
set -o ignoreeof

shopt -s nocaseglob # Use case-insensitive filename globbing
shopt -s cdspell  # Autocorrect

# Don't put duplicate lines in the history.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups

HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls' # Ignore the ls command as well

HISTTIMEFORMAT="%F %T  "

HISTFILESIZE=
HISTSIZE=

__sync_history() {
    history -a
    history -n
}
PROMPT_COMMAND="__sync_history${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
shopt -s histappend

readonly COLOR_OFF=$'\e[0m'

__prompt_command() {
    local -r color_cwd=$'\e[1;34m'

    PS1="\t \u@\h:\[${color_cwd}\]\w\[${COLOR_OFF}\]"

    # Getting cursor position causes issue when IDE executes command in new terminal
    if [[ -n "${__PC_SEEN-}"  ]]; then
      local COL
      local ROW
      IFS=';' read -sdR -p $'\E[6n' ROW COL

      # After executing a command, if the cursor is not at the start of a new line,
      # then move to a new line before printing the prompt.
      (( COL > 1 )) && PS1="\n$PS1"
    fi


    if [[ -n "${VIRTUAL_ENV_PROMPT-}" ]]; then
        PS1+=" <venv:$VIRTUAL_ENV_PROMPT>"
    elif [[ -n "${VIRTUAL_ENV-}" ]]; then
        PS1+=" <venv:$(basename "$VIRTUAL_ENV")>"
     fi

    if [[ -n "${AWS_PROFILE-}" ]]; then
        PS1+=" <aws:$AWS_PROFILE>"
    fi

    PS1+=" $(__git_prompt)"

    PS1+="\n\$ "

    # If this is an xterm set the title to user@host:dir
    case "$TERM" in
        xterm*|rxvt*)
            PS1="\[\e]0;\u@\h: \w\a\]$PS1"
            ;;
        *) ;;
    esac

    __PC_SEEN=1
}

__git_prompt() {
    if [[ "$BASH_SUBSHELL" == 0 ]]; then
        echo "__git_prompt: Run inside subshell" >&2
        return
    fi

    pushd . > /dev/null
    # defer execution until we are sure we are in a git repo
    # sometimes, just running `git` is slow

    while : ; do
       [[ -r "$PWD/.git" ]] && break
       [[ ! -O "$PWD" ]] && return
       [[ "$PWD" == '/' ]] && return
       cd ..
    done
    popd > /dev/null

    local head
    head="$(git symbolic-ref --quiet --short HEAD 2>/dev/null \
         || git rev-parse --short HEAD 2>/dev/null)" || return
    printf '± %s' "$head"
}

PROMPT_COMMAND="__prompt_command${PROMPT_COMMAND:+; $PROMPT_COMMAND}"


__print_errcode() {
    local status=$?
    local color=$'\e[0;33m'
    echo -e "${color}code $status$COLOR_OFF"
}
trap __print_errcode ERR

_termfix() {
    stty sane
    tput init
    tput cnorm  # Turn on cursor
    #tput rmcup  # Switch back to primary page
}

ssh() {
    # Update terminal title
    case "$TERM" in
        xterm*|rxvt*)
            local ssh_host="$(command ssh -G "$@" 2>/dev/null | awk 'tolower($1)=="hostname"{print $2; exit}')" || true
            printf '\e]0;%s\a' "${ssh_host-SSH}"
            ;;
        *) ;;
    esac
    command ssh "$@" || _termfix
}


# Aliases

# Managing .dotfiles
alias dfgit='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias grep='grep --color=auto'

alias vi=vim

if [[ "$OSTYPE" == *'darwin'* ]]; then
    alias openssl="$HOMEBREW_PREFIX/bin/openssl"

    alias airport='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport'
    alias tailscale='/Applications/Tailscale.app/Contents/MacOS/Tailscale'
elif [[ "$OSTYPE" == *'linux'* ]]; then
    alias ls='ls --color=auto'
fi


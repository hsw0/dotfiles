#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias dfgit='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Don't use ^D to exit
set -o ignoreeof

# Use case-insensitive filename globbing
shopt -s nocaseglob

# Make bash append rather than overwrite the history on disk
shopt -s histappend

# Don't put duplicate lines in the history.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups

HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls' # Ignore the ls command as well

HISTTIMEFORMAT="%F %T  "

HISTFILESIZE=
HISTSIZE=

if [ -f "/usr/local/etc/bash_completion" ]; then
    source "/usr/local/etc/bash_completion"
fi

COLOR_OFF=$'\e[0m'

__prompt_command() {
    local color_cwd=$'\e[1;34m'
    PS1="\t \u@\h:${color_cwd}\w${COLOR_OFF}"

    [[ -n "${VIRTUAL_ENV-}" ]] &&  PS1+=" <venv:$(basename "$VIRTUAL_ENV")>"
    [[ -n "${AWS_PROFILE-}" ]] &&  PS1+=" <aws:$AWS_PROFILE>"
    PS1+=" $(__git_prompt)"

    PS1+="\n\$ "

    # If this is an xterm set the title to user@host:dir
    case "$TERM" in
        xterm*|rxvt*)
            PS1="\[\e]0;\u@\h: \w\a\]$PS1"
            ;;
        *) ;;
    esac
}


__git_prompt() {
  if [[ "$BASH_SUBSHELL" == 0 ]]; then
    echo "__git_prompt: Run inside subshell" >&2
    return
  fi

  while : ; do
   [[ "$PWD" == '/' ]] && return
   [[ -f "./.git/HEAD" ]] && break
   cd ..
  done

  local refs=$(< "./.git/HEAD")
  refs=${refs##*/}
  echo '±' "$refs"
}

PROMPT_COMMAND="__prompt_command${PROMPT_COMMAND:+; $PROMPT_COMMAND}"


ERRCODE() {
    local status=$?
    local color=$'\e[0;33m'
    echo -e "${color}code $status$COLOR_OFF"
}
trap ERRCODE ERR


# From bashrc_dispatch
shell_is_linux () { [[ "$OSTYPE" == *'linux'* ]] ; }
shell_is_osx () { [[ "$OSTYPE" == *'darwin'* ]] ; }


# Aliases

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias grep='grep --color=auto'

alias vi=vim

pass() {
    [[ "$1" == "show" ]] && command -v scdreset >& /dev/null &&
        scdreset > /dev/null
    command pass $@
}


if shell_is_osx ; then
    alias openssl='/usr/local/opt/openssl/bin/openssl'

    alias airport='/System/Library//PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport'
elif shell_is_linux ; then
    alias ls='ls --color'
fi

( command -v jenv >& /dev/null ) && eval "$(jenv init -)"


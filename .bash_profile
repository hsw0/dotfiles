#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

export EDITOR=vim
export PAGER=less

[[ -d "$HOME/bin" ]] && export PATH="$PATH:$HOME/bin"

umask 022


export GREP_OPTIONS='--color=auto'


gpgconf --launch gpg-agent

export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)


if shell_is_osx ; then
    export CLICOLOR=1

    export HOMEBREW_NO_GITHUB_API=1
    export HOMEBREW_NO_AUTO_UPDATE=1

    # Fix broken LC_CTYPE=UTF-8
    export LC_CTYPE=$LANG

fi


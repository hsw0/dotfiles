#
# ~/.bash_profile
#

export EDITOR=vim
export PAGER=less
export LESS='--squeeze-blank-lines --RAW-CONTROL-CHARS --use-color'
LESS+=' --color=d+39$--color=u+213$--color=s+y$--color=k+r'

export LANG=en_US.UTF-8
export LC_NUMERIC=ko_KR.UTF-8
export LC_TIME=ko_KR.UTF-8
export LC_MONETARY=ko_KR.UTF-8
unset LC_CTYPE


export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"


[[ -d "$HOME/.cargo/bin" && ! "$PATH" =~ "$HOME/.cargo/bin" ]] &&
    PATH="$HOME/.cargo/bin:$PATH"
[[ -d "$HOME/bin" && ! "$PATH" =~ "$HOME/bin" ]] &&
    PATH="$HOME/bin:$PATH"
[[ -d "$HOME/.local/bin" && ! "$PATH" =~ "$HOME/.local/bin" ]] &&
    PATH="$HOME/local/bin:$PATH"

[[ -f ~/.bashrc ]] && . ~/.bashrc

if shell_is_osx ; then
    export BASH_SILENCE_DEPRECATION_WARNING=1

    export CLICOLOR=1

    # Homebrew
    export HOMEBREW_NO_GITHUB_API=1
    export HOMEBREW_NO_AUTO_UPDATE=1

    if [[ -x /opt/homebrew/bin/brew ]]; then
        export PATH="$PATH:$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin";
        export MANPATH="$HOMEBREW_PREFIX/share/man${MANPATH+:$MANPATH}:";
        export INFOPATH="$HOMEBREW_PREFIX/share/info:${INFOPATH:-}";
    fi
fi

export DOTNET_CLI_TELEMETRY_OPTOUT=1

umask 077


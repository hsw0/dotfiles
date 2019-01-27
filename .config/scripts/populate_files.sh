#!/bin/bash

set -euo pipefail

cd "$HOME"

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

umask 0077

install -d -m 700 "$XDG_CONFIG_HOME"
install -d -m 700 "$XDG_DATA_HOME"
install -d -m 700 "$XDG_CACHE_HOME"

CACHE_DIRS=()
PRIVATE_DIRS=()
PRIVATE_FILES=()

CACHE_DIRS+=(vim/{undo,swap,backup})
CACHE_DIRS+=(gradle)
CACHE_DIRS+=(maven/repositories)
CACHE_DIRS+=(terraform/plugins)

PRIVATE_FILES=(.{sh,bash}_history)
PRIVATE_FILES=(.python_history)
PRIVATE_FILES=(.lesshst)

PRIVATE_DIRS+=($XDG_CONFIG_HOME/gnupg)
PRIVATE_FILES=($XDG_CONFIG_HOME/gnupg/*.{conf,gpg,kbx} $XDG_CONFIG_HOME/gnupg/S.*)

for path in "${CACHE_DIRS[@]}" ; do
 [[ -d "$path" ]] && continue
 mkdir -p "$XDG_CACHE_HOME/$path"
done

for path in "${PRIVATE_DIRS[@]}" ; do
 install -d -m 700 "$path"
done

for path in "${PRIVATE_FILES[@]}" ; do
 mkdir -p "$(dirname $path)"
 chmod 600 "$path"
done



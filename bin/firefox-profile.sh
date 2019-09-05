#!/bin/bash

if [[ $# -ne 1 ]]; then
 echo "Usage: $0 profile" >&2
 exit 1
fi

open -n /Applications/Firefox.app --args -no-remote -p "$1"

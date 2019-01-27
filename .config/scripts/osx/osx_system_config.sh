#!/bin/bash

if [[ $(id -u) != 0 ]]; then
 echo "This script must be run as root" >&2
 exit 1
fi

defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool true

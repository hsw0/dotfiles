#!/bin/bash

#
# 참고: 설정 목록:
# https://mosen.github.io/profiledocs/pdp/mcx.html
#

## Keyboard

# 키 반복
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain KeyRepeat -int 2

# fn 키: Function
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true

# 키보드 >  단축키 > 전체 키보드 접근 (모든 컨트롤)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool true
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

## UI

defaults write NSGlobalDomain AppleActionOnDoubleClick Maximize

defaults write NSGlobalDomain com.apple.springing.delay -float 0.5
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

defaults write com.apple.dock autohide -bool true


## Finder

defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# https://support.apple.com/ko-kr/HT208209
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true


# Finder 검색 시 현재 경로 우선
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"


defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

defaults write com.apple.NetworkBrowser DisableAirDrop -bool true


# Disable resume system-wide
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false
defaults write com.apple.loginwindow TALLogoutSavesState -bool false
defaults write com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool false

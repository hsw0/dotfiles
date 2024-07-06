#!/bin/bash

set -eu -o pipefail

main() {

#
# 현재 설정 추출: plutil -convert xml1 ~/Library/Preferences/<domain>.plist -o  /dev/stdout
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


defaults write com.apple.AppleMultitouchTrackpad "clicking" -bool true

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

defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false



# Disable resume system-wide
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false
defaults write com.apple.loginwindow TALLogoutSavesState -bool false
defaults write com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool false


# Screenshot: Remove background shadow
defaults write com.apple.screencapture disable-shadow -bool true


# 특정 애플리케이션 언어 강제 지정 - 날짜/시간 포멧팅 등등
per_app_language_bundles=(com.apple.controlcenter com.apple.dock)
defaults write NSGlobalDomain ApplePerAppLanguageSelectionBundleIdentifiers -array "${per_app_language_bundles[@]}"
for bundle in "${per_app_language_bundles[@]}" ; do

    defaults write "$bundle" AppleLanguages -array ko-KR en
done

#killall SystemUIServer ControlCenter Dock Finder

return 0
}

main "$@"
exit $?


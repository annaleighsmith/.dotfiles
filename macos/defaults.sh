#!/usr/bin/env bash

echo "Disabling press-and-hold for key repeat..."
defaults write -g ApplePressAndHoldEnabled -bool false

echo "Setting faster key repeat..."
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

echo "Configuring Finder..."
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true

echo "Configuring Dock..."
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock tilesize -int 48

echo "Setting up Screenshots folder..."
mkdir -p "$HOME/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Screenshots"
defaults write com.apple.screencapture type -string "png"

echo "Restarting affected apps..."
killall Finder Dock SystemUIServer 2>/dev/null

echo "Done!"

#!/bin/bash
# Easy stow script for migrating existing configs into stow-managed dotfiles
# 
# SETUP (one-time on new machine):
#   1. Clone your dotfiles: git clone <your-repo> ~/.dotfiles
#   2. Location matters! Must be at ~/.dotfiles for the paths to work
#   3. Create profile directories: mkdir -p ~/.dotfiles/{common,macos,linux}
#
# USAGE:
#   ./easystow.sh <profile> <package>
#   Example: ./easystow.sh common nvim
#            ./easystow.sh macos aerospace
#
# WHAT IT DOES:
#   - Checks if ~/.config/<package> exists as a real directory (not symlink)
#   - Moves it into ~/.dotfiles/<profile>/.config/
#   - Runs stow to create symlinks back to original location
#
# AFTER MIGRATION:
#   On new machines, just: cd ~/.dotfiles/<profile> && stow <package>
#   No need to run easystow again - that's only for initial migration

PROFILE="$1"  # common, macos, or linux
PACKAGE="$2"  # nvim, zsh, git, etc.

# Where the config currently lives (existing config to migrate)
CONFIGDIR="$HOME/.config/$PACKAGE"

# Where it will live in dotfiles repo (stow source)
STOWDIR="$HOME/.dotfiles/$PROFILE/.config/"

echo "Profile: $PROFILE, Package: $PACKAGE"
echo "CONFIGDIR: $CONFIGDIR"
echo "STOWDIR: $STOWDIR"

# Only proceed if:
#   - Config exists in ~/.config/
#   - Hasn't already been moved to dotfiles
#   - Isn't already a symlink (would mean it's already stowed)
if [ -d "$CONFIGDIR" ] && [ ! -d "$STOWDIR$PACKAGE" ] && [ ! -h "$CONFIGDIR" ]; then
  echo "easyStowing $PACKAGE into $PROFILE"
  
  # Create the .config directory inside the profile if it doesn't exist
  mkdir -p "$STOWDIR"
  
  # Move the entire config directory into dotfiles structure
  # mv moves the directory itself, so ~/.config/nvim becomes ~/.dotfiles/common/.config/nvim
  mv "$CONFIGDIR" "$STOWDIR"
  
  # Navigate to profile directory and stow the package
  # This creates symlink: ~/.config/nvim -> ~/.dotfiles/common/.config/nvim
  cd "$HOME/.dotfiles/$PROFILE"
  stow "$PACKAGE"
fi

#!/bin/bash
# Migrate an existing ~/.config/<package> into the dotfiles repo and stow it.
#
# USAGE:
#   ./stowit.sh <profile> <package>
#   Example: ./stowit.sh macos aerospace
#            ./stowit.sh common kitty
#
# WHAT IT DOES:
#   1. Moves ~/.config/<package> into ~/.dotfiles/<profile>/<package>/.config/<package>
#   2. Runs stow to symlink it back
#
# AFTER MIGRATION:
#   On a fresh machine, just: cd ~/.dotfiles/<profile> && stow -t ~ <package>

set -e

PROFILE="$1"
PACKAGE="$2"

if [ -z "$PROFILE" ] || [ -z "$PACKAGE" ]; then
  echo "Usage: ./stowit.sh <profile> <package>"
  echo "  profile: common, macos, or linux"
  echo "  package: e.g. aerospace, nvim, kitty"
  exit 1
fi

DOTFILES="$HOME/.dotfiles"
SOURCE="$HOME/.config/$PACKAGE"
DEST="$DOTFILES/$PROFILE/$PACKAGE/.config/$PACKAGE"

if [ -h "$SOURCE" ]; then
  echo "Error: $SOURCE is already a symlink (probably already stowed)"
  exit 1
fi

if [ ! -d "$SOURCE" ]; then
  echo "Error: $SOURCE does not exist or is not a directory"
  exit 1
fi

if [ -d "$DEST" ]; then
  echo "Error: $DEST already exists in the repo"
  exit 1
fi

echo "Migrating $PACKAGE into $PROFILE..."
echo "  From: $SOURCE"
echo "  To:   $DEST"

mkdir -p "$DOTFILES/$PROFILE/$PACKAGE/.config"
mv "$SOURCE" "$DEST"

cd "$DOTFILES/$PROFILE"
stow -t "$HOME" "$PACKAGE"

echo "Done! ~/.config/$PACKAGE is now a symlink managed by stow."

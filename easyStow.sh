#!/bin/bash

CONFIGDIR="$HOME/.config/$1/"
STOWDIR="$HOME/.dotfiles/$1/.config/"

if [ -d "$CONFIGDIR" ] && [ ! -d "$STOWDIR" ] && [ ! -h "$CONFIGDIR" ]; then
  echo "easyStowing $1"
  echo "Making $STOWDIR"
  mkdir -p "$STOWDIR"
  echo "Moving $CONFIGDIR to $STOWDIR"
  mv "$CONFIGDIR" "$STOWDIR"
  echo "Stowing $1"
  cd "$HOME/.dotfiles"
  stow "$1"
fi





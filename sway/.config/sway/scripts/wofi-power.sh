#!/bin/bash

entries="Logout\nSuspend\nReboot\nShutdown"

selected=$(echo -e $entries|wofi drun --hide-scroll --width 250 --height 150 --dmenu --cache-file /dev/null | awk '{print tolower($2)}')

case $selected in
  logout)
    swaymsg exit;;
  suspend)
    exec systemctl suspend;;
  reboot)
    exec systemctl reboot;;
  shutdown)
    exec systemctl poweroff -i;;
esac

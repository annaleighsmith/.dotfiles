#!/usr/bin/env bash

# while true;\
# do swaymsg -t subscribe '["workspace"]' >/dev/null 
test=`swaymsg -t get_workspaces -r | jq '[.[] | {output: .output, name: .name | tonumber, focused, used: true}] + [range(1;11) | {output:.output, name:., focused: false, used: false}] | unique_by(.name) | sort_by(.name) | [.[] | {focused, used}]' -cM`
echo "$test" 

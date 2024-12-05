#!/bin/bash

# Original script name: dcolors
# Description: a simple dmenu script to quickly copy the color to your clipboard
# Dependencies: dmenu
# GitLab: https://www.gitlab.com/dwt1/dmscripts
# License: https://www.gitlab.com/dwt1/dmscripts/LICENSE
# Contributors: Derek Taylor

# dependency wl-copy

declare -A colors
colors[black]="#282a36"
colors[red]="#ff5555"
colors[green]="#5af78e"
colors[yellow]="#f1fa8c"
colors[blue]="#57c7ff"
colors[magenta]="#ff6ac1"
colors[cyan]="#8be9fd"
colors[white]="#f1f1f0"
colors[orange]="#ffb86c"
colors[purple]="#bd9cf9"

selected="$(printf '%s\n' "${!colors[@]}" | dmenu -p "color:")"
[ -z $selected ] && exit
echo "${colors["${selected}"]}" | wl-copy

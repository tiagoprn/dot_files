#!/usr/bin/env bash

# Must be compiled from source, here: <https://github.com/mwh/dragon> (I have a fork in my github account)

set -eou pipefail

# SELECTED_DIR="$HOME/screenshots"
SELECTED_DIR=$(tree -L 1 -n /storage $HOME -i -d -l -f | grep -e '^/' | sort | awk '{print $1}' | rofi -dmenu -fn 'Jetbrains Mono:size=14' -c -bw 1 -p 'Choose initial directory that has the file you want to drag-and-drop')

notify-send "dm-drag-and-drop-any-file.sh" "Getting files list, this may take a while..."

dragon -a $(tree -n $SELECTED_DIR -i -l -f | grep -e '^/' | sort | rofi -dmenu -fn 'Jetbrains Mono:size=14' -c -bw 1 -p 'Choose file you want to drag-and-drop')

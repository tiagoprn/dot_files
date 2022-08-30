#!/bin/bash

# /storage/src/dot_files/tiling-window-managers/scripts/bookmarks.py

script_name=$(basename "$0")

BROWSER=$(echo -e "w3m\nfirefox\nqutebrowser.sh" | dmenu -fn 'Jetbrains Mono:size=14' -c -bw 2 -l 20 -p 'Select browser: ')
EXIT_CODE=$?
if [ "$EXIT_CODE" == 1 ]; then
    notify-send -t 700 "$script_name" "Aborted."
    exit 1
fi

BOOKMARK="$(cat ~/.config/surfraw/bookmarks | dmenu -fn 'Jetbrains Mono:size=14' -c -bw 2 -l 20 -p 'Select bookmark: ')"
EXIT_CODE=$?
if [ "$EXIT_CODE" == 1 ]; then
    notify-send -t 700 "$script_name" "Aborted."
    exit 1
fi

sr -browser="$BROWSER" "$(echo $BOOKMARK | cut -d ' ' -f 1)"

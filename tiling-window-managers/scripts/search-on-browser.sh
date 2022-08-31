#!/bin/bash

# /storage/src/dot_files/tiling-window-managers/scripts/bookmarks.py

script_name=$(basename "$0")
SURFRAW_CONFIG=/storage/src/dot_files/surfraw

# builtin search engines are at '/usr/lib/surfraw':
BUILTIN_SEARCH_ENGINES=$(cat $SURFRAW_CONFIG/curated-elvi.list | tr '\n' ' ')
CUSTOM_SEARCH_ENGINES=$(find $SURFRAW_CONFIG/elvi/ -name '*' | cut -d '/' -f 7 | tr '\n' ' ')
ALL_SEARCH_ENGINES="$BUILTIN_SEARCH_ENGINES $CUSTOM_SEARCH_ENGINES"
SEARCH_ENGINES=$(echo "$ALL_SEARCH_ENGINES" | tr ' ' '\n' | uniq | sort)

BROWSER=$(echo -e "w3m\nfirefox\nqutebrowser.sh" | dmenu -fn 'Jetbrains Mono:size=14' -c -bw 2 -l 20 -p 'Select browser: ')
EXIT_CODE=$?
if [ "$EXIT_CODE" == 1 ]; then
    notify-send -t 700 "$script_name" "Aborted."
    exit 1
fi

SEARCH_ENGINE="$(echo $SEARCH_ENGINES | tr ' ' '\n' | rofi -dmenu -fn 'Jetbrains Mono:size=14' -c -bw 1 -p 'Select search engine: ')"
EXIT_CODE=$?
if [ "$EXIT_CODE" == 1 ]; then
    notify-send -t 700 "$script_name" "Aborted."
    exit 1
else
    SEARCH_ENGINE=$(echo "$SEARCH_ENGINE" | awk '{print $1}')
fi

QUERY="$(echo '' | rofi -dmenu -fn 'Jetbrains Mono:size=14' -c -bw 1 -p 'Select the term/phrase you want to search: ')"
EXIT_CODE=$?
if [ "$EXIT_CODE" == 1 ]; then
    notify-send -t 700 "$script_name" "Aborted."
    exit 1
fi

sr -browser="$BROWSER" "$SEARCH_ENGINE" "'$QUERY'"

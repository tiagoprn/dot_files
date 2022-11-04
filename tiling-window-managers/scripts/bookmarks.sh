#!/bin/bash

HOSTNAME_USER="$(hostname).$(whoami)"

if [ "$HOSTNAME_USER" == 'cosmos.tiago' ]; then
    BOOKMARKS=$(cat "$HOME/.config/surfraw/bookmarks")
elif [ "$HOSTNAME_USER" == 'cosmos.tds' ]; then
    BOOKMARKS=$(cat "$HOME/contractors/octerra/git/octerra/config/browser.bookmarks")
fi

SELECTED_BOOKMARK=$(echo -e "$BOOKMARKS" | sort | rofi -dmenu -p "Open a browser tab and choose a bookmark:" | awk '{print $2}')

xdotool type "$SELECTED_BOOKMARK"

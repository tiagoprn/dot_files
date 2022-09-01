#!/bin/bash

WEEK_DAYS=$(/storage/src/dot_files/tiling-window-managers/scripts/next-7-days.py)

SELECTED_DATE=$(echo -e "$WEEK_DAYS" | tr ';' '\n' | fzf --border=rounded --margin=5% --preview-window=top,70% --preview='/storage/src/dot_files/tiling-window-managers/scripts/reminders-filter.sh -d {1}')

/storage/src/dot_files/tiling-window-managers/scripts/reminders-filter.sh -d "$SELECTED_DATE"

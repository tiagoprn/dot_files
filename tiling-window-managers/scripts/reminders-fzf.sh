#!/bin/bash

TODAY=$(date +%Y/%m/%d)

WEEK_DAYS=$(/storage/src/dot_files/tiling-window-managers/scripts/current-week-days.py)

SELECTED_DATE=$(echo -e $WEEK_DAYS | tr ';' '\n' | fzf --preview='/storage/src/dot_files/tiling-window-managers/scripts/reminders-filter.sh -d {1}')

/storage/src/dot_files/tiling-window-managers/scripts/reminders-filter.sh -d $SELECTED_DATE

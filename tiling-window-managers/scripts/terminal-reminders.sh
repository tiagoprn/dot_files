#!/bin/bash

SESSIONS_SCRIPT=/storage/src/dot_files/tiling-window-managers/scripts/reminders-fzf.sh

alacritty --title scratchpad_reminders -e /bin/bash -c "$SESSIONS_SCRIPT" --hold &

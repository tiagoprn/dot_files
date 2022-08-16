#!/bin/bash

set -eou pipefail

LAYOUTS_ROOT=/storage/src/dot_files/.screenlayout
LAYOUTS_PATH="$LAYOUTS_ROOT/$HOSTNAME"

# IMPORTANT: here I MUST be specific about each machine, so to warrant that the configuration that loads is specific to it.

if [[ $HOSTNAME == mobpi ]]; then
    bspc monitor HDMI-1 -d 1 2 3 4 5 6 7 8 9 10
elif [[ $HOSTNAME == cosmos ]]; then
    CHOSEN_LAYOUT=$(find "$LAYOUTS_PATH" -type f -print0 | while IFS= read -r -d $'\0' file; do echo "$file"; done | dmenu -fn 'Jetbrains Mono:size=14' -c -bw 2 -l 20 -p 'CHOOSE A MONITOR LAYOUT')
    /bin/bash $CHOSEN_LAYOUT
elif [[ $HOSTNAME == dft-sp-wkn789 ]]; then
    CHOSEN_LAYOUT=$(find "$LAYOUTS_PATH" -type f -print0 | while IFS= read -r -d $'\0' file; do echo "$file"; done | dmenu -fn 'Jetbrains Mono:size=14' -c -bw 2 -l 20 -p 'CHOOSE A MONITOR LAYOUT')
    /bin/bash $CHOSEN_LAYOUT
fi

# notify-send "setup-monitors.sh" "Restarting bspwm with chosen layout..."
# bspc wm -r
# notify-send "setup-monitors.sh" "bspwm successfully restarted."

# start polybar
/storage/src/dot_files/tiling-window-managers/scripts/polybar-launch.sh &

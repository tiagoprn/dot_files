#!/bin/bash

set -eou pipefail

LAYOUTS_ROOT=/storage/src/dot_files/.screenlayout
LAYOUTS_PATH="$LAYOUTS_ROOT/$HOSTNAME"

# IMPORTANT: here I MUST be specific about each machine, so to warrant that the configuration that loads is specific to it.

if [[ $HOSTNAME == mobpi ]]; then
    bspc monitor HDMI-1 -d 1 2 3 4 5 6 7 8 9 10
    # notify-send "$(basename $0)" "Restarting bspwm with chosen layout..."
    # bspc wm -r
    # notify-send "$(basename $0)" "bspwm successfully restarted."
    # start polybar
    /storage/src/dot_files/tiling-window-managers/scripts/polybar-launch.sh &

elif [[ $HOSTNAME == cosmos ]]; then
    LAYOUTS_PATH="$HOME/.config/autorandr/"
    CHOSEN_LAYOUT=$(find "$LAYOUTS_PATH" -maxdepth 1 ! -path "$LAYOUTS_PATH" -type d | tr '/' ' ' | awk '{print $NF}' | dmenu -fn 'Jetbrains Mono:size=12' -c -bw 1 -l 20 -p 'Let us configure monitors. The external monitor is...?')
    notify-send "$(basename $0)" "Triggering autorandr for $CHOSEN_LAYOUT external monitor..."
    autorandr -l $CHOSEN_LAYOUT

elif [[ $HOSTNAME == dft-sp-wkn789 ]]; then
    CHOSEN_LAYOUT=$(find "$LAYOUTS_PATH" -type f -print0 | while IFS= read -r -d $'\0' file; do echo "$file"; done | dmenu -fn 'Jetbrains Mono:size=14' -c -bw 2 -l 20 -p 'CHOOSE A MONITOR LAYOUT')
    /bin/bash $CHOSEN_LAYOUT
    # notify-send "$(basename $0)" "Restarting bspwm with chosen layout..."
    # bspc wm -r
    # notify-send "$(basename $0)" "bspwm successfully restarted."
    # start polybar
    /storage/src/dot_files/tiling-window-managers/scripts/polybar-launch.sh &

fi

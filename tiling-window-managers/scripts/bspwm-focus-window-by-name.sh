#!/usr/bin/env bash

WINDOW_NAME=$(wmctrl -l | dmenu -c -bw 2 -l 25 -p 'Choose a window to focus' | awk '{print $1}')
# notify-send "Focusing $WINDOW_NAME"
bspc node -f "$WINDOW_NAME"

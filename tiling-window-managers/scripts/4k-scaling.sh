#!/bin/bash

RESOLUTION=$(cat /storage/src/dot_files/4k-scaling.txt | sort | rofi -dmenu -p 'Choose a resolution to scale HDMI-1 to:' | awk '{print $1}')

if [ "$RESOLUTION" == '4K' ]; then
    xrandr --output HDMI-1 --scale 1x1
    notify-send "Resolution changed to DEFAULT ('$RESOLUTION')"
else
    xrandr --output HDMI-1 --scale-from $RESOLUTION
    notify-send "Resolution changed to '$RESOLUTION'"
fi

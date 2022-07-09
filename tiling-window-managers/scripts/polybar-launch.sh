#!/usr/bin/env bash

# More info : https://github.com/jaagr/polybar/wiki

# Install the following applications for polybar and icons in polybar if you are on ArcoLinuxD
# awesome-terminal-fonts
# Tip : There are other interesting fonts that provide icons like nerd-fonts-complete
# --log=error
# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

desktop=$(echo $DESKTOP_SESSION)

count=$(xrandr --query | grep " connected" | cut -d" " -f1 | wc -l)

POLYBAR_CONFIG='/storage/src/dot_files/tiling-window-managers/polybar/config'

case $desktop in

    bspwm|/usr/share/xsessions/bspwm)
    if type "xrandr" > /dev/null; then
      for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        MONITOR=$m polybar --reload mainbar-bspwm -c $POLYBAR_CONFIG &
      done
    else
    polybar --reload mainbar-bspwm -c $POLYBAR_CONFIG &
    fi
    # second polybar at bottom
    # if type "xrandr" > /dev/null; then
    #   for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    #     MONITOR=$m polybar --reload mainbar-bspwm-extra -c $POLYBAR_CONFIG &
    #   done
    # else
    # polybar --reload mainbar-bspwm-extra -c $POLYBAR_CONFIG &
    # fi
    ;;

esac



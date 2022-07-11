#!/bin/bash

xrandr --output DP-1 --off --output HDMI-1 --primary --mode 2560x1080 --pos 0x0 --rotate normal --output eDP-1 --off --output HDMI-2 --off

# setup bspwm
bspc monitor HDMI-1 -d 1 2 3 4 5 6 7 8 9 10

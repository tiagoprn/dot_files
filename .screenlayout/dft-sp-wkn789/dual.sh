#!/bin/bash

xrandr --output eDP-1 --primary --mode 1366x768 --pos 2560x0 --rotate normal --output HDMI-1 --mode 2560x1080 --pos 0x0 --rotate normal --output DP-1 --off --output HDMI-2 --off

# setup bspwm
bspc monitor HDMI-1 -d 1 2 3 4 5
bspc monitor eDP-1 -d 6 7 8 9 10

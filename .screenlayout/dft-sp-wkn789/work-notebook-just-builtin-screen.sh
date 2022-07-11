#!/bin/bash

xrandr --output DP-1 --off --output HDMI-1 --off --output eDP-1 --primary --mode 1366x768 --pos 0x0 --rotate normal --output HDMI-2 --off

# setup bspwm
bspc monitor DP-1 -d 1 2 3 4 5 6 7 8 9 10

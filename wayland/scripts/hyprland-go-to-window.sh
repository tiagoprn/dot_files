#!/usr/bin/env bash

COMMAND=$(hyprctl clients -j | jq -r '.[] | "\(.address)|\(.class)|\(.title)|\(.workspace.name)"' | wofi --dmenu --prompt="Select Window:" | awk -F'|' '{print "hl.dsp.focus({ window = \"address:" $1 "\" })"}')

hyprctl dispatch "$COMMAND"

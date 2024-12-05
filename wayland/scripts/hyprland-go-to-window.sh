#!/usr/bin/env bash

COMMAND=$(hyprctl clients -j | jq -r '.[] | "\(.address)|\(.class)|\(.title)|\(.workspace.name)"' | wofi --dmenu --prompt="Select Window:" | awk -F'|' '{print "focuswindow address:"$1}')

hyprctl dispatch "$COMMAND"

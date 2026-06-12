#!/usr/bin/env bash

MONITOR=$(hyprctl monitors all -j | jq -r '.[] | .name' | wofi --dmenu --prompt='Select Monitor to move current workspace to:')
hyprctl dispatch "hl.dsp.workspace.move({ monitor = \"${MONITOR}\" })"

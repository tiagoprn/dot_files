#!/usr/bin/env bash

# # move specific workspace to monitor
# hyprctl dispatch moveworkspacetomonitor <workspace> $(hyprctl monitors all -j | jq -r '.[] | .name' | fzf)

WORKSPACE=$(hyprctl workspaces -j | jq -r '.[] | "\(.id)|\(.monitor)"' | wofi --dmenu --prompt="Select Workspace:" | cut -d '|' -f 1)
MONITOR=$(hyprctl monitors all -j | jq -r '.[] | .name' | wofi --dmenu --prompt='Select Monitor to move workspace to:')

hyprctl dispatch "hl.dsp.workspace.move({ workspace = ${WORKSPACE}, monitor = \"${MONITOR}\" })"

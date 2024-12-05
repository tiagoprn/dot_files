#!/usr/bin/env bash

hyprctl dispatch movecurrentworkspacetomonitor "$(hyprctl monitors all -j | jq -r '.[] | .name' | wofi --dmenu --prompt='Select Monitor to move current workspace to:')"

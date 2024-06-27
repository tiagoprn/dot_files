#!/usr/bin/env bash

# Define the scratchpad workspace number
SCRATCHPAD_WS=-99

# Get the list of window IDs and their titles in the scratchpad workspace
windows=$(hyprctl clients | grep -B 6 "workspace: $SCRATCHPAD_WS" | grep "Window" | awk '{print $2, "(", substr($0, index($0, "->")+3), ")"}')

# Check if there are any windows
if [ -z "$windows" ]; then
    notify-send "Scratchpad" "No windows in the scratchpad"
    exit 1
fi

# Use wofi to select a window
selected_window=$(echo "$windows" | wofi --dmenu --prompt "Select a window to show")

# If no window was selected, exit
if [ -z "$selected_window" ]; then
    exit 1
fi

# Extract the window ID from the selected entry
window_id=$(echo "$selected_window" | awk '{print $1}')

# Move the selected window back to the current workspace and make it visible
current_workspace=$(hyprctl activeworkspace | head -n 1 | awk '{print $3}')
notify-send "CURRENT_WORKSPACE='$current_workspace', WINDOW_ID='$window_id'"
hyprctl dispatch movetoworkspace $current_workspace $window_id
hyprctl dispatch map $window_id

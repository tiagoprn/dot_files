#!/usr/bin/env bash

# KEYBOARD_NAME="System76 Launch Configurable Keyboard (launch_1) Keyboard"
#
# # Path to temporary file
# temp_file="/tmp/evtest_output.txt"
#
# # Run evtest with timeout and capture output to a temp file
# sudo timeout 2 stdbuf -oL evtest >"$temp_file" 2>&1
#
# # Use grep to filter and display relevant lines from the temporary file
# DEVICE=$(grep "$KEYBOARD_NAME" "$temp_file" | awk '{print $1}' | sed s/://g)
#
# # Clean up: remove the temporary file
# rm "$temp_file"
#
# echo "Keyboard input device is: '$DEVICE'"
#

# Listen for Caps Lock key press using wlrctl
wlrctl keyboard listen | grep --line-buffered "Caps_Lock" | while read -r line; do
    if echo "$line" | grep -q "pressed"; then
        # Send notification via hyprctl
        hyprctl notify "Caps Lock Pressed"
    fi
done

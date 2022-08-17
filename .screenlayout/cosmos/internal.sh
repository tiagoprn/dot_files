#!/bin/bash

# DESKTOPS_ON_HDMI1="6 7 8 9 10"
# for DESKTOP in $DESKTOPS_ON_HDMI1; do
#     is_occupied=$(bspc query --desktops --desktop $DESKTOP.occupied)
#     if ! $is_occupied; then
#         nodes=$(bspc query -N -d "$DESKTOP" | tr '\n' ' ')
#         DESTINATION_DESKTOP=$(echo $((DESKTOP - 5)))
#         echo "Desktop $DESKTOP has nodes='$nodes' on it. They will be moved to desktop $DESTINATION_DESKTOP."
#         for node_id in $nodes; do
#             echo -e "Moving $node_id from desktop $DESKTOP to desktop $DESTINATION_DESKTOP..."
#             bspc node "$node_id" -d "$DESTINATION_DESKTOP"
#         done
#     fi
# done

xrandr --output eDP-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI-1 --off --output DP-1 --off --output HDMI-2 --off --output DP-2 --off

#!/bin/bash

# reference: https://my-take-on.tech/2020/07/03/some-tricks-for-sxhkd-and-bspwm/#easily-order-windows

window_id=${1}
command=${2}

echo "window_id: ${window_id}"
echo "command: ${command}"

# Below is necessary because some window_ids have space on their name.
# So, I pass to this script with "-", and then here I change "-" to " "
# to get the window correctly below with wmctrl.
window_id=$(echo "$window_id" | sed 's/\-/ /g')

id=$(wmctrl -l | grep "$window_id" | awk '{print $1}')

echo "Looking for window $id ..."

if [ -z "${id}" ]; then
    ${command} && sleep 0.4

    # If the command below does not return any window ID, I must
    # increase the value of the sleep command above.
    new_id=$(wmctrl -l | grep $window_id | awk '{print $1}')

    bspc node "$new_id" --focus -t floating
    echo "Window $new_id focused."
else
    echo "Window $id toggled visibility."
    bspc node "$id" --flag hidden --to-monitor focused --focus -t floating
fi

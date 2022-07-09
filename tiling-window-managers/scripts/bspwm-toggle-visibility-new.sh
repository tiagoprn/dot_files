#!/bin/bash

# reference: https://my-take-on.tech/2020/07/03/some-tricks-for-sxhkd-and-bspwm/#easily-order-windows

window_id=${1}
command=${2}

echo "window_id: ${window_id}"
echo "command: ${command}"

id=$(wmctrl -l | grep $window_id | awk '{print $1}')

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


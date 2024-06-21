#!/usr/bin/env bash

option1="Close last"
option2="Close all"
option3="Bring back previous one"
option4="Invoke action on last notification"

options="$option1\n"
options="$options$option2\n"
options="$options$option3\n$option4"

choice=$(echo -e "$options" | rofi -dmenu -i -no-show-icons -l 4 -width 30 -p "Notifications")

case $choice in
    $option1)
        makoctl dismiss
        ;;
    $option2)
        makoctl dismiss --all
        ;;
    $option3)
        makoctl restore
        ;;
    $option4)
        makoctl invoke
        ;;
esac

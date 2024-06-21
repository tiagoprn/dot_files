#!/usr/bin/env bash
# based on code by Stephan Raabe (2023)

option1="  lock"
option2="  logout"
option3="  reboot"
option4="  power off"

options="$option1\n"
options="$options$option2\n"
options="$options$option3\n$option4"

choice=$(echo -e "$options" | wofi -dmenu -i -l 4 -width 10 -p "Choose wisely")

case $choice in
    $option1)
        swaylock
        ;;
    $option2)
        hyprctl dispatch exit
        ;;
    $option3)
        systemctl reboot
        ;;
    $option4)
        systemctl poweroff
        ;;
esac

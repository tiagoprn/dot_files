#!/usr/bin/env bash
# based on code by Stephan Raabe (2023)

option1="  lock"
option2="  logout"
option3="  restart gdm "
option4="  restart machine"
option5="  power off"

options="$option1\n$option2\n$option3\n$option4\n$option5\n"

choice=$(echo -e "$options" | wofi -dmenu -i -l 4 -width 10 -p "Choose wisely")

case $choice in
    $option1)
        # swaylock
        notify-send "NOT IMPLEMENTED YET, CHOOSE ANOTHER!"
        ;;
    $option2)
        hyprctl dispatch exit
        ;;
    $option3)
        sudo systemctl restart gdm
        ;;
    $option4)
        sudo shutdown -r now
        ;;
    $option5)
        sudo shutdown -h now
        ;;
esac

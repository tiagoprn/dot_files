#!/usr/bin/env bash

# Initialize status as unknown
status="Unable to determine Caps Lock status."

# Loop through all Caps Lock brightness files
for file in /sys/class/leds/input*::capslock/brightness; do
    if [ -f "$file" ]; then
        brightness=$(cat "$file")
        if [ "$brightness" -eq 1 ]; then
            status="<span color='green' size='large'><b>ON</b></span>"
            break
        else
            status="<span color='red'size='large'><b>OFF</b></span>"
        fi
    fi
done

notify-send -u normal -h string:transient:true -i keyboard "Caps Lock Status" "It's $status."

#!/usr/bin/env bash

# Initialize status as unknown
status="Unable to determine Caps Lock status."

# Loop through all Caps Lock brightness files
for file in /sys/class/leds/input*::capslock/brightness; do
    if [ -f "$file" ]; then
        brightness=$(cat "$file")
        if [ "$brightness" -eq 1 ]; then
            status="ON"
            break
        else
            status="OFF"
        fi
    fi
done

echo "CAPS: $status"

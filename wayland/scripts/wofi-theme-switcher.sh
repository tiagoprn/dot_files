#!/usr/bin/env bash

set -e

WOFI_THEME=$(find /storage/src/dot_files/wayland/wofi -type f -name "*.css" ! -type l | wofi --show dmenu)

# Check if WOFI_THEME is set and not empty
if [[ -n $WOFI_THEME ]]; then
    rm -f /storage/src/dot_files/wayland/wofi/style.css
    ln -s "$WOFI_THEME" /storage/src/dot_files/wayland/wofi/style.css
else
    echo "No theme selected"
    exit 1
fi

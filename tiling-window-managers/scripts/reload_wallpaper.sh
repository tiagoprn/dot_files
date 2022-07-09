#!/bin/bash

# If there wallpaper was not previously set by feh, set the wallpaper
# to the most recent file at ~/Wallpapers (based on the file timestamp)

WALLPAPERS_PATH=$HOME/Wallpapers
FEH_BG=$HOME/.fehbg

if [ -f $FEH_BG ]; then
    FULL_WALLPAPER_PATH=$(cat ~/.fehbg | grep feh | awk '{print $3}')
    echo "Setting the wallpaper to the one currently on ~/.fehbg: $FULL_WALLPAPER_PATH..."
    /bin/bash $FEH_BG
else
    echo "No '~/.fehbg' found, so setting the wallpaper to the most recent one at $WALLPAPERS_PATH..."
    FULL_WALLPAPER_PATH=$(find ~/Wallpapers/ -type f -printf "%T@ %p\n" | sort -n | cut -d' ' -f 2- | tail -n 1)
    echo "Full wallpaper path: $FULL_WALLPAPER_PATH"
    feh --bg-scale $FULL_WALLPAPER_PATH
fi

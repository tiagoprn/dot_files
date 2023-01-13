#!/bin/bash

notify-send "Getting remote wallpaper..." \
    && export WALLPAPER_PATH=$HOME/Wallpapers/$(date +%Y%m%d-%H%M%S-%N).jpg \
    && cd /opt/styli.sh \
    &&
    # ./styli.sh -l reddit && \
    ./styli.sh -s "$(zenity --entry --text='Choose a theme to download an wallpaper:' --entry-text='space, abstract, nature, earth, ...')" -h 1080 \
    && cp ~/.cache/styli.sh/wallpaper.jpg $WALLPAPER_PATH \
    && feh --bg-fill --auto-zoom --scale-down $WALLPAPER_PATH \
    && notify-send "Wallpaper set to $WALLPAPER_PATH ."

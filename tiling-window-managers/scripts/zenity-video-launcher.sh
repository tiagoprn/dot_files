#!/bin/bash

URL=$(zenity --entry --text "Enter a URL or a filesystem path to a video:")

if [ -z "$URL" ]; then
    zenity --info --text="No URL or file path entered, so nothing to be done." --width=400 --height=100
    exit 1
fi

i3-msg exec mpv "$URL"

MPV_PID=$(pgrep mpv)

zenity --info --text="Starting mpv for url='$URL' with pid=$MPV_PID. \n\n<b>It can take some time to start, so be patient ;)</b>" --width=400 --height=150

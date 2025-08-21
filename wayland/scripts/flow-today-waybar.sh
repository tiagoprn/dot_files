#!/usr/bin/env bash

STATUS=$(flow recent)

# notify-send -t 5000 "$STATUS"
zenity --info --title="FLOW" --text="<span font='dejavu 14'>$STATUS</span>" --width=600

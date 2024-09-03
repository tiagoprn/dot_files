#!/usr/bin/env bash

pass $(find -L ~/.password-store -type f -name "*.gpg" -printf "%P\n" | sed "s/\.gpg//" | wofi --dmenu --prompt="Select password to decrypt:") | wl-copy \
    && notify-send "Password successfully copied to the clipboard"

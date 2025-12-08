#!/usr/bin/env bash

tmp_file="/tmp/copied.txt"
tmux capture-pane -pJS -3000 >"$tmp_file"

tmux display-message -d 2000 "Current pane copied to /tmp/copied.txt. Now I will open it on nvim so you can edit it..."

tmux display-popup -E -w 90% -h 90% "nvim '-c set ft=bash' + $tmp_file" \
    && tmux display-message -d 2000 "/tmp/copied.txt edit was successfully saved!"

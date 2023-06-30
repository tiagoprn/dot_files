#!/usr/bin/env bash

# Based on original code from https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/scripts/tmux-sessionizer , all credits belong to ThePrimeagen
# Video instructions on its use here: https://youtu.be/GXxvxSlzJdI

branch_name=$(basename $1)
session_name=$(tmux display-message -p "#S")
clean_name=$(echo $branch_name | tr "./" "__")
target="$session_name:$clean_name"

if ! tmux has-session -t $target 2>/dev/null; then
    tmux neww -dn $clean_name
fi

shift
tmux send-keys -t $target "$*
"

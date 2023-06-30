#!/usr/bin/env bash

# Based on original code from https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/scripts/tmux-sessionizer , all credits belong to ThePrimeagen
# Video instructions on its use here: https://youtu.be/GXxvxSlzJdI

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(cat $HOME/.config/git-projects-bookmarks.list | fzf | awk '{print $1}')
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $selected_name -c $selected
    exit 0
fi

if ! tmux has-session -t=$selected_name 2>/dev/null; then
    tmux new-session -ds $selected_name -c $selected
fi

tmux switch-client -t $selected_name

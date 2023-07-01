#!/usr/bin/env bash

# Based on original code from https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/scripts/tmux-sessionizer , all credits belong to ThePrimeagen
# Video instructions on its use here: https://youtu.be/GXxvxSlzJdI

if [[ $# -eq 1 ]]; then
    SELECTED=$1
else
    # SELECTED=$(cat "$HOME"/.config/git-projects-bookmarks.list | fzf | awk '{print $1}')
    SELECTED=$(fzf <"$HOME"/.config/git-projects-bookmarks.list | awk '{print $1}')
fi

if [[ -z $SELECTED ]]; then
    exit 0
fi

SELECTED_NAME=$(basename "$SELECTED" | tr . _)
TMUX_RUNNING=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $TMUX_RUNNING ]]; then
    tmux new-session -s "$SELECTED_NAME" -c "$SELECTED"
    exit 0
fi

if ! tmux has-session -t="$SELECTED_NAME" 2>/dev/null; then
    tmux new-session -ds "$SELECTED_NAME" -c "$SELECTED"
fi

tmux switch-client -t "$SELECTED_NAME"

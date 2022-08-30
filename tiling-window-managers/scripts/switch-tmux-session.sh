#!/bin/bash

shopt -s expand_aliases
source "$HOME"/.bashrc

SELECTION=$(tl | fzf -e --prompt='Choose a tmux session: ')

EXIT_CODE=$?

# notify-send "EXIT_CODE=$EXIT_CODE"

if [ "$EXIT_CODE" == 0 ]; then
    # notify-send "SELECTION=$SELECTION"
    SESSION_NAME=$(echo "$SELECTION" | cut -d ':' -f 1)
    # notify-send "SESSION_NAME=$SESSION_NAME"
    tmux switch-client -t "$SESSION_NAME"
fi

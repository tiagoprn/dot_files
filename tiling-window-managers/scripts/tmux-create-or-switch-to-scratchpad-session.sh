#!/usr/bin/env bash

CURRENT_SESSION_NAME=$(tmux display-message -p '#S')

if [[ -z $CURRENT_SESSION_NAME ]]; then
    CURRENT_SESSION_NAME=$(date +'%Y%m%d_%H%M%S')
fi

SCRATCHPAD_NAME="${CURRENT_SESSION_NAME}__scratchpad"

echo "$SCRATCHPAD_NAME"

bash /storage/src/dot_files/tiling-window-managers/scripts/tmux-sessionizer.sh "$SCRATCHPAD_NAME"

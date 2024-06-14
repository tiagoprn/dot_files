#!/bin/bash

# Below orders the tmux sessions by last attached

CURRENT_SESSION=$(tmux display-message -p '#S')

tmux list-sessions -F '#{session_last_attached} #{session_name}' \
    | grep -vw "$CURRENT_SESSION" \
    | sort -rn \
    | cut -d' ' -f2- \
    | fzf -e --header="Select a session to switch to:" \
    | xargs -I {} tmux switch-client -t {}

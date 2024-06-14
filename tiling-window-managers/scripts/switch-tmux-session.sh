#!/bin/bash

# Below orders the tmux sessions by last attached
tmux list-sessions -F '#{session_last_attached} #{session_name}' \
    | sort -rn \
    | cut -d' ' -f2- \
    | fzf -e --header="Select a tmux session to attach:" \
    | xargs -I {} tmux switch-client -t {}

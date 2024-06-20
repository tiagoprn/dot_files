#!/usr/bin/env bash

# Ensure the script runs inside a tmux session
if [[ -z $TMUX ]]; then
    echo "This script should be run inside a tmux session with a single pane."
    exit 1
fi

# Ensure there's only one pane in the current tmux window
pane_count=$(tmux list-panes | wc -l)
if [[ $pane_count -ne 1 ]]; then
    echo "This script requires a single pane in the current tmux window."
    exit 1
fi

tmux split-window -v -p 30
tmux split-window -h -p 50

# Get the total number of panes
total_panes=$(tmux list-panes | wc -l)

# Iterate over all panes and send bash command "clear" to each one except for pane index 0
for ((i = 0; i < total_panes; i++)); do
    if [[ $i -ne 0 ]]; then
        tmux select-pane -t "$i"
        tmux send-keys "clear" C-m
    fi
done

# Set focus to top pane (index=0)
tmux select-pane -t 0

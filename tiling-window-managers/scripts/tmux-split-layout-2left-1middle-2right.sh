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

# Split the pane twice horizontally to get three panes
tmux split-window -h
tmux split-window -h

# Now, adjust each pane to be 33% wide
tmux select-layout even-horizontal

# Split the 1st pane vertically
tmux select-pane -t 0
tmux split-window -v

# Split the 3rd pane vertically (it's now the 4th pane after the above split)
tmux select-pane -t 3
tmux split-window -v

# Get the total number of panes
total_panes=$(tmux list-panes | wc -l)

# Iterate over all panes and send bash command "clear" to each one except for pane index 2
for ((i = 0; i < total_panes; i++)); do
    if [[ $i -ne 2 ]]; then
        tmux select-pane -t "$i"
        tmux send-keys "clear" C-m
    fi
done

# Set focus to the middle pane (3rd pane, index 2)
tmux select-pane -t 2

# Ask if the user wants to rename the session
read -p "Do you want to rename the tmux session? (y/n): " rename
if [[ $rename == "y" || $rename == "Y" ]]; then
    read -p "Enter the new session name: " session_name
    tmux rename-session -t $(tmux display-message -p '#S') "$session_name"
fi

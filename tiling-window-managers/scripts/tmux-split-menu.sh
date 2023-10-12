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

# Directory where the scripts are located
DIR="/storage/src/dot_files/tiling-window-managers/scripts"

# Use find to get all files that match the pattern "tmux-split-*" in the specified directory
# and pass them to fzf to allow user to select one of them.
SELECTED_FILE=$(find "$DIR" -type f -name "tmux-split-layout*" | fzf --prompt "Select a session layout: " --exact)

# Check if the user selected a file (i.e., didn't cancel the fzf selection)
if [ -n "$SELECTED_FILE" ]; then
    # Run the selected file
    bash "$SELECTED_FILE"
else
    echo "No file selected"
fi

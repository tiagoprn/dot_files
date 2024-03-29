#!/bin/bash

set -eou pipefail

shopt -s expand_aliases

# create a tmux session for a project
GIT_REPOS_FILE_PATH="$HOME/.config/git-projects-bookmarks.list"
if [ -f "$GIT_REPOS_FILE_PATH" ]; then
    echo "Bookmarks file exists at $GIT_REPOS_FILE_PATH \o/"
else
    echo "File DOES NOT exist at $GIT_REPOS_FILE_PATH. Creating..."
    echo -e "/storage/src/dot_files\n/storage/src/devops" >"$GIT_REPOS_FILE_PATH"
    echo "File $GIT_REPOS_FILE_PATH successfully created."
fi
SELECTED_DIR=$(cat "$GIT_REPOS_FILE_PATH" | rofi -dmenu -p "Select a git project from $GIT_REPOS_FILE_PATH (use bash alias 'bkg' do add a new one there) : " | cut -d '|' -f 1)
sleep 2
echo "Entering: '$SELECTED_DIR'..."
alacritty -e bash -c "TERM=screen-256color cd $SELECTED_DIR && /storage/src/dot_files/tiling-window-managers/scripts/tmux-ide.sh"

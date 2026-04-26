#!/bin/bash
# Prompts for a new tmux session name and creates it in the main tmux context.
# Uses tmux command-prompt (status line input) instead of display-popup,
# so the new session opens in the main window, not inside a popup.

set -euo pipefail

default_name=$(date +%Y%m%d-%H%M%S)
current_path=$(tmux display-message -p '#{pane_current_path}')

# command-prompt replaces %% with the user's input in the template.
# We use run-shell so the template is a single command (no ;) to avoid %% issues.
helper_script="/storage/src/dot_files/tiling-window-managers/scripts/tmux-new-session-helper.sh"

tmux command-prompt \
  -I "$default_name" \
  -p "Session name:" \
  "run-shell '$helper_script %% $current_path'"

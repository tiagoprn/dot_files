#!/bin/bash
# Helper script for tmux-new-session-prompt.sh
# Called by command-prompt's run-shell template with %% substitution already applied.
# Creates a new detached session then switches the current client to it.

set -euo pipefail

name="$1"
current_path="$2"

tmux new-session -d -s "$name" -c "$current_path"
tmux switch-client -t "$name"

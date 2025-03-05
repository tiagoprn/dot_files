#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

WORDS="dot_files devops nix-home-manager pde.nvim"

for WORD in $WORDS; do
    # the "n" argument will make it only create the sessions, not attach to them.
    cd "/storage/src/$WORD" && /storage/src/dot_files/wayland/scripts/tmux-ide.sh n
done

SESSION_NAME=$(tmux ls | cut -d ':' -f 1 | fzf --prompt 'Attach to session: ')

if [ -n "$TMUX" ]; then
    # Inside a tmux session: switch the current client to the desired session
    tmux switch-client -t "$SESSION_NAME"
else
    # Outside a tmux session: attach to the desired session
    tmux attach-session -t "$SESSION_NAME"
fi

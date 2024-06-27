#!/usr/bin/env bash

# $HOME/scripts/tmuxp-notes_tasks_n_reminders.sh

tmux new-session -d -s SCRATCHPAD 'sudo journalctl -f -k --since today | ccze -A'
tmux attach-session -t SCRATCHPAD

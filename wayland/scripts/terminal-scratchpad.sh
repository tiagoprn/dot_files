#!/usr/bin/env bash

tmux new-session -d -s SCRATCHPAD 'sudo journalctl -f -k --since today | ccze -A'
tmux attach-session -t SCRATCHPAD

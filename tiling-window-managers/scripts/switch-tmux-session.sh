#!/bin/bash

set -eou pipefail

shopt -s expand_aliases
source "$HOME"/.bashrc

tmux switch-client -t "$(tl | fzf -e --prompt='Choose a tmux session: ' | cut -d ':' -f 1)"

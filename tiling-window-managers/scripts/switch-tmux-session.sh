#!/bin/bash

shopt -s expand_aliases
source "$HOME"/.bashrc

tmux switch-client -t "$(tl | fzf | cut -d ':' -f 1)"

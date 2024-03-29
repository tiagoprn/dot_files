#!/usr/bin/env bash

set -eou pipefail

# if [ -d "/storage/src/fortunes/" ]; then
#     cowsay -b -f tux -W 80 $(fortune -u -e -c /storage/src/fortunes/ | tail +3)
# fi

echo -e 'TMUX GOODIES:'

# is not inside tmux:
if [ -z "${TMUX+set}" ]; then
    echo -e '- Consider opening tmux sessions with the "tp" bash alias.'
fi

echo -e '- Use "tn" or "tmux-nvim-project-setup.sh" to create a default session on a git repository'
echo -e '  with nvim, gitui and a scratchpad.'

if [[ $HOSTNAME == cosmos ]]; then
    echo -e '- To run timeshift: sudo timeshift-gtk'
fi

echo -e '- To have a monitoring dashboard (htop, bpytop and a terminal for other things): mon'

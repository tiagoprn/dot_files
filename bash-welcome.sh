#!/usr/bin/env bash

set -eou pipefail

# if [ -d "/storage/src/fortunes/" ]; then
#     cowsay -b -f tux -W 80 $(fortune -u -e -c /storage/src/fortunes/ | tail +3)
# fi

echo -e 'TMUX GOODIES:'

# is not inside tmux:
if [ -z "${TMUX+set}" ]; then
    echo -e '- Consider opening tmuxp available sessions with the "tp" bash alias. (e.g. REMOTE)'
fi

echo -e '- Use "tn" or "tmux-nvim-project-setup.sh" to create a default session on a git repository'
echo -e '  with nvim, gitui and a scratchpad.'

# if [[ $HOSTNAME == cosmos ]]; then
#     echo -e '- To run timeshift: sudo timeshift-gtk'
# fi

echo -e '==> To call navi, use <CTRL+G> when on INSERT mode. <=='

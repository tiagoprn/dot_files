#!/usr/bin/env bash

set -eou pipefail

# is not inside tmux:
if [ -z "${TMUX+set}" ]; then
    if [[ $HOSTNAME == cosmos ]]; then
        echo -e '- To run timeshift: sudo timeshift-gtk'
        echo -e '---'
    fi
fi

cowsay -b -f tux -W 80 $(fortune -u -e -c /storage/src/fortunes/ | tail +3)

# if [ -x "$(command -v figlet)" ]; then
#     echo "$(hostname)" | figlet -cptk
# fi

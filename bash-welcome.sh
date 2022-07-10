#!/usr/bin/env bash

set -eou pipefail

# is not inside tmux:
if [ -z "${TMUX+set}" ]; then
    if [[ $HOSTNAME == cosmos ]]; then
        echo -e 'To lock/unlock the GOCRYPTFS ENCRYPTED VAULT:'
        echo -e 'GET PASSWORD...: ~/vault-get-password.sh'
        echo -e 'MOUNT..........: ~/vault-mount.sh'
        echo -e 'UMOUNT.........: ~/vault-umount.sh'
        echo -e '---'
    fi
fi

cowsay -b -f tux -W 80 $(fortune -u -e -c /storage/src/fortunes/ | tail +3)

# if [ -x "$(command -v figlet)" ]; then
#     echo "$(hostname)" | figlet -cptk
# fi

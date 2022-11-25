#!/bin/bash

set -eou pipefail

shopt -s expand_aliases

script_name=$(basename "$0")

PRIVATE_KEYS=$(grep -r 'PRIVATE KEY' $HOME/.ssh | grep BEGIN | cut -d ':' -f 1 | tr '\n' ' ')

for KEY in $PRIVATE_KEYS; do
    echo "$script_name: Adding key '$KEY' to ssh-agent through keychain command..."
    KEY_NAME=$(echo $KEY | tr '/' ' ' | awk '{print $NF}')
    # echo "$KEY_NAME"
    eval $(keychain --agents ssh --eval "$KEY_NAME")
done

echo -e "\n$script_name: FINISHED. Run 'keychain --clear' to remove all identities if you need to remove all from the cache and re-add them."

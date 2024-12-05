#!/usr/bin/env bash

set -eou pipefail

shopt -s expand_aliases

SELF_NAME=$(basename "$0")

usage() {
    echo "You must run this script passing a git repo path as argument!"
    echo -e "USAGE: \n\t$SELF_NAME [git-repo-path]"
}

# set to the value of the 1st argument passed to the script. If not passed, set "default_value".
REPO_PATH=${1-""}
if [ "$REPO_PATH" == "" ]; then
    usage
    exit 1
fi

PRIVATE_KEYS=$(grep -r 'PRIVATE KEY' $HOME/.ssh | grep BEGIN | cut -d ':' -f 1 | tr '\n' ' ')

SSH_ADD_COMMANDS=""
for KEY in $PRIVATE_KEYS; do
    SSH_ADD_COMMANDS+="ssh-add $KEY && "
done

GIT_UI_CMD="exec ssh-agent bash -c '$SSH_ADD_COMMANDS cd $REPO_PATH && gitui'"

# echo "$GIT_UI_CMD"

eval "$GIT_UI_CMD"

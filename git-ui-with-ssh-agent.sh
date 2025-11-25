#!/bin/bash

set -eou pipefail

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

# Start ssh-agent and capture the environment variables
eval "$(ssh-agent -s)" >/dev/null

# Ensure the ssh-agent is killed when this script exits (successfully or due to error)
trap 'kill $SSH_AGENT_PID' EXIT

# Find files containing "PRIVATE KEY" in ~/.ssh
# We use a while loop to handle the addition of keys individually.
# If adding one key fails (e.g. password issue), it proceeds to the next.
grep -r -l 'PRIVATE KEY' "$HOME/.ssh" | while read -r KEY; do
    echo "Attempting to add identity: $KEY"
    ssh-add "$KEY" || echo "Warning: Failed to add $KEY"

    # libgit2 often requires the public key to be present alongside the private key
    if [ ! -f "$KEY.pub" ]; then
        echo "Warning: Public key file ($KEY.pub) is missing. gitui (libgit2) may fail."
    fi
done

# Navigate to the repo and run gitui
cd "$REPO_PATH"

echo "---------------------------------------------------"
echo "Diagnostics: Attempting git push --dry-run via CLI..."
git push --dry-run && echo "Success: CLI git push works." || echo "Failure: CLI git push failed."
echo "---------------------------------------------------"
read -p "Press Enter to launch lazygit..."

lazygit

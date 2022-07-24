#!/bin/bash
set -e

REPOS="/storage/src/devops /storage/src/dot_files /storage/src/bin_private /storage/docs/notes /storage/src/tiagoprnl /storage/src/gpg /storage/src/reminders /storage/docs/fleeting-notes /storage/src/iac $HOME/.password-store /storage/src/code-insights /storage/src/writeloop /storage/src/hugo-sandbox /storage/src/fortunes"

for repo in $REPOS; do
    if [ -d "$repo" ]; then
        echo -e '-----'
        cd "$repo" \
            && UPDATE_BRANCH=$(git branch | grep -e '^*' | cut -d '*' -f 2) \
            && echo " >>> Updating repository '$repo' (branch $UPDATE_BRANCH)..." \
            && git fetch \
            && git pull origin $UPDATE_BRANCH
    else
        echo -e '-----'
        echo "Repository not checked into '$repo', moving on to the next..."
    fi
done

echo -e '-----'

echo "FINISHED."

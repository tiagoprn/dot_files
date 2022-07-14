#!/bin/bash

# This script watches the clipboard.
# When it detects a new entry on it, it triggers the ./clippy-capture.py script.

set -eou pipefail

shopt -s expand_aliases

while clipnotify; do
    notify-send --urgency=low "clippy-notify.sh" "New item on clipboard. Triggering clippy-capture.py..."
    /storage/src/dot_files/tiling-window-managers/scripts/clippy-capture.py &
done

#!/bin/bash

set -eou pipefail

shopt -s expand_aliases

while clipnotify; do
    notify-send --urgency=low "clippy-notify.sh" "New item on clipboard. Triggering clippy-capture.py..."
    /storage/src/dot_files/tiling-window-managers/scripts/clippy-capture.py &
done

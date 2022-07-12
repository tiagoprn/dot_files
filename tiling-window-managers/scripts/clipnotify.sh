#!/bin/bash

set -eou pipefail

shopt -s expand_aliases

while clipnotify; do
    notify-send "clipnotify.sh" "New content available on the clipboard!"
    # TODO: copy to a temporary file in memory that gets cleaned up at each boot.
    # There are insights on how I can not save to the file if it is e.g. a password here: https://github.com/cdown/clipmenu#clipmenud-1
done

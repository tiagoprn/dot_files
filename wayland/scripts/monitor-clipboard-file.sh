#!/usr/bin/env bash

watchexec --watch /tmp/clipboard --filter 'copied.txt' /storage/src/dot_files/wayland/scripts/copy-file-clipboard-to-wayland-clipboard.sh &

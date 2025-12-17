#!/usr/bin/env bash

mkdir -p /tmp/clipboard || true \
    && echo 'Monitor clipboard file script successfully started!' >/tmp/clipboard/copied.txt \
    && watchexec --watch /tmp/clipboard --filter 'copied.txt' /storage/src/dot_files/wayland/scripts/copy-file-clipboard-to-wayland-clipboard.sh &

#!/usr/bin/env bash

WATCHEXEC_BIN=$HOME/.cargo/bin/watchexec

mkdir -p "$HOME/.local/state/hyprland" || true \
    && mkdir -p /tmp/clipboard || true \
    && echo 'Monitor clipboard file script successfully started!' >/tmp/clipboard/copied.txt \
    && $WATCHEXEC_BIN --watch /tmp/clipboard --filter 'copied.txt' /storage/src/dot_files/wayland/scripts/copy-file-clipboard-to-wayland-clipboard.sh &

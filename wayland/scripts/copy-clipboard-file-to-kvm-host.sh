#!/usr/bin/env bash

set -eou pipefail

WATCHEXEC_BIN=$HOME/.cargo/bin/watchexec

mkdir -p /tmp/clipboard || true \
    && echo "Monitor clipboard file script successfully started on $(hostname)!" >/tmp/clipboard/copied.txt \
    && $WATCHEXEC_BIN --watch /tmp/clipboard --filter 'copied.txt' time rsync --info=progress2 /tmp/clipboard/copied.txt enterprise-d:/tmp/clipboard/copied.txt

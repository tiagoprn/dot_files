#!/usr/bin/env bash

set -eou pipefail

mkdir -p /tmp/clipboard || true \
    && echo "Monitor clipboard file script successfully started on $(hostname)!" >/tmp/clipboard/copied.txt \
    && watchexec --watch /tmp/clipboard --filter 'copied.txt' time rsync --info=progress2 /tmp/clipboard/copied.txt enterprise-d:/tmp/clipboard/copied.txt

#!/usr/bin/env bash

set -eou pipefail

scp cosmos:/tmp/clipboard.txt /tmp/cosmos-clipboard.txt \
    && cat /tmp/cosmos-clipboard.txt | wl-copy \
    && notify-send 'Successfully copied from COSMOS tmux clipboard.'

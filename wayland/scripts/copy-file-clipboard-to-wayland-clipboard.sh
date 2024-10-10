#!/usr/bin/env bash

set -eou pipefail

cat /tmp/copied.txt | wl-copy \
    && notify-send 'Successfully copied from local file clipboard.'

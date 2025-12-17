#!/usr/bin/env bash

set -eou pipefail

scp kvm:/tmp/clipboard/copied.txt /tmp/clipboard/copied.txt \
    && cat /tmp/clipboard/copied.txt | wl-copy \
    && notify-send 'Successfully copied from KVM file clipboard to local file clipboard.'

#!/usr/bin/env bash

set -eou pipefail

scp kvm-labs:/tmp/clipboard/copied.txt /tmp/clipboard/copied.txt \
    && cat /tmp/clipboard/copied.txt | wl-copy \
    && notify-send 'Successfully copied from KVM-LABS file clipboard to local file clipboard.'

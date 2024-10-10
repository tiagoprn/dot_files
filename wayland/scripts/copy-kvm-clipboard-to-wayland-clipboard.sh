#!/usr/bin/env bash

set -eou pipefail

scp kvm:/tmp/copied.txt /tmp/copied.txt \
    && cat /tmp/copied.txt | wl-copy \
    && notify-send 'Successfully copied from KVM file clipboard to local file clipboard.'

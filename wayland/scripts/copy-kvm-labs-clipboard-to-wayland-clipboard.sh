#!/usr/bin/env bash

set -eou pipefail

scp kvm-labs:/tmp/copied.txt /tmp/copied.txt \
    && cat /tmp/copied.txt | wl-copy \
    && notify-send 'Successfully copied from KVM-LABS file clipboard to local file clipboard.'

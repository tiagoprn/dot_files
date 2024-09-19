#!/usr/bin/env bash

set -eou pipefail

scp kvm:/tmp/clipboard.txt /tmp/kvm-clipboard.txt \
    && cat /tmp/kvm-clipboard.txt | wl-copy \
    && notify-send 'Successfully copied from KVM tmux clipboard.'

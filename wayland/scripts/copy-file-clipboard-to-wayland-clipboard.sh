#!/usr/bin/env bash

set -eou pipefail

cat /tmp/clipboard/copied.txt | wl-copy

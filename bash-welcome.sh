#!/usr/bin/env bash

set -eou pipefail

cowsay -b -f duck -W 80 $(fortune -u -e -c /storage/src/fortunes/ | tail +3)

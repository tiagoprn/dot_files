#!/usr/bin/env bash
/storage/src/dot_files/tiling-window-managers/scripts/public-ip-address.sh \
    && echo $(xclip -i -selection clipboard -o)

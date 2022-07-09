#!/bin/bash

export ZETTEL_SEARCH=$(echo -e "#keyword\n@tag\nword" | dmenu -fn Terminus:size=14 -c -bw 2 -l 20 -g 4 -p 'Select an item: ') && vim-fzf-search "$ZETTEL_SEARCH"

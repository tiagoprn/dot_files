#!/bin/bash

set -eou pipefail

shopt -s expand_aliases

DEFAULT_SUBREDDITS_FILE=~/.config/styli.sh/subreddits

CHOSEN_THEME=$(fd list | rofi -dmenu -fn 'Jetbrains Mono:size=14' -c -bw 1 -p 'Choose a subreddit wallpapers style')
rm $DEFAULT_SUBREDDITS_FILE || /bin/true
ln -s $CHOSEN_THEME $DEFAULT_SUBREDDITS_FILE

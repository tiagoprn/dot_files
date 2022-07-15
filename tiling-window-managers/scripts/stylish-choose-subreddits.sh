#!/bin/bash

set -eou pipefail

shopt -s expand_aliases

STYLISH_CONFIG_ROOT=$HOME/.config/styli.sh
DEFAULT_SUBREDDITS_FILE=$STYLISH_CONFIG_ROOT/subreddits

CHOSEN_THEME=$(fd list $STYLISH_CONFIG_ROOT | rofi -dmenu -fn 'Jetbrains Mono:size=14' -c -bw 1 -p 'Choose a subreddit wallpapers style')
rm $DEFAULT_SUBREDDITS_FILE || /bin/true
ln -s $CHOSEN_THEME $DEFAULT_SUBREDDITS_FILE

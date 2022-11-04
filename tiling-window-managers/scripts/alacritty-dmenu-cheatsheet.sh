#!/bin/bash

/storage/src/dot_files/tiling-window-managers/scripts/alacritty-print-cheatsheet.sh | sed 's/&/&amp;/g' | rofi -dmenu -p 'Filter an alacritty terminal shorcut'

#!/bin/bash

alacritty-print-cheatsheet.sh | sed 's/&/&amp;/g' | dmenu -fn 'Jetbrains Mono:size=14' -c -bw 2 -l 20 -p 'Filter an alacritty terminal shorcut'

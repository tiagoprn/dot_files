#!/bin/bash

# cat /storage/src/devops/cheats/commands/clifm.txt | dmenu -fn Terminus:size=14 -c -bw 2 -l 20 -p 'Filter a clifm command:'
cat /storage/src/devops/cheats/commands/clifm.txt | sort | rofi -dmenu -p 'Filter a clifm command:'

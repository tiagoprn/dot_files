#!/bin/bash

STATUS=$(xset -q | grep Caps | sed 's/0[0-2]://g' | sed 's/off/off,/g' | sed 's/on/on,/g' | sed 's/.$//' | tr -s ' ' | tr '[a-z]' '[A-Z]' | sed 's/,/ | /g' | sed 's/LOCK//g' | sed 's/ ://g' | sed 's/  / /g' | sed 's/ | /|/g' | sed 's/CAPS/CAP/g' | sed 's/SCROLL/SCR/g' | cut -d '|' -f 1)

echo -e "$STATUS "

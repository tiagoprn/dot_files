#!/bin/bash

SLEEP_SECONDS=0.3

CONTENTS=$(cat /storage/src/dwm-flexipatch/config.h | grep 'description: ' | sed 's/{ //g' | sed 's/ }//g'  | sed 's/\/\* description: //g' | sed 's/\*\//=>/g' | sed 's/,//g' | sed 's/\\$//g' | sed 's/\t/ /g' | sed 's/ \+/ /g' | sed 's/MODKEY/SUPER/g' | sed 's/ShiftMask/Shift/g'| sed 's/ControlMask/Ctrl/g' | sed 's/Mod1Mask/Alt/g' | sed 's/|/\+/g' | sed 's/ XK_/\+/g' | sed 's/spawn SHCMD(//g' | sed 's/)$//g' | sed 's/TAGKEYS(//g' | sed 's/STACKKEYS(//g' | sort)

urxvt --hold -name Cheatsheet -title Cheatsheet -e /bin/bash -c "echo '$CONTENTS' | peco" &
# alacritty --title Cheatsheet --class Cheatsheet -e /bin/bash -c "echo '$CONTENTS' | peco" --hold &

sleep "$SLEEP_SECONDS" && \
	WINDOW_ID=$(wmctrl -l | grep 'Cheatsheet' | awk '{print $1}') && \
	bspc node "$WINDOW_ID" --focus -t fullscreen


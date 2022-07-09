#!/bin/bash

SNIPS=/storage/src/dot_files/text_snippets

FILE=$(ls $SNIPS | rofi -dmenu -p 'Select a snippet to be pasted on your current cursor position')

if [ -f $SNIPS/$FILE ]; then
	DATA=$([ -x "$SNIPS/$FILE" ] && bash "$SNIPS/$FILE" || head --bytes=-1 $SNIPS/$FILE)
	printf "$DATA" | xclip -selection clipboard
	printf "$DATA" | xclip -selection primary
	sleep 1
	xdotool key shift+Insert
fi

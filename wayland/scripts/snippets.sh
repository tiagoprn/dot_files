#!/usr/bin/env bash

# TODO: search with AI alternatives try to add a preview of the contents of the selected snippet

SNIPS=/storage/src/dot_files/text_snippets

FILE=$(ls $SNIPS | wofi --dmenu --prompt='Select a snippet to be pasted on your current cursor position')

if [ -f $SNIPS/$FILE ]; then
    DATA=$([ -x "$SNIPS/$FILE" ] && bash "$SNIPS/$FILE" || head --bytes=-1 $SNIPS/$FILE)
    # printf "$DATA" | wl-copy
    printf "$DATA" | ydotool type --file -
fi

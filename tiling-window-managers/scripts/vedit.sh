#!/bin/bash

# Edit text from current window into vim

TEMP_FILE=/tmp/textfield.txt
SLEEP_SECONDS=2

notify-send "Calling edit script..." && \
	> $TEMP_FILE && \
	notify-send "Move to the window that has your text now ($SLEEP_SECONDS seconds remaining)..." && sleep $SLEEP_SECONDS && \
	xdotool getwindowfocus windowfocus key ctrl+a ctrl+c && \
	urxvt -name universal_text_editor -title universal_text_editor --hold -e vim -c 'norm "+p' $TEMP_FILE && \
	cat /tmp/textfield.txt | xclip -selection clipboard && \
	notify-send "Copied to clipboard, move to the window to paste now ($SLEEP_SECONDS seconds remaining)..." && sleep $SLEEP_SECONDS && \
	xdotool getwindowfocus windowfocus key ctrl+a ctrl+v

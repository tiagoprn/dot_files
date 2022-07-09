#!/bin/bash

NOTIFICATION_MILISSECONDS=5000

DUNST_PID=$(pidof dunst)
if [ -z "$DUNST_PID" ]; then
	nohup dunst &
	notify-send -t $NOTIFICATION_MILISSECONDS "dunst started with PID $(pidof dunst)."
else
	notify-send -t $NOTIFICATION_MILISSECONDS "dunst is running with PID $(pidof dunst), so nothing to be done..."
fi


#!/bin/bash

NOTIFICATION_MILISSECONDS=5000

SYSTRAY_PID=$(pidof stalonetray)
if [ -z "$SYSTRAY_PID" ]; then
	notify-send -t $NOTIFICATION_MILISSECONDS "stalonetray not running, starting it..."
	nohup stalonetray >> /tmp/stalonetray.logs 2>&1 &
	notify-send -t $NOTIFICATION_MILISSECONDS "stalonetray started with PID $(pidof stalonetray)."
else
	notify-send -t $NOTIFICATION_MILISSECONDS "stalonetray is running with PID $(pidof stalonetray), killing it..."
	pkill stalonetray &
	notify-send -t $NOTIFICATION_MILISSECONDS "stalonetray successfully killed."
fi


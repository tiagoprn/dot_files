#!/bin/bash

LOG_FILE=/tmp/xprofile.$(date +%Y-%m-%d).log

_isRunning() {
	## function to check if a process is alive and running:
	ps -o args= -C "$1" 2>/dev/null | grep -x "$1" >/dev/null 2>&1
	ps aux | grep "$1" 2>/dev/null | grep -v "grep" >/dev/null 2>&1
}

PROCESS_NAME=picom

if ! _isRunning $PROCESS_NAME; then
	notify-send -u critical "Compositor $PROCESS_NAME will be turned ON..."
	picom --config ~/picom.conf --backend glx &
else
	notify-send -u critical "Compositor $PROCESS_NAME will be turned OFF..."
	pkill picom
fi


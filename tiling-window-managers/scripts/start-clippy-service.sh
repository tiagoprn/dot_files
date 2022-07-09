#!/bin/bash

_isRunning() {
	## function to check if a process is alive and running:
	ps -o args= -C "$1" 2>/dev/null | grep -x "$1" >/dev/null 2>&1
	ps aux | grep "$1" 2>/dev/null | grep -v "grep" >/dev/null 2>&1
}

notify-send "Starting clippy (clipboard daemon)..."
_isRunning clippy || $HOME/apps/scripts/bin/clippy.py &

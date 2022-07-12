#!/bin/bash

PROCESS_NAME=screenkey

pgrep $PROCESS_NAME

RETURN_CODE=$?

if [ $RETURN_CODE -eq 0 ]; then
    pkill $PROCESS_NAME
    notify-send -u critical "$PROCESS_NAME was turned OFF."
else
    notify-send -u critical "$PROCESS_NAME was turned ON."
    $PROCESS_NAME &
fi

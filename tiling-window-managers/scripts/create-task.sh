#!/bin/bash

TASKS_DIR="/storage/src/tasks"

TIMESTAMP="$(date "+%Y-%m-%d-%H%M%S-%3N")"
FILENAME=$TIMESTAMP.md
FILENAME_FULL="$TASKS_DIR/$FILENAME"

nvim "$FILENAME_FULL" +"normal!ggItask"

#!/bin/bash

# Creates a task file inside the current folder

CARDS_DIR=/storage/docs/notes/tasks
TIMESTAMP="$(date "+%Y-%m-%d-%H%M%S-%3N")"
FILENAME=$CARDS_DIR/$TIMESTAMP.md

mkdir -p $CARDS_DIR

vim "$FILENAME" +'normal!ggItask'


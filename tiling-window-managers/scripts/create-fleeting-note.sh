#!/bin/bash

# based on: https://www.youtube.com/watch?v=zB_3FIGRWRU&feature=youtu.be

FLEETING_NOTES_DIR=/storage/docs/fleeting-notes
TIMESTAMP=$(date '+%Y-%m-%d-%H-%M-%S')
FILENAME=$FLEETING_NOTES_DIR/$TIMESTAMP.md

mkdir -p $FLEETING_NOTES_DIR

nvim -c "norm Iqheader " \
    -c 'norm gg$' \
    -c "startinsert" \
    $FILENAME

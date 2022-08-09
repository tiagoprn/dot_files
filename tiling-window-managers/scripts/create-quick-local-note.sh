#!/bin/bash

# based on: https://www.youtube.com/watch?v=zB_3FIGRWRU&feature=youtu.be

QUICKNOTES_DIR=$HOME/tmp/notes
TIMESTAMP="$(date '+%Y-%m-%d')"
FILENAME="$QUICKNOTES_DIR/$TIMESTAMP.md"

mkdir -p "$QUICKNOTES_DIR"

echo "Creating quick local note at '$FILENAME'..."
read -n 1 -s -r -p "Press any key to continue: "

if [ ! -f "$FILENAME" ]; then
    echo "# Notes for $TIMESTAMP" >"$FILENAME"
fi

nvim -c "norm Go" \
    -c "norm Go## $(date +%H:%M)" \
    -c "norm G2o" \
    -c "norm zz" \
    -c "startinsert" \
    "$FILENAME"

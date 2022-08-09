#!/bin/bash

# Creates a flashcard file inside the current folder
DRAFTS_DIR="/storage/src/writeloop-raw/content/drafts"

TIMESTAMP="$(date "+%Y-%m-%d-%H%M%S-%3N")"
FILENAME=$TIMESTAMP.md
FILENAME_FULL="$DRAFTS_DIR/$FILENAME"

nvim "$FILENAME_FULL" +'normal!ggIflashcard' && echo "Created draft flashcard at '$FILENAME_FULL'."

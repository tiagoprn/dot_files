#!/bin/bash

# Creates a flashcard file inside the current folder
DRAFTS_DIR="/storage/src/writeloop-raw/content/drafts"

TIMESTAMP="$(date "+%Y-%m-%d-%H%M%S-%3N")"
FILENAME=$TIMESTAMP.md
FILENAME_FULL="$DRAFTS_DIR/$FILENAME"

CATEGORY=$(echo -e 'post\nshort\nbib-note\nflashcard' | fzf --prompt='Choose a category > ')

echo "Creating draft $CATEGORY at '$FILENAME_FULL'..."
read -n 1 -s -r -p "Press any key to continue: "

nvim "$FILENAME_FULL" +"normal!ggI$CATEGORY"

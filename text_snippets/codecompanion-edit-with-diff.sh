#!/usr/bin/env bash

# zenity --info --title="CodeCompanion Cheatsheet" --text="<span font='14'>(select some text in neovim, enter command mode with : then run the command pasted on the clipboard)\n\nJump to next diff: <span color='red'>]c</span>\nJump to prev diff: <span color='red'>[c</span>\nPull changes from the other window: <span color='red'>do</span> (diff obtain)\nPush changes to other window: <span color='red'>dp</span> (diff put)\nTurn off diff mode: <span color='red'>:diffoff</span>\nClose CodeCompanion buffer: <span color='red'>Delete</span></span>" --ok-label="Got it!" --width=900
#
# BASE_COMMAND='CodeCompanionChat #buffer{watch} '
# echo "$BASE_COMMAND"

# Path to the HTML content file
CONTENT_FILE="/storage/src/devops/cheats/html/codecompanion.html"

# Read the file, strip excessive whitespace and newlines, and format for zenity
FORMATTED_CONTENT=$(cat "$CONTENT_FILE" | tr -s ' ' | tr '\n' ' ')

# Display the cheatsheet using zenity
zenity --info --title="CodeCompanion Cheatsheet" --text="$FORMATTED_CONTENT" --ok-label="Got it!" --width=900

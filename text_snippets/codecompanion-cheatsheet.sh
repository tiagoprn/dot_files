#!/usr/bin/env bash

# Path to the HTML content file
CONTENT_FILE="/storage/src/devops/cheats/html/codecompanion.html"

# Read the file, strip excessive whitespace and newlines, and format for zenity
FORMATTED_CONTENT=$(cat "$CONTENT_FILE" | tr '\n' ' ')

echo "$FORMATTED_CONTENT"

# Display the cheatsheet using zenity
zenity --info --title="CodeCompanion Cheatsheet" --text="$FORMATTED_CONTENT" --ok-label="Got it!" --width=900

print '' # this is only to not copy anything to the clipboard, since I only want to show the cheatsheet.

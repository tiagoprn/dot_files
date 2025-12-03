#!/usr/bin/env bash

CHEATSHEETS=/storage/src/devops/cheats/commands/

# Use fd with full paths (-a for absolute paths)
FILE=$(fd -t f -a . "$CHEATSHEETS" | tv --preview-size 65 --preview-command 'bat -n --color=always {}')

if [ $? -ne 0 ]; then
    exit 0
fi

if [ -n "$FILE" ]; then
    echo "Selected: $FILE" # Debug line - remove later

    # Since FILE already contains the full path (due to -a flag), use it directly
    if [ -f "$FILE" ]; then
        # Open the file
        clear
        echo -e "I will now open nvim so that you can now view or edit the file..."
        sleep 2
        cd "$CHEATSHEETS" && nvim "$FILE"
    else
        echo "Error: File not found: $FILE"
    fi
fi

#!/usr/bin/env bash

SNIPS=/storage/src/dot_files/text_snippets

# Use fd with full paths (-a for absolute paths)
FILE=$(fd -t f -a . "$SNIPS" | tv --preview-size 65 --preview-command 'bat -n --color=always {}')

if [ $? -ne 0 ]; then
    exit 0
fi

if [ -n "$FILE" ]; then
    echo "Selected: $FILE" # Debug line - remove later

    # Since FILE already contains the full path (due to -a flag), use it directly
    if [ -f "$FILE" ]; then
        # Check if file is executable and run it, otherwise just read the content
        if [ -x "$FILE" ]; then
            DATA=$(bash "$FILE")
        else
            DATA=$(head --bytes=-1 "$FILE")
        fi

        # Set trap to type the data when script exits (only if DATA is not empty)
        if [ -n "$DATA" ]; then
            # trap "sleep 2 && printf '%s' '$DATA' | ydotool type --file -" EXIT
            trap "echo '$DATA' > /tmp/copied.txt" EXIT
        fi
    else
        echo "Error: File not found: $FILE"
    fi
fi

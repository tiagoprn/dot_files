#!/usr/bin/env bash

#
# This uses "television" (https://github.com/alexpasmantier/television?tab=readme-ov-file) to select the desired prompt file.
#

AI_PROMPTS_DIR=/storage/src/ai-prompts

# Debug: Check if directory exists and has files
if [ ! -d "$AI_PROMPTS_DIR" ]; then
    echo "Error: Directory $AI_PROMPTS_DIR does not exist"
    exit 1
fi

# Use fd with full paths (-a for absolute paths)
selected_file=$(fd -t f -a . "$AI_PROMPTS_DIR" | tv --preview-size 65 --preview-command 'bat -n --color=always {}')

if [ -n "$selected_file" ]; then
    echo "Selected: $selected_file" # Debug line - remove later
    extension="${selected_file##*.}"
    temp_file=$(mktemp --suffix=".$extension")
    cat "$selected_file" >"$temp_file"

    # Cleanup temp file when script exits, but copy to clipboard first
    trap "cat '$temp_file' | wl-copy; rm -f '$temp_file'" EXIT

    nvim "$temp_file"
fi

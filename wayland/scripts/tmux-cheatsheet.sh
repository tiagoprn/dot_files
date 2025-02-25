#!/usr/bin/env bash

# Define the path to your tmux conf file
TMUX_CONF="$HOME/.tmux.conf"

# Read all lines containing '#@' into an array
mapfile -t LINES < <(grep '#@' "$TMUX_CONF")

# Prepare formatted entries with bold descriptions using pango markup
FORMATTED_ENTRIES=()
for line in "${LINES[@]}"; do
    # Split the line at '#@ ' into the command and description
    cmd_part=$(echo "$line" | awk -F'#@' '{print $1}')
    desc_part=$(echo "$line" | awk -F'#@' '{print $2}')

    # Format the description part in bold
    formatted="<span weight='bold' foreground='white'> -- ${desc_part}</span>"
    # Combine parts (ensure cmd_part is included if needed)
    full_line="<span style='italic' foreground='#B0B0B0'>${cmd_part}</span>${formatted}"
    FORMATTED_ENTRIES+=("$full_line")
done

# Display the formatted entries with rofi and capture the selected index
INDEX=$(printf "%s\n" "${FORMATTED_ENTRIES[@]}" | wofi --show dmenu --prompt "Select a binding:" --allow-markup)

# Check if a valid index was selected
if [[ -n $INDEX ]]; then
    # Retrieve the original line using the index
    SELECTED_LINE="${LINES[$INDEX]}"
    # Send a notification with the original line (without markup)
    notify-send "Tmux Binding" "$SELECTED_LINE"
fi

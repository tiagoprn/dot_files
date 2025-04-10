#!/usr/bin/env bash

# Define the path to your tmux conf file
TMUX_CONF="$HOME/.tmux.conf"

# Read all lines containing '#@' into an array
mapfile -t LINES < <(grep '#@' "$TMUX_CONF")

# Function to escape HTML special characters
escape_html() {
    echo "$1" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g; s/'"'"'/\&apos;/g'
}

# Prepare formatted entries with bold descriptions using pango markup
FORMATTED_ENTRIES=()
for line in "${LINES[@]}"; do
    [[ $line =~ ^[[:space:]]*# ]] && continue

    # Split the line at '#@' into the command and description
    cmd_part=$(echo "$line" | awk -F'#@' '{print $1}')
    desc_part=$(echo "$line" | awk -F'#@' '{print $2}')

    # Escape HTML special characters in both parts
    cmd_part_escaped=$(escape_html "$cmd_part")
    desc_part_escaped=$(escape_html "$desc_part")

    # Format the description part in bold
    formatted="<span weight='bold' foreground='white'> -- ${desc_part_escaped}</span>"
    # Combine parts (ensure cmd_part is included if needed)
    full_line="<span style='italic' foreground='#B0B0B0'>${cmd_part_escaped}</span>${formatted}"
    FORMATTED_ENTRIES+=("$full_line")
done

# Display the formatted entries with wofi and capture the selected line
selected=$(printf "%s\n" "${FORMATTED_ENTRIES[@]}" | wofi --show dmenu --prompt "Select a binding:" --allow-markup)

# Check if something was selected
if [[ -n $selected ]]; then
    # Extract the description part from the selected line to match against original lines
    selected_desc=$(echo "$selected" | grep -o " -- .*</span>" | sed 's/ -- //;s/<\/span>//')
    selected_desc=$(echo "$selected_desc" | sed 's/&lt;/</g; s/&gt;/>/g; s/&amp;/\&/g; s/&quot;/"/g; s/&apos;/'"'"'/g')

    # Find the matching original line
    for line in "${LINES[@]}"; do
        desc=$(echo "$line" | awk -F'#@' '{print $2}' | xargs)
        if [[ $desc == "$selected_desc" ]]; then
            notify-send "Tmux Binding" "$line"
            break
        fi
    done
fi

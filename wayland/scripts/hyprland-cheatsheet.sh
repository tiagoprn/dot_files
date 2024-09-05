#!/usr/bin/env bash

# Define the path to your hyprland.conf file
HYPRLAND_CONF="$HOME/.config/hypr/binds.conf"

# Temporary file to hold the menu entries
menu_entries=$(mktemp)

# Read the hyprland config file line by line
while IFS= read -r line; do
    # Check if the line starts with "bind"
    if [[ $line =~ ^bind ]]; then
        # Extract the part after the "=" sign
        binding_info=$(echo "$line" | cut -d '=' -f 2-)

        # Split the content by ","
        IFS=',' read -r -a parts <<<"$binding_info"

        # Assign the parts to variables
        binding="${parts[0]}, ${parts[1]}"
        description="<span weight='bold' foreground='white'>${parts[2]}</span>"
        command="<span style='italic' foreground='#B0B0B0'>${parts[4]}</span>"

        # Determine if it's a bash or dispatch command
        if [[ ${parts[3]} =~ "exec" ]]; then
            type="bash"
        else
            type="dispatch"
        fi

        # Add to the menu entries
        echo "$binding, $description, $type" >>"$menu_entries"
    fi
done <"$HYPRLAND_CONF"

# Sort the menu entries alphabetically
sort "$menu_entries" -o "$menu_entries"

# Display the menu with Wofi, enabling pango markup
SELECTED_ENTRY=$(cat "$menu_entries" | wofi --show dmenu --prompt "Select a binding:" --allow-markup)

# Send notification with the full binding and the command

# MESSAGE=$(echo "$SELECTED_ENTRY" | awk -F ', ' '{printf "BINDING: %s %s\nTYPE: %s\nDESCRIPTION: %s", $1, $2, $4, $3}')
MESSAGE=$(echo "$SELECTED_ENTRY" | awk -F ', ' '{
    # Remove Pango markup from the description (third field)
    gsub(/<[^>]*>/, "", $3);
    # Print the formatted output
    printf "BINDING: %s %s\nTYPE: %s\nDESCRIPTION: %s", $1, $2, $4, $3
}')

notify-send "$MESSAGE"

# Clean up
rm "$menu_entries"

#!/usr/bin/env bash

# Extract clients info from hyprctl
clients_json=$(hyprctl clients -j)

# Parse the JSON and get clients in the special workspace
special_clients=$(echo "$clients_json" | jq -r '.[] | select(.workspace.name == "special:special") | "\(.address) \(.class) (\(.title))"')

# Check if there are any clients in the special workspace
if [ -z "$special_clients" ]; then
    echo "No windows found in the special workspace."
    exit 1
fi

# Use fzf to select one of the clients
selected_client=$(echo "$special_clients" | fzf --prompt="Select a window to move to workspace 1: " | awk '{print $1}')

# Check if a client was selected
if [ -z "$selected_client" ]; then
    echo "No window selected."
    exit 1
fi

echo "SELECTED_CLIENT=$selected_client"

# Move the selected window to workspace 1
hyprctl dispatch movetoworkspace 1 $selected_client

echo "Moved window $selected_client to workspace 1."

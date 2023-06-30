#!/bin/bash

set -eou pipefail

shopt -s expand_aliases

SCRIPT_NAME=$(basename "$0")

validate_input() {
    case $1 in
        [Yy] | [Nn]) return 0 ;;
        *) return 1 ;;
    esac
}

# TODO: informar como opcional a session_window_and_pane diretamente. Assim, posso usar no nvim também.

# Initialize the variable
session_window_list=""

# Get the list of tmux sessions
sessions=$(tmux list-sessions -F "#S")

# Iterate over sessions
for session in $sessions; do
    # Get the list of windows for the current session
    windows=$(tmux list-windows -t "$session" -F "#I #W")

    # Iterate over windows and append their names
    while read -r window; do
        session_window_list+="\n$session $window"
    done <<<"$windows"
done

# Remove leading newline character
session_window_list="${session_window_list#\\n}"

# Print the session and window list
sorted_list=$(echo -e "$session_window_list" | sort)

selected_session_window=$(echo -e "$sorted_list" | fzf --prompt "Select a session and window to run the command... ")

session_window=$(echo "$selected_session_window" | awk '{print $1, $2}' | tr " " ":")

echo -e "Great! Selected session:window = $session_window"

valid_pane_number=false

while [[ $valid_pane_number == false ]]; do
    echo "Please enter a pane number:"
    read pane_number

    # Validate if the input is an integer
    re='^[0-9]+$'
    if [[ $pane_number =~ $re ]]; then
        valid_pane_number=true
    else
        echo "Invalid pane number. Please enter a valid pane number."
    fi
done

echo "You entered pane number: $pane_number"

session_window_and_pane=$(echo "$session_window.$pane_number")

read -rp "Type the command you want to run on '$session_window_and_pane': " command

read -rp "Are you ready to run '$command' on '$session_window_and_pane'? (Y/N) " user_input

while ! validate_input "$user_input"; do
    read -rp "Invalid input. Please enter Y or N: " user_input
done

if [[ $user_input =~ [Yy] ]]; then
    tmux send-keys -t "$session_window_and_pane" "$command" Enter
else
    echo "Exiting..."
    exit 0
fi

# TODO: put this on tmux.conf, as <Enter>

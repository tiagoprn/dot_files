#!/bin/bash

help() {
    echo "Usage: $0 [-s session_window] [-p pane_number] [-c command]"
    echo
    echo "Options:"
    echo "  -s, --session-window  Specify the session and window. Format should be <session>:<window>"
    echo "  -p, --pane            Specify the pane number"
    echo "  -c, --command         Specify the command to run"
    echo
    echo "Examples:"
    echo "  $0 -s 0:1 -p 1 -c \"ls -l\""
    echo "  $0 --session-window 0:1 --pane 1 --command \"ls -l\""
    echo "  $0 -s 0:1 -p 1        (Prompts for command)"
    echo "  $0 -s 0:1             (Prompts for pane and command)"
    echo "  $0                    (Prompts for session, window, pane, and command)"
}

validate_input() {
    case $1 in
        [Yy] | [Nn]) return 0 ;;
        *) return 1 ;;
    esac
}

get_session_window() {
    local selection="${1-}"

    if [[ -n $selection ]]; then
        echo "$selection"
    else
        # Get the list of tmux sessions and windows
        session_window_list=$(tmux list-sessions -F "#S" | while read -r session; do
            tmux list-windows -t "$session" -F "#I #W" | awk -v session="$session" '{ print session, $0 }'
        done)

        # Sort the session and window list
        sorted_list=$(echo -e "$session_window_list" | sort)

        # Prompt the user to select a session and window
        selected_session_window=$(echo -e "$sorted_list" | fzf --prompt "Select a session and window to run the command... ")

        # Extract session and window from the selection
        echo "$selected_session_window" | awk '{print $1, $2}' | tr " " ":"
    fi
}

get_pane_number() {
    local pane="${1-}"

    if [[ -n $pane ]]; then
        echo "$pane"
    else
        # Prompt the user to enter a pane number
        read -rp "Please enter a pane number: " pane_number

        # Validate if the input is an integer
        while ! [[ $pane_number =~ ^[0-9]+$ ]]; do
            echo "Invalid pane number. Please enter a valid pane number."
            read -rp "Please enter a pane number: " pane_number
        done

        echo "$pane_number"
    fi
}

get_command() {
    local cmd="${1-}"

    if [[ -n $cmd ]]; then
        echo "$cmd"
    else
        # Prompt the user for the command
        read -rp "Type the command you want to run: " command
        echo "$command"
    fi
}

# Initialize variables with default values
session_window=""
pane_number=""
command=""

# Parse named arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -s | --session-window)
            shift
            session_window=$(get_session_window "$1")
            ;;
        -p | --pane)
            shift
            pane_number=$(get_pane_number "$1")
            ;;
        -c | --command)
            shift
            command=$(get_command "$1")
            ;;
        -h | --help)
            help
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            help
            exit 1
            ;;
    esac
    shift
done

# If session_window is not provided, get it
if [[ -z $session_window ]]; then
    session_window=$(get_session_window)
fi

# If pane_number is not provided, get it
if [[ -z $pane_number ]]; then
    pane_number=$(get_pane_number)
fi

# If command is not provided, get it
if [[ -z $command ]]; then
    command=$(get_command)
fi

# Validate the user input
read -rp "Are you ready to run '$command' on '$session_window.$pane_number'? (Y/N) " user_input

while ! validate_input "$user_input"; do
    read -rp "Invalid input. Please enter Y or N: " user_input
done

if [[ $user_input =~ [Yy] ]]; then
    tmux send-keys -t "$session_window.$pane_number" "$command" Enter
else
    echo "Exiting..."
    exit 0
fi

# TODO: Add the following line to tmux.conf as <Enter>
# bind-key -T prefix <Enter> send-keys Enter

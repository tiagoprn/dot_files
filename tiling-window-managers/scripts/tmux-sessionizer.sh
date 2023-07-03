#!/usr/bin/env bash

# Based on original code from https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/scripts/tmux-sessionizer , all credits belong to ThePrimeagen
# Video instructions on its use here: https://youtu.be/GXxvxSlzJdI

usage() {
    echo "Usage: $0 -p <session_path> [-n <session_name>]"
    exit 1
}

while getopts ":p:n:" opt; do
    case $opt in
        p)
            SESSION_PATH=$OPTARG
            ;;
        n)
            SESSION_NAME=$OPTARG
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            usage
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            usage
            ;;
    esac
done

if [[ -z $SESSION_PATH ]]; then
    echo "Session path (-p) is required."
    usage
fi

if [[ -z $SESSION_NAME ]]; then
    SESSION_NAME=$(basename "$SESSION_PATH" | tr . _)
fi

TMUX_RUNNING=$(pgrep tmux)

if [[ -z $TMUX_RUNNING ]]; then
    tmux new-session -s "$SESSION_NAME" -c "$SESSION_PATH"
    exit 0
fi

if ! tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    tmux new-session -ds "$SESSION_NAME" -c "$SESSION_PATH"
fi

tmux switch-client -t "$SESSION_NAME"

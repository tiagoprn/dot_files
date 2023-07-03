#!/usr/bin/env bash

# Based on original code from https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/scripts/tmux-sessionizer , all credits belong to ThePrimeagen
# Video instructions on its use here: https://youtu.be/GXxvxSlzJdI

usage() {
    echo "Usage: $0 [-p <custom_tmux_session_path>] [-n <custom_tmux_session_name>]"
    exit 1
}

CUSTOM_TMUX_SESSION_PATH=""
CUSTOM_TMUX_SESSION_NAME=""

while getopts ":p:n:" opt; do
    case $opt in
        p)
            CUSTOM_TMUX_SESSION_PATH=$OPTARG
            ;;
        n)
            CUSTOM_TMUX_SESSION_NAME=$OPTARG
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

if [[ -z $CUSTOM_TMUX_SESSION_PATH ]] || [[ -z ${CUSTOM_TMUX_SESSION_PATH//[[:space:]]/} ]]; then
    if [[ -z $CUSTOM_TMUX_SESSION_NAME ]] || [[ -z ${CUSTOM_TMUX_SESSION_NAME//[[:space:]]/} ]]; then
        CUSTOM_TMUX_SESSION_PATH=$(fzf <"$HOME"/.config/git-projects-bookmarks.list | awk '{print $1}')
    else
        CUSTOM_TMUX_SESSION_PATH=""
    fi
fi

if [[ -z $CUSTOM_TMUX_SESSION_NAME ]] || [[ -z ${CUSTOM_TMUX_SESSION_NAME//[[:space:]]/} ]]; then
    CUSTOM_TMUX_SESSION_NAME=$(basename "$CUSTOM_TMUX_SESSION_PATH" | tr . _)
fi

if [[ -z $CUSTOM_TMUX_SESSION_PATH ]]; then
    echo "No custom tmux session path selected."
    exit 0
fi

TMUX_RUNNING=$(pgrep tmux)

if [[ -z $TMUX_RUNNING ]]; then
    tmux new-session -d -s "$CUSTOM_TMUX_SESSION_NAME" -c "$CUSTOM_TMUX_SESSION_PATH"
else
    CURRENT_TMUX_SESSION=$(tmux display-message -p '#S')
    if [[ $CURRENT_TMUX_SESSION != "$CUSTOM_TMUX_SESSION_NAME" ]]; then
        tmux new-session -d -s "$CUSTOM_TMUX_SESSION_NAME" -c "$CUSTOM_TMUX_SESSION_PATH" 2>/dev/null || true
    fi
fi

tmux switch-client -t "$CUSTOM_TMUX_SESSION_NAME"
CURRENT_CLIENT=$(tmux display-message -p '#I:#P')

# if we are on tmux; then
if [[ -n $TMUX ]]; then
    tmux switch-client -t "$CURRENT_CLIENT" -c "$CUSTOM_TMUX_SESSION_PATH"
else
    tmux -2 a -t "$CUSTOM_TMUX_SESSION_NAME"
fi

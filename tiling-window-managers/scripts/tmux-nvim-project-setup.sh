#!/bin/bash

# inspired by: https://github.com/elijahmanor/dotfiles/blob/master/bin/bin/tat

: '
Create a tmux session and name it as the current folder name.
Then, create a set of defined windows and layouts.
'
# shopt -s expand_aliases

path_name="$(basename "$PWD" | tr . -)"
session_name=${1-$path_name}

not_in_tmux() {
    [ -z "$TMUX" ]
}

session_exists() {
    tmux has-session -t "=$session_name"
}

create_detached_session() {
    (TMUX='' tmux new-session -Ad -s "$session_name")
}

create_if_needed_and_attach() {
    if not_in_tmux; then
        tmux new-session -Ad -s "$session_name"

        # DEFAULT_FIRST_WINDOW_NAME="$session_name:1"
        DEFAULT_FIRST_WINDOW_NAME="bash"
        # DEFAULT_FIRST_WINDOW_INDEX=1
        DEFAULT_FIRST_WINDOW_INDEX=0

        tmux rename-window -t $DEFAULT_FIRST_WINDOW_NAME "editor"
        tmux send-keys -t "editor" "nvim" C-m
        tmux splitw -v -p 10
        tmux send-keys -t "editor" "# You can run a runserver like or other commands on this pane." C-m
        tmux selectp -t 0

        tmux new-window -t "$session_name:2" -n "git"
        tmux send-keys -t "git" "lazygit" C-m

        tmux new-window -t "$session_name:3" -n "scratchpad"
        tmux send-keys -t "scratch" "# this is a scratchpad inside the project directory, enjoy!" C-m

        echo 'BEFORE ERROR...'
        tmux attach-session -t "$session_name:$DEFAULT_FIRST_WINDOW_INDEX"
    else
        if ! session_exists; then
            create_detached_session
        fi
        tmux switch-client -t "$session_name:$DEFAULT_FIRST_WINDOW_INDEX"
    fi
}

create_if_needed_and_attach

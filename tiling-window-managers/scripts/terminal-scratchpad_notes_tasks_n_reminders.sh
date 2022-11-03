#!/bin/bash

SCRIPT_NAME=$(basename "$0")

HOSTNAME_USER="$(hostname).$(whoami)"

if [ "$HOSTNAME_USER" == 'cosmos.tiago' ]; then
    SESSIONS_SCRIPT=/storage/src/dot_files/tiling-window-managers/scripts/load-notes-and-reminders-tmuxp-sessions.sh
elif [ "$HOSTNAME_USER" == 'cosmos.tds' ]; then
    SESSIONS_SCRIPT=$HOME/contractors/octerra/git/octerra/scripts/load-octerra-tmuxp-sessions.sh
else
    notify-send -u critical "$SCRIPT_NAME" "Cannot determine a sessions script, configure it on '$SCRIPT_NAME'!"
    exit 1
fi

alacritty --title scratchpad_notes_tasks_n_reminders -e /bin/bash -c "$SESSIONS_SCRIPT" --hold &
# urxvt --hold --title scratchpad_notes_tasks_n_reminders -e /bin/bash -c 'tmuxp load /storage/src/devops/tmuxp/notes-and-reminders.yml' &

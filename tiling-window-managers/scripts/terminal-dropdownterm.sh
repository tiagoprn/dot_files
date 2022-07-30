#!/bin/bash

# urxvt --hold --title dropdownterm -e /bin/bash -c 'tmuxp load /storage/src/devops/tmuxp/notes-and-reminders.yml' &
HOSTNAME=$(hostname)

SESSIONS_SCRIPT=/storage/src/dot_files/tiling-window-managers/scripts/load-notes-and-reminders-tmuxp-sessions.sh

if [ "$HOSTNAME" == 'dft-sp-wkn789' ]; then
    alacritty --title dropdownterm -e /bin/bash -c 'tmuxp load /storage/src/dafiti_shellscripts/tmuxp/notes.yml' --hold &
else
    alacritty --title dropdownterm -e /bin/bash -c "$SESSIONS_SCRIPT" --hold &
    # alacritty --title dropdownterm -e /bin/bash -c "htop" --hold &
fi

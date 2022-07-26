#!/bin/bash

# urxvt --hold --title dropdownterm -e /bin/bash -c 'tmuxp load /storage/src/devops/tmuxp/notes-and-reminders.yml' &
HOSTNAME=$(hostname)

if [ "$HOSTNAME" == 'dft-sp-wkn789' ]; then
    alacritty --title dropdownterm -e /bin/bash -c 'tmuxp load /storage/src/dafiti_shellscripts/tmuxp/notes.yml' --hold &
else
    alacritty --title dropdownterm -e /bin/bash -c 'tmuxp load /storage/src/devops/tmuxp/notes-and-reminders.yml' --hold &
fi

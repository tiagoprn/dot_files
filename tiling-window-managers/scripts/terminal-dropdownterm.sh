#!/bin/bash

# urxvt --hold --title dropdownterm -e /bin/bash -c 'tmuxp load /storage/src/devops/tmuxp/notes-and-reminders.yml' &

alacritty --title dropdownterm -e /bin/bash -c 'tmuxp load /storage/src/devops/tmuxp/notes-and-reminders.yml' --hold &


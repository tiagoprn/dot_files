#!/usr/bin/env bash

# kitty --class term-scratchpad --hold /run/current-system/sw/bin/bash -c "tmuxp load $TMUXP_SESSIONS_FILES" &
# kitty --class term-scratchpad --hold /run/current-system/sw/bin/bash -c "echo 'You can run e.g. tmuxp-notes_tasks_n_reminders.sh'"

# alacritty --title term-scratchpad -e /run/current-system/sw/bin/bash -c "$HOME/scripts/tmuxp-notes_tasks_n_reminders.sh" --hold &

# alacritty --title term-scratchpad -e /run/current-system/sw/bin/bash -c "$HOME/scripts/tmuxp-notes_tasks_n_reminders.sh" --hold

# foot --app-id=term-scratchpad --hold

# foot --hold

# alacritty -e /run/current-system/sw/bin/bash -c "tmux" --hold

# alacritty --hold
echo "----------------------------------------------------------------------"
echo "THIS IS A WEZTERM SCRATCHPAD."
echo "Type 'super+shift+s to move it to the special (scratchpad) workspace.'"
echo -e "----------------------------------------------------------------------\n\n"
sleep 5

# BASH_BIN="/run/current-system/sw/bin/bash"
BASH_BIN="/bin/bash"
wezterm start --always-new-process $BASH_BIN -c "$HOME/scripts/tmuxp-notes_tasks_n_reminders.sh"
# alacritty -e $BASH_BIN -c "$HOME/scripts/tmuxp-notes_tasks_n_reminders.sh" --hold

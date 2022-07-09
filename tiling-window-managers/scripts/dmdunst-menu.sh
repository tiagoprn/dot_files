#!/usr/bin/env bash

# -------
# dunstctl count displayed
# dunstctl count history
# dunstctl count waiting
# dunstctl close
# dunstctl close-all
# dunstctl history-pop
# dunstctl set-paused toggle
# -------

# An array of options
declare -A options
options[pause_resume]="dunstctl set-paused toggle"
options[count_displayed]="notify-send '$(dunstctl count displayed) notifications displayed.'"
options[count_history]="notify-send '$(dunstctl count history) notifications in history.'"
options[count_waiting]="notify-send '$(dunstctl count waiting) notifications waiting.'"
options[close]="dunstctl close"
options[close_all]="dunstctl close-all"
options[history_pop]="dunstctl history-pop"

# Picking a command
# shellcheck disable=SC2154
while [ -z "$command" ]; do
    command=$(printf '%s\n' "${!options[@]}" | sort | dmenu -fn 'Jetbrains Mono:size=14' -c -bw 2 -l 20 -p 'Dunst notifications: ') "$@" || exit
    chosen_command="${options["${command}"]}" || exit
done

/bin/bash -c "$chosen_command"

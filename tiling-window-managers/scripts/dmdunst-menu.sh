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
options[close]="dunstctl close"
options[close_all]="dunstctl close-all"
options[show_last]="dunstctl history-pop"
options[show_last_10]="for ((i = 0; i < 10; i++)); do dunstctl history-pop; done"

# Picking a command
# shellcheck disable=SC2154
while [ -z "$command" ]; do
    command=$(printf '%s\n' "${!options[@]}" | sort | dmenu -fn 'Jetbrains Mono:size=14' -c -bw 2 -l 20 -p 'Dunst notifications: ') "$@" || exit
    chosen_command="${options["${command}"]}" || exit
done

/bin/bash -c "$chosen_command"

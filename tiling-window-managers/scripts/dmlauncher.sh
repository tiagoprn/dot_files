#!/usr/bin/env bash

DMMENU_SCRIPTS_PATH=$HOME/apps/scripts/bin

# An array of options
declare -A options
options[run]="dmrun.sh"
options[kill_process]="dmkill.sh"
options[browser_search]="dmsearch.sh"
options[browser_open]="dmqute.sh"
options[copy_hex_color_to_clipboard]="dmcolors.sh"

# Picking a script
# shellcheck disable=SC2154
while [ -z "$script" ]; do
    script=$(printf '%s\n' "${!options[@]}" | sort | dmenu -i -l 20 -p 'Choose script:') "$@" || exit
    chosen_script="${options["${script}"]}" || exit
done

/bin/bash "$DMMENU_SCRIPTS_PATH/$chosen_script"

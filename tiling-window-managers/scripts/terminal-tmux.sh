#!/bin/bash
DISTRO=$(cat /etc/os-release | grep -e '^ID=' | cut -d = -f 2)

if [[ $DISTRO == "raspbian" ]]; then
    st -e bash -c 'TERM=screen-256color start-default-tmux-session.sh*'
else
    alacritty -e bash -c 'TERM=screen-256color /storage/src/dot_files/tiling-window-managers/scripts/start-default-tmux-session.sh*'
fi

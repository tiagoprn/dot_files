#!/bin/bash
DISTRO=$(cat /etc/os-release | grep -e '^ID=' | cut -d = -f 2)

if [[ $DISTRO == "raspbian" ]]; then
    st -e bash -c 'TERM=screen-256color start_random_tmux_session_name.sh'
else
    alacritty
fi

#!/bin/bash
DISTRO=$(cat /etc/os-release | grep -e '^ID=' | cut -d = -f 2)

if [[ $DISTRO == "raspbian" ]]; then
  st -e bash -c 'TERM=screen-256color ~/apps/scripts/bin/start-default-tmux-session.sh*'
else
  alacritty -e bash -c 'TERM=screen-256color ~/apps/scripts/bin/start-default-tmux-session.sh*'
fi

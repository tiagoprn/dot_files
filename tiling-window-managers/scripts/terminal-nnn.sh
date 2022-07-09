#!/bin/bash
DISTRO=$(cat /etc/os-release | grep -e '^ID=' | cut -d = -f 2)

if [[ $DISTRO == "raspbian" ]]; then
  st -n nnn -t nnn -e nnn
else
  alacritty --class nnn --title nnn -e bash -c 'nnn -c' --hold
fi

#!/usr/bin/env bash

swaync-client -R && swaync-client -rs && notify-send 'sway-notification-center reloaded!'

hyprctl reload && notify-send 'hyprland reloaded from config!'

# Load environment variables from bashrc for waybar scripts
# shellcheck disable=SC1090
source "$HOME/.bashrc"

pkill waybar
waybar &
notify-send 'waybar reloaded!'

pypr reload && notify-send 'pypr reloaded!'

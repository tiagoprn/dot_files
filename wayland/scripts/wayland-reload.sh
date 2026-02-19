#!/usr/bin/env bash

swaync-client -R && swaync-client -rs && notify-send 'sway-notification-center reloaded!'

hyprctl reload && notify-send 'hyprland reloaded from config!'

pkill waybar
waybar &
notify-send 'waybar reloaded!'

pypr reload && notify-send 'pypr reloaded!'

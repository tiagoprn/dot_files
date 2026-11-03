#!/usr/bin/env bash

swaync-client -R && swaync-client -rs && notify-send 'sway-notification-center reloaded!'

hyprctl reload && notify-send 'hyprland reloaded from config!'

notify-send 'reloading quickshell bar...'
pkill -x quickshell || true
sleep 1
pgrep -x quickshell >/dev/null || quickshell &
notify-send 'quickshell bar reloaded!'

pypr reload && notify-send 'pypr reloaded!'

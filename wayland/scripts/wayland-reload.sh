#!/usr/bin/env bash

swaync-client -R && swaync-client -rs && notify-send 'sway-notification-center reloaded!'

hyprctl reload && notify-send 'hyprland reloaded from config!'

notify-send 'reloading quickshell bar...'
qs ipc call island reload 2>/dev/null || { pkill -x quickshell; pgrep -x quickshell >/dev/null || quickshell & }
notify-send 'quickshell bar reloaded!'

pypr reload && notify-send 'pypr reloaded!'

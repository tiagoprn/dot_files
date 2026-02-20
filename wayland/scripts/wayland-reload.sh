#!/usr/bin/env bash

swaync-client -R && swaync-client -rs && notify-send 'sway-notification-center reloaded!'

hyprctl reload && notify-send 'hyprland reloaded from config!'

notify-send 'killing waybar...'
for i in {1..5}; do
    sudo pkill waybar
done

notify-send 'reloading waybar...'
waybar &
notify-send 'waybar reloaded!'

pypr reload && notify-send 'pypr reloaded!'

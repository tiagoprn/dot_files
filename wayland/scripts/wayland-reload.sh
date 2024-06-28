#!/usr/bin/env bash

hyprctl reload && notify-send 'hyprland reloaded from config!'

pkill waybar
waybar &
notify-send 'waybar reloaded!'

pypr reload && notify-send 'pypr reloaded!'

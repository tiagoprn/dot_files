#!/usr/bin/env bash

hyprctl reload && notify-send 'hyprland reloaded from config!'

pkill waybar
waybar &

notify-send 'waybar reloaded!'

pkill pypr
pypr --debug /tmp/pypr.log &

notify-send 'pypr reloaded!'

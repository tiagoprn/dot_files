#!/bin/bash

# sleep 10 #time (in s) for the DE to start; use ~20 for Gnome or KDE, less for Xfce/LXDE etc
# conky -c ~/.Conky/rings & # the main conky with rings
sleep 8 #time for the main conky to start; needed so that the smaller ones draw above not below (probably can be lower, but we still have to wait 5s for the rings to avoid segfaults)
conky -c ~/.Conky/cpu &
sleep 1
conky -c ~/.Conky/mem &
if [[ ! -e /storage/temp/notes.txt ]]; then
    echo 'Put some notes on /storage/temp/notes.txt to show here.' > /storage/temp/notes.txt
fi
conky -c ~/.Conky/notes &

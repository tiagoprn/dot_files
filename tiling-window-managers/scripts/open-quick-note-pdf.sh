#!/bin/bash

zathura $(find /tmp/pdf -type f | rofi -dmenu -markup -markup-rows -fullscreen --no-case-sensitive -p "Choose a pdf to open")

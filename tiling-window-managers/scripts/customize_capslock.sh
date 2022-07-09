#!/bin/bash

ROFI_BIN="$(whereis -b rofi | awk '{print $2}')"

if [ -z "$ROFI_BIN" ]; then
  echo missing rofi, please install dependencies
  exit 1
fi

# if operating using dmenu
if [ -z $1 ]; then

  ACTION=$(echo "REACTIVATE
DEACTIVATE
MORPH_TO_ESCAPE
MORPH_TO_SUPER" | rofi -i -dmenu -no-custom -p "Select CAPSLOCK key behavior")

  if [ -z "$ACTION" ]; then
    exit
  fi

# getting argument from command line
else
  ACTION="REACTIVATE"
fi

if [[ "$ACTION" = "REACTIVATE" ]]; then
  setxkbmap -option
  notify-send -t 2000 "CAPS_LOCK reactivated."
fi

if [[ "$ACTION" = "DEACTIVATE" ]]; then
  setxkbmap -option caps:none
  notify-send -t 2000 "CAPS_LOCK deactivated."
fi

if [[ "$ACTION" = "MORPH_TO_ESCAPE" ]]; then
  setxkbmap -option caps:escape
  notify-send -t 2000 "CAPS_LOCK morphed into ESCAPE."
fi

if [[ "$ACTION" = "MORPH_TO_SUPER" ]]; then
  setxkbmap -option caps:super
  notify-send -t 2000 "CAPS_LOCK morphed into SUPER"
fi

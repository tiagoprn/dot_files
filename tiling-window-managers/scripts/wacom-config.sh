#!/usr/bin/env bash

set -eou pipefail

# map to monitor

# DISPLAY_RESOLUTION=$(xrandr | grep conn | fzf | awk '{print $1}'))
DISPLAY_DEVICE=$(xrandr | grep ' connected' | fzf)
DISPLAY_RESOLUTION=$(echo "$DISPLAY_DEVICE" | grep -E -o '[0-9]{4}x[0-9]{3,4}')
DISPLAY_SUFFIX=$(echo "$DISPLAY_DEVICE" | grep -E -o '\+[0-9]+\+[0-9]+')
DISPLAY_WIDTH=$(echo "$DISPLAY_RESOLUTION" | grep -E -o '^[0-9]{4}')

WACOM_DRAWING_AREA_HEIGHT_IN_INCHES=3.7
WACOM_DRAWING_AREA_WIDTH_IN_INCHES=6.0

WACOM_PROPORTIONAL_HEIGHT=$(awk "BEGIN {wacom_height_inch=$WACOM_DRAWING_AREA_HEIGHT_IN_INCHES; wacom_width_inch=$WACOM_DRAWING_AREA_WIDTH_IN_INCHES; z=(wacom_height_inch/wacom_width_inch)*$DISPLAY_WIDTH; print z}")

WACOM_HEIGHT=$(echo "$WACOM_PROPORTIONAL_HEIGHT" | grep -E -o '^[0-9]{3,4}')

echo "wacom height: $WACOM_HEIGHT"

WACOM_RESOLUTION=$DISPLAY_WIDTH"x"$WACOM_HEIGHT$DISPLAY_SUFFIX

echo "Setting wacom output to map output resolution: $WACOM_RESOLUTION..."
xsetwacom set "Wacom Intuos S Pen stylus" MapToOutput "$WACOM_RESOLUTION"
xsetwacom set "Wacom Intuos S Pen eraser" MapToOutput "$WACOM_RESOLUTION"
xsetwacom set "Wacom Intuos S Pen cursor" MapToOutput "$WACOM_RESOLUTION"
echo 'DONE.'

#!/bin/bash

# notify-send 'Opening bigger urxvt terminal...'
# urxvt -name presentation -cd /storage/docs/notes

SCREEN_RESOLUTION=$(xdpyinfo | grep 'dimensions' | cut -d ':' -f 2 | awk '{ print $1 }')
echo "Current screen resolution is: $SCREEN_RESOLUTION"

SCREEN_WIDTH=$(echo $SCREEN_RESOLUTION | cut -d 'x' -f 1)
echo "Current screen width is: $SCREEN_WIDTH"

SCREEN_HEIGHT=$(echo $SCREEN_RESOLUTION | cut -d 'x' -f 2)
echo "Current screen height is: $SCREEN_HEIGHT"

REFERENCE_SCREEN_WIDTH=2560
REFERENCE_SCREEN_HEIGHT=1080

FULL_GEOMETRY_WIDTH=310  # for screen width=2560px
FULL_GEOMETRY_HEIGHT=54  # for screen height=1080px

BASE_GEOMETRY_WIDTH=100
BASE_GEOMETRY_HEIGHT=53

GEOMETRY_WIDTH=$(printf "%.0f" $(echo "scale=2;($SCREEN_WIDTH*$BASE_GEOMETRY_WIDTH)/$REFERENCE_SCREEN_WIDTH" | bc | sed 's/[.]/,/'))
GEOMETRY_HEIGHT=$(printf "%.0f" $(echo "scale=2;($SCREEN_HEIGHT*$BASE_GEOMETRY_HEIGHT)/$REFERENCE_SCREEN_HEIGHT" | bc | sed 's/[.]/,/'))

# printf "%.0f" $(echo "scale=2;5/3" | bc | sed 's/[.]/,/')

echo "Calculated geometry WIDTH is: $GEOMETRY_WIDTH"
echo "Calculated geometry HEIGHT is: $GEOMETRY_HEIGHT"

WINDOW_NAME=dropdownterm
urxvt -name $WINDOW_NAME -title $WINDOW_NAME -geometry ${GEOMETRY_WIDTH}x${GEOMETRY_HEIGHT}


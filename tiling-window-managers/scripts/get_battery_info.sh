#!/bin/bash
set -e
BAT=$(upower -e | grep BAT)
PERCENTAGE=$(upower -i $BAT | grep -i 'percentage'| cut -d ':' -f 2 | sed -e 's/^[[:space:]]*//' )
STATE=$(upower -i $BAT | grep -i 'state'| cut -d ':' -f 2 | sed -e 's/^[[:space:]]*//' )
REMAINING=''
if [ "$STATE" = "discharging" ]; then
    REMAINING="(0% in $(upower -i $BAT | grep -i 'time to empty'| cut -d ':' -f 2 | sed -e 's/^[[:space:]]*//'))"
fi
echo "$PERCENTAGE, $STATE $REMAINING"

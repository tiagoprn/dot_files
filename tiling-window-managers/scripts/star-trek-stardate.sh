#!/bin/bash

STAR_DATE=$(curl -s https://www.stoacademy.com/tools/stardate.php | grep 'Stardate' | grep 'div' | cut -d '>' -f 3 | cut -d '<' -f 1 | sed 's/S/s/g' | sed 's/ /: /g')
EARTH_DATE=$(date '+%Y-%m-%d %H:%M:%S')

echo "$STAR_DATE (earth: $EARTH_DATE)"


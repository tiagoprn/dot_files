#!/bin/bash

TIMESTAMP="$(date "+%Y%m%d-%H%M-%S")"

array[0]="mercury-$TIMESTAMP"
array[1]="venus-$TIMESTAMP"
array[2]="moon-$TIMESTAMP"
array[3]="mars-$TIMESTAMP"
array[4]="ceres-$TIMESTAMP"
array[5]="jupiter-$TIMESTAMP"
array[6]="saturn-$TIMESTAMP"
array[7]="uranus-$TIMESTAMP"
array[8]="neptune-$TIMESTAMP"
array[9]="pluto-$TIMESTAMP"
array[10]="io-$TIMESTAMP"
array[11]="europa-$TIMESTAMP"
array[12]="titan-$TIMESTAMP"

size=${#array[@]}
index=$(($RANDOM % $size))

NAME=${array[$index]}

notify-send --urgency low "Starting tmux session $NAME on kitty terminal..."

tmux -2 new -s $NAME && tmux -2 a -t $NAME


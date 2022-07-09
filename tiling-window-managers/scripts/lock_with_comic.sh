#!/usr/bin/env bash


OS_NAME=$(cat /etc/os-release  | grep '^ID=' | cut -d '=' -f 2)
if [ "$OS_NAME" == "raspbian" ]; then
    dm-tool lock
    exit 0
fi

bash /storage/src/devops/bin/download_random_commitstrip.sh;

LOCK_DELAY=2

COMIC_FOLDER=$HOME/tmp/commitstrip;

PARAM=(--insidecolor=00000000 --ringcolor=0000003e \
    --linecolor=00000000 --keyhlcolor=ffffff80 --ringvercolor=ffffff00 \
    --separatorcolor=22222260 --insidevercolor=ffffff1c \
    --ringwrongcolor=ffffff55 --insidewrongcolor=ffffff1c);

# COMIC_PATH=$(find $COMIC_FOLDER -printf '%T+ %p\n' | sort -r | head -n 1 | awk '{ print $2}' | cut -d '/' -f 2);
COMIC_PATH=$(find $COMIC_FOLDER -printf '%T+ %p\n' | sort -r | head -n 1 | awk '{ print $2}' );

echo "COMIC_FOLDER: $COMIC_FOLDER"
echo "COMIC_PATH: $COMIC_PATH"

notify-send --urgency critical "Screen will be locked in $LOCK_DELAY seconds with comic $COMIC_PATH ...";

DATE_HORIZONTAL_POS=1150
DATE_VERTICAL_POS=700
TIME_HORIZONTAL_POS=1000
TIME_VERTICAL_POS=650

sleep $LOCK_DELAY && i3lock -e -f -n -k --datesize=30 --timesize=150 -k "${PARAM[@]}" -i $COMIC_PATH --datestr="%A, %d %b %Y" --datepos="$DATE_HORIZONTAL_POS:$DATE_VERTICAL_POS" --timepos="$TIME_HORIZONTAL_POS:$TIME_VERTICAL_POS";

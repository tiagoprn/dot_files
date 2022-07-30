#!/bin/bash

# based on: https://www.youtube.com/watch?v=zB_3FIGRWRU&feature=youtu.be

FLEETING_NOTES_DIR=/storage/docs/fleeting-notes
TIMESTAMP=$(date '+%Y-%m-%d-%H-%M-%S')
FILENAME=$FLEETING_NOTES_DIR/$TIMESTAMP.md

mkdir -p $FLEETING_NOTES_DIR

SELECTED_OPTION=$(echo -e '1 - Open recently created/updated file\n2 - Create new file' | fzf | awk '{print $1}')

if [ "$SELECTED_OPTION" == '1' ]; then
    FILE_TO_OPEN=$(find . -type f -ctime -7 -name '*.md' | sort -r | fzf --prompt='Choose a file created/changed on the last 7 days > ' --preview 'bat --style numbers,changes --color=always {} | head -n 30')
    nvim "$FILE_TO_OPEN"
else
    cd $FLEETING_NOTES_DIR \
        && nvim -c "norm Iqheader " \
            -c 'norm gg$' \
            -c "startinsert" \
            "$FILENAME"
fi

exit 0

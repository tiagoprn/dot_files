#!/bin/sh

# based on: https://www.youtube.com/watch?v=zB_3FIGRWRU&feature=youtu.be

FILENAME=$1

if [ -z $FILENAME]; then
	echo "No file informed, opening fzf to do so..."
	FILENAME=$(find /storage/docs/notes/quick -type f | fzf)
fi

if [ -z $FILENAME]; then
	echo "You must select a file, as a parameter or through fzf."
	exit 1
fi

TARGET="/tmp/epub"
OUTPUT_FILE="$(basename "$FILENAME" .md).epub"

echo "Creating target (output) directory: $TARGET..."
mkdir -p "$TARGET"

echo "Generating EPUB..."

# on pandoc 2.0, change "--latex-engine" to "--pdf-engine"
pandoc \
    --latex-engine=xelatex \
    -V 'mainfont:DejaVuSerif' \
    -V 'mainfontoptions:Extension=.ttf, UprightFont=*, BoldFont=*-Bold, ItalicFont=*-Italic, BoldItalicFont=*-BoldItalic' \
    -V 'sansfont:DejaVuSans.ttf' \
    -V 'monofont:DejaVuSansMono.ttf' \
    -V "geometry:margin=1in" \
    -o "$TARGET/$OUTPUT_FILE" "$FILENAME" &

echo "The EPUB will be available at $TARGET/$OUTPUT_FILE."



#!/bin/bash

# based on: https://www.youtube.com/watch?v=zB_3FIGRWRU&feature=youtu.be

QUICKNOTES_DIR=/storage/docs/notes/quick
TIMESTAMP="$(date '+%Y-%m-%d')"
FILENAME=$QUICKNOTES_DIR/notes-$TIMESTAMP.md

mkdir -p $QUICKNOTES_DIR

if [ ! -f $FILENAME ] ; then
	echo "# Notes for $TIMESTAMP" > $FILENAME
fi

vim -c "norm Go" \
	-c "norm Go## $(date +%H:%M)" \
	-c "norm G2o" \
	-c "norm zz" \
	-c "startinsert" \
	$FILENAME

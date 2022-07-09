#!/bin/bash

# Creates a zettelkasten file inside the current folder

TIMESTAMP="$(date "+%Y-%m-%d-%H%M%S-%3N")"
FILENAME=$TIMESTAMP.md
vim "$FILENAME" +'normal!ggIfc'


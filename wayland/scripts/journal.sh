#!/usr/bin/env bash

# +"normal Go": Moves to the end of the file and inserts a blank line.
# +"normal o---": Adds a line with ---.
# +"normal o# $(date +"%Y %B %d %A %H:%M:%S")": Adds the date as # YYYY Month DD Day HH:MM:SS.
# +"normal o": Adds another blank line.
# +"normal o": Adds a second blank line before switching to insert mode.
# +"startinsert": Enters insert mode so you can start typing.

nvim +"normal Go" \
    +"normal o---" \
    +"normal o# $(date +"%Y %B %d %A %H:%M:%S")" \
    +"normal o" \
    +"normal o" \
    +"startinsert" \
    "$HOME/journal.$(hostname).md"

#!/bin/bash

if [ -x "$(command -v wal)" ]; then
    wal -R -n
else
    echo "wal command is not installed. Nothing to do."
fi


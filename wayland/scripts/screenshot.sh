#!/usr/bin/env bash

SCREENSHOTS_HOME="$HOME/screenshots"
TIMESTAMP="$(date "+%Y%m%d-%H%M%S")"

mkdir -p "$SCREENSHOTS_HOME" || true

grim -g "$(slurp)" - | swappy -f - -o "$SCREENSHOTS_HOME/$TIMESTAMP.png"

#!/usr/bin/env bash

rm style.css || true

NEW_THEME="$(find . -type f | fzf)"

ln -s "$NEW_THEME" style.css

echo -e "Successfully changed theme to: $NEW_THEME"

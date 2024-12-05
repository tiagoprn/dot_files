#!/usr/bin/env bash

cat "$HOME/.config/browser.bookmarks" | sort | wofi --dmenu --prompt="Select Bookmark and Copy URL to clipboard:" | awk '{print $2}' | wl-copy && notify-send 'Bookmark successfully copied to clipboard.'

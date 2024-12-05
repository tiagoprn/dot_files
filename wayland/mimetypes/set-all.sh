#!/usr/bin/env bash

xdg-mime default sxiv.desktop image/jpeg
xdg-mime default sxiv.desktop image/png
xdg-mime default sxiv.desktop image/gif

cp -farv *.desktop "$HOME/.local/share/applications"
update-desktop-database ~/.local/share/applications

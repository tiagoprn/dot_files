#!/bin/bash
ORIGIN=".bashrc .bash_aliases .bash_functions .dmrc .profile .tmux.conf welcome.txt picom.conf i3 .Xresources"
for unit in $ORIGIN; do
	# ls -lha "$unit";
	cp -farv "$unit" "$HOME";
done

cp -farv dunst "$HOME"/.config/dunst
cp -farv hold.sh "$HOME"/local/bin

#!/bin/bash
REPO_PATH=/storage/src/dot_files/raspberry/pii
ORIGIN=".bashrc .bash_aliases .bash_functions .dmrc .profile .tmux.conf welcome.txt picom.conf i3 .Xresources .xinitrc"
for unit in $ORIGIN; do
	# ls -lha "$unit";
	cp -farv "$unit" "$REPO_PATH";
done


cp -farv "$HOME"/.config/dunst "$REPO_PATH"
cp -farv "$HOME"/local/bin/hold.sh "$REPO_PATH"

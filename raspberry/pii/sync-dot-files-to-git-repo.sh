#!/bin/bash
REPO_PATH=/storage/src/dot_files/raspberry/pii
ORIGIN=".bashrc .bash_aliases .bash_functions .dmrc .profile .tmux.conf welcome.txt picom.conf i3 .Xresources .xinitrc dunstrc"
for unit in $ORIGIN; do
	# ls -lha "$unit";
	cp -farv "$unit" "$REPO_PATH";
done

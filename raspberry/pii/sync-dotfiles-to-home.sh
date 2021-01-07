#!/bin/bash

# TODO: change this script to use rsync, deleting on the destination when a file does not exists.

# Files that must be on $HOME

ORIGIN=".bashrc .bash_aliases .bash_functions .bash_profile .xsession .dmrc .tmux.conf welcome.txt picom.conf i3 .Xresources"
for unit in $ORIGIN; do
	# ls -lha "$unit";
	cp -farv "$unit" "$HOME";
done

# Files that must be somewhere else

## dunst
DUNST_CONFIG_HOME="$HOME"/.config/dunst
mkdir -p $DUNST_CONFIG_HOME
cp -farv dunstrc $DUNST_CONFIG_HOME

## Files that must be on $HOME/local/bin
HOME_BIN="$HOME"/local/bin
cp -farv hold.sh $HOME_BIN

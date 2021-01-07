#!/bin/bash

# TODO: change this script to use rsync, deleting on the destination when a file does not exists.

HOME_SCRIPTS=$HOME/apps/scripts
BIN_SCRIPTS=$HOME_SCRIPTS/bin
ROFI_SCRIPTS=$HOME_SCRIPTS/rofi
STATUSBAR_SCRIPTS=$BIN_SCRIPTS/statusbar

mkdir -p $HOME_SCRIPTS
mkdir -p $BIN_SCRIPTS
mkdir -p $ROFI_SCRIPTS
mkdir -p $STATUSBAR_SCRIPTS

cp -farv /storage/src/devops/bin/* $BIN_SCRIPTS
cp -farv /storage/src/devops/rofi/* $ROFI_SCRIPTS
cp -farv /storage/src/devops/shellscripts/statusbar/* $STATUSBAR_SCRIPTS

cp -farv /storage/src/dwm/startdwm /usr/bin

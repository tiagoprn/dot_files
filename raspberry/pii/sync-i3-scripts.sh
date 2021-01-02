#!/bin/bash

HOME_SCRIPTS=$HOME/apps/scripts
BIN_SCRIPTS=$HOME_SCRIPTS/bin
ROFI_SCRIPTS=$HOME_SCRIPTS/rofi

mkdir -p $HOME_SCRIPTS
mkdir -p $BIN_SCRIPTS
mkdir -p $ROFI_SCRIPTS

cp -farv /storage/src/devops/bin/* $BIN_SCRIPTS
cp -farv /storage/src/devops/rofi/* $ROFI_SCRIPTS



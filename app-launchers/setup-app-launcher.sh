#!/bin/bash
APPLICATIONS_FOLDER=$HOME/.local/share/applications
cp -farv icons /opt/telegram/Telegram
mkdir -p $APPLICATIONS_FOLDER
cp -farv telegram.desktop $APPLICATIONS_FOLDER


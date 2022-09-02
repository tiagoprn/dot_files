#!/bin/bash

echo 'Let us update the current nvim plugins before starting...'
read -n 1 -s -r -p "Press any key to continue..."
nvim +":PackerSync"
echo 'Finished updating plugins, moving on...'

# Cleanup existing install and compile a new one
PREVIOUS_VERSION=$(sudo -- bash -c 'cd /opt/src/neovim && git log -n 1 --pretty=format:"%cD by %an (%h)"')

BACKUPS_ROOT=/opt/src/neovim/tmp/OLD-VERSIONS-ARCHIVE
SUFFIX="$(date +%Y%m%d-%H%M%S-%N)"
BACKUPS_DIR=$BACKUPS_ROOT/$SUFFIX
NVIM_BINARY_PATH=/usr/local/bin/nvim

sudo mkdir -p $BACKUPS_DIR
sudo cp -farv $NVIM_BINARY_PATH $BACKUPS_DIR
notify-send "$(basename "$0")" "The old nvim binary was copied to $BACKUPS_DIR in case you need to manually revert it to $NVIM_BINARY_PATH."

notify-send "$(basename "$0")" "Compiling nvim (this will take a while)..."
COMMANDS="cd /opt/src/neovim && git fetch && git pull && make clean && make CMAKE_BUILD_TYPE=Release && make install"
sudo -- bash -c "$COMMANDS"

NEW_VERSION=$(sudo -- bash -c 'cd /opt/src/neovim && git log -n 1 --pretty=format:"%cD by %an (%h)"')

message="\nFinished compiling nvim.\n\nPrevious version:\n\t$PREVIOUS_VERSION\nNew version:\n\t$NEW_VERSION\n\nHave fun! \o/\n(and run :PackerSync to update the plugins also ;)"
echo "-----------------"
echo -e "$message"
echo "-----------------"
notify-send "$(basename "$0")" "$message"

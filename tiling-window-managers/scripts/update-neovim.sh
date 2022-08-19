#!/bin/bash

# Cleanup existing install and compile a new one

PREVIOUS_VERSION=$(sudo -- bash -c 'cd /opt/src/neovim && git log -n 1 --pretty=format:"%cD by %an (%h)"')

notify-send "$(basename "$0")" "Compiling nvim (this will take a while)..."
COMMANDS="cd /opt/src/neovim && git fetch && git pull && make clean && make CMAKE_BUILD_TYPE=Release && make install"
sudo -- bash -c "$COMMANDS"

NEW_VERSION=$(sudo -- bash -c 'cd /opt/src/neovim && git log -n 1 --pretty=format:"%cD by %an (%h)"')

message="\nFinished compiling nvim.\n\nPrevious version:\n\t$PREVIOUS_VERSION\nNew version:\n\t$NEW_VERSION\n\nHave fun! \o/\n(and run :PackerSync to update the plugins also ;)"
echo "-----------------"
echo -e "$message"
echo "-----------------"
notify-send "$(basename "$0")" "$message"

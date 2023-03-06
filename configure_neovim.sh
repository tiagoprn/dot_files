#!/bin/bash
set -e

TIMESTAMP=$(date '+%Y-%m-%d-%H-%M-%S')

removeDirIfPresent() {
    if [[ -d $1 ]]; then
        rm -rf "$1"
        echo "Removed dir '$1'"
    fi
}

removeSymbolicLinkIfPresent() {
    if [[ -f $1 ]]; then
        rm "$1"
        echo "Removed symlink '$1'"
    fi
}

renameDirIfPresent() {
    if [[ -d $1 ]]; then
        mv "$1" "$1.$TIMESTAMP"
        echo "Renamed '$1' to '$1.$TIMESTAMP'."
    fi
}

removeConfiguration() {
    removeDirIfPresent ~/.local/share/nvim
    removeDirIfPresent ~/.local/state/nvim
    removeDirIfPresent ~/.cache/nvim
    removeDirIfPresent ~/.config/nvim/undodir
}

backupConfiguration() {
    renameDirIfPresent ~/.local/share/nvim
    renameDirIfPresent ~/.local/state/nvim
    renameDirIfPresent ~/.cache/nvim
    renameDirIfPresent ~/.config/nvim/undodir
}

# echo 'Deleting old setup (if it exists)...'
# removeConfiguration

echo 'Backing up old setup (if it exists)...'
backupConfiguration

echo 'Recreating setup using symlinks from my dot_files repo...'
removeSymbolicLinkIfPresent rm ~/.config/nvim
removeSymbolicLinkIfPresent ~/.config/efm-langserver
ln -s /storage/src/dot_files/nvim ~/.config/nvim
ln -s /storage/src/dot_files/efm-langserver ~/.config/efm-langserver

echo 'Cloning packer as the package manager...'
git clone https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# nvim +PackerSync +qa

echo 'DONE.'

#!/bin/bash
set -e

echo 'Deleting old setup (if it exists)...'

rm -fr ~/.local/share/nvim || true && mkdir -p ~/.local/share
rm -fr ~/.cache/nvim || true && mkdir -p ~/.cache

rm ~/.config/nvim || true && mkdir -p ~/.config

ln -s /storage/src/dot_files/nvim ~/.config/nvim
rm -fr ~/.config/nvim/undodir || true && mkdir -p ~/.config/nvim/undodir

git clone https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
# nvim +PackerSync +qa

echo 'DONE. Configuration was syslinked to my dot_files repo.'

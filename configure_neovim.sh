#!/bin/bash
set -e

echo 'Deleting old setup (if it exists)...'

rm -fr ~/.local/share/nvim || true && mkdir -p ~/.local/share
rm -fr ~/.config/nvim || true && mkdir -p ~/.config
rm -fr ~/.cache/nvim || true && mkdir -p ~/.cache
rm -fr ~/.config/nvim/undodir || true && mkdir -p ~/.config/nvim/undodir

ln -s /storage/src/dot_files/nvim ~/.config/nvim

git clone https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
# nvim +PackerSync +qa

echo 'DONE. Configuration was syslinked to my dot_files repo.'

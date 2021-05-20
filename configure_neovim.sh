#!/bin/bash
set -e

echo 'Deleting old configuration (if it exists)...'

rm -fr ~/.config/nvim || true && mkdir -p ~/.config
ln -s /storage/src/dot_files/nvim ~/.config/nvim
# git clone https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
# nvim +PackerSync +qa

echo 'DONE. Configuration was syslinked to my dot_files repo.'

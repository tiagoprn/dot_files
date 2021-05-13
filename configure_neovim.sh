#!/bin/bash
set -e

rm -fr ~/.config/nvim || true && mkdir ~/.config/nvim
ln -s /storage/src/dot_files/nvim/init.vim ~/.config/nvim/init.vim

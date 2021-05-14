#!/bin/bash
set -e

rm -fr ~/.config/nvim || true && mkdir -p ~/.config
ln -s /storage/src/dot_files/nvim ~/.config/nvim

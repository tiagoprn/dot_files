#!/bin/bash
rm -fr ~/.gitconfig ~/.gitign*
ln -s /storage/src/dot_files/.gitconfig ~/.gitconfig
ln -s /storage/src/dot_files/.gitignore.global ~/.gitignore.global
git config --global core.excludesfile ~/.gitignore.global

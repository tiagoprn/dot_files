#!/bin/bash
TIMESTAMP="$(date "+%Y%m%d.%H%M.%S")"
mv ~/.bash_aliases ~/.bash_aliases.$TIMESTAMP.snapshot || true
mv ~/.bash_functions ~/.bashrc_functions.$TIMESTAMP.snapshot || true
mv ~/.bash_environment ~/.bash_environment.$TIMESTAMP.snapshot || true
mv ~/.bashrc ~/.bashrc.$TIMESTAMP.snapshot || true
mv ~/.inputrc ~/.inputrc.$TIMESTAMP.snapshot || true
mv ~/.local/share/todotxt ~/.local/share/todotxt.$TIMESTAMP.snapshot || true

ln -s /storage/src/dot_files/.bash_aliases ~/.bash_aliases
ln -s /storage/src/dot_files/.bash_functions ~/.bash_functions
ln -s /storage/src/dot_files/.bash_environment ~/.bash_environment
ln -s /storage/src/dot_files/.bashrc ~/.bashrc
ln -s /storage/src/dot_files/.inputrc ~/.inputrc
ln -s /storage/src/dot_files/todotxt ~/.local/share/todotxt



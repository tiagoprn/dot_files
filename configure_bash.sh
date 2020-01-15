#!/bin/bash
TIMESTAMP="$(date "+%Y%m%d.%H%M.%S")"
mv ~/.bash_aliases ~/.bash_aliases.$TIMESTAMP.snapshot
mv ~/.bash_functions ~/.bashrc_functions.$TIMESTAMP.snapshot
mv ~/.bash_environment ~/.bash_environment.$TIMESTAMP.snapshot
mv ~/.bashrc ~/.bashrc.$TIMESTAMP.snapshot
mv ~/.inputrc ~/.inputrc.$TIMESTAMP.snapshot
ln -s /storage/src/dot_files/.bash_aliases ~/.bash_aliases
ln -s /storage/src/dot_files/.bash_functions ~/.bash_functions
ln -s /storage/src/dot_files/.bash_environment ~/.bash_environment
ln -s /storage/src/dot_files/.bashrc ~/.bashrc
ln -s /storage/src/dot_files/.inputrc ~/.inputrc

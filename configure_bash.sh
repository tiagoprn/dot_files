#!/usr/bin/env bash

TIMESTAMP="$(date "+%Y%m%d.%H%M.%S")"
mv ~/.bash_aliases ~/.bash_aliases.$TIMESTAMP.snapshot || true
mv ~/.bash_functions ~/.bashrc_functions.$TIMESTAMP.snapshot || true
mv ~/.profile ~/.profile.$TIMESTAMP.snapshot || true
mv ~/.bashrc ~/.bashrc.$TIMESTAMP.snapshot || true
mv ~/.inputrc ~/.inputrc.$TIMESTAMP.snapshot || true
mv ~/.fonts ~/.fonts.$TIMESTAMP.snapshot || true
mv ~/.fzf ~/.fzf.$TIMESTAMP.snapshot || true
mv ~/.xsession ~/.xsession.$TIMESTAMP.snapshot || true

mv ~/.config/pudb/pudb.cfg ~/.config/pudb/pudb.cfg.$TIMESTAMP.snapshot || true
mv ~/.config/television ~/.config/television.$TIMESTAMP.snapshot || true

ln -s /storage/src/dot_files/.bash_aliases ~/.bash_aliases
ln -s /storage/src/dot_files/.bash_functions ~/.bash_functions
ln -s /storage/src/dot_files/.profile ~/.profile
ln -s /storage/src/dot_files/.bashrc ~/.bashrc
ln -s /storage/src/dot_files/.inputrc ~/.inputrc
ln -s /storage/src/dot_files/.fonts ~/.fonts
ln -s /storage/src/dot_files/.fzf ~/.fzf
ln -s /storage/src/dot_files/.xsession ~/.xsession
ln -s /storage/src/dot_files/.navirc ~/.navirc

mkdir -p ~/.config/pudb || true && ln -s /storage/src/dot_files/pudb/pudb.cfg ~/.config/pudb/pudb.cfg || true
mkdir -p ~/.config/television || true && ln -s /storage/src/dot_files/television ~/.config/television || true

fc-cache -vf ~/.fonts/ && echo 'listing fonts...' && fc-list

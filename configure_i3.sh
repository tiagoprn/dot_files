#!/bin/bash

echo 'Installing monospaced fonts...'
yaourt -S --color ttf-hack-ibx ttf-monofur ttf-fira-code ttf-mononoki mps-youtube mplayer ffmpeg --noconfirm

echo 'Linking main i3 config...' 
rm -fr ~/.i3
ln -s /storage/src/dot_files/.i3 ~/.i3

echo 'Linking gtk config...' 
rm -fr ~/.gtkrc-2.0
ln -s /storage/src/dot_files/.gtkrc-2.0 ~/.gtkrc-2.0
rm -fr ~/.config/gtk-3.0/
ln -s /storage/src/dot_files/gtk-3.0 ~/.config/gtk-3.0

echo 'Linking Xresources...' 
rm -fr ~/.Xresources
ln -s /storage/src/dot_files/.Xresources ~/.Xresources
xrdb .Xresources

echo 'Linking termite configuration...'
rm -fr ~/.config/termite
ln -s /storage/src/dot_files/termite ~/.config/termite

echo 'Linking rofi config...' 
rm -fr ~/.local/share/rofi
ln -s /storage/src/dot_files/rofi ~/.local/share/rofi

echo 'Linking dunst config...'
rm -fr ~/.config/dunst/dunstrc
mkdir -p ~/.config/dunst
ln -s /storage/src/dot_files/dunstrc ~/.config/dunst/dunstrc

echo 'Linking conky, compton and clipster config...'
rm -fr ~/.Conky ~/compton.conf ~/clipster.ini
ln -s /storage/src/dot_files/.Conky ~/.Conky
ln -s /storage/src/dot_files/compton.conf ~/compton.conf
ln -s /storage/src/dot_files/clipster.ini ~/clipster.ini

echo 'Linking ranger configuration...'
rm -fr ~/.config/ranger
ln -s /storage/src/dot_files/ranger ~/.config/ranger

echo 'Linking mps-youtube configuration...'
mkdir -p ~/.config/mps-youtube
ln -s /storage/src/dot_files/mps-youtube/config ~/.config/mps-youtube/config

echo 'Finished.' 

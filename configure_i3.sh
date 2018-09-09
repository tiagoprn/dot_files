#!/bin/bash
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
rm -fr ~/dunstrc
ln -s /storage/src/dot_files/dunstrc ~/dunstrc

echo 'Linking conky, compton and clipster config...'
rm -fr ~/.Conky ~/compton.conf ~/clipster.ini
ln -s /storage/src/dot_files/.Conky ~/.Conky
ln -s /storage/src/dot_files/compton.conf ~/compton.conf
ln -s /storage/src/dot_files/clipster.ini ~/clipster.ini

echo 'Finished.' 

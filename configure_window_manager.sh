#!/bin/bash

echo 'Linking Xresources...'
rm ~/.Xresources
ln -s /storage/src/dot_files/.Xresources ~/.Xresources
xrdb .Xresources

echo 'Linking xsessionrc...'
rm ~/.xsessionrc
ln -s /storage/src/dot_files/.xsessionrc ~/.xsessionrc
echo 'Linking gtk config...'

rm ~/.gtkrc-2.0
ln -s /storage/src/dot_files/.gtkrc-2.0 ~/.gtkrc-2.0
rm ~/.config/gtk-3.0/
ln -s /storage/src/dot_files/gtk-3.0 ~/.config/gtk-3.0

# ---
# terminals

echo 'Linking urxvt extensions...'
rm ~/.urxvt
ln -s /storage/src/dot_files/.urxvt ~/.urxvt
xrdb .Xresources

echo 'Linking kitty configuration...'
rm ~/.config/kitty
ln -s /storage/src/dot_files/kitty ~/.config/kitty

echo 'Linking termite configuration...'
rm ~/.config/termite
ln -s /storage/src/dot_files/termite ~/.config/termite

echo 'Linking alacritty configuration...'
rm ~/.config/alacritty
ln -s /storage/src/dot_files/alacritty ~/.config

echo 'Linking surfraw configuration...'
rm ~/.config/surfraw
ln -s /storage/src/dot_files/surfraw/ ~/.config/surfraw

# ---
# bspwm
rm ~/.config/bspwm
ln -s /storage/src/dot_files/tiling-window-managers/bspwm ~/.config/bspwm

# ---
# utils

echo 'Linking picom...'
rm ~/picom.conf
ln -s /storage/src/dot_files/picom.conf ~/picom.conf

echo 'Linking rofi config...'
rm ~/.config/rofi
ln -s /storage/src/dot_files/rofi ~/.config/rofi

echo 'Linking dunst config...'
rm ~/.config/dunst/dunstrc
mkdir -p ~/.config/dunst
ln -s /storage/src/dot_files/dunstrc ~/.config/dunst/dunstrc

echo 'Linking conky and compton config...'
rm ~/.Conky ~/compton.conf
ln -s /storage/src/dot_files/.Conky ~/.Conky
ln -s /storage/src/dot_files/compton.conf ~/compton.conf

echo 'Linking ranger configuration...'
rm ~/.config/ranger
ln -s /storage/src/dot_files/ranger ~/.config/ranger

echo 'Linking mps-youtube configuration...'
mkdir -p ~/.config/mps-youtube
ln -s /storage/src/dot_files/mps-youtube/config ~/.config/mps-youtube/config

echo 'Linking ansible configuration...'
rm ~/ansible
ln -s /storage/src/dot_files/ansible ~/ansible

echo 'Linking arandr (screenlayout) configuration...'
rm ~/.screenlayout
ln -s /storage/src/dot_files/.screenlayout ~/.screenlayout

echo 'Linking sxiv (image viewer) configuration...'
rm ~/.config/sxiv
ln -s /storage/src/dot_files/sxiv ~/.config/sxiv

echo 'Installing dmenu/rofi networkmanager...'
BIN_DIR="$HOME/.local/bin"
rm "$BIN_DIR/networkmanager_dmenu"
curl https://raw.githubusercontent.com/firecat53/networkmanager-dmenu/main/networkmanager_dmenu -o "$BIN_DIR/networkmanager_dmenu"
chmod 700 "$BIN_DIR/networkmanager_dmenu"
rm -fr "$HOME/.config/networkmanager-dmenu"
ln -s /storage/src/dot_files/networkmanager-dmenu "$HOME/.config/networkmanager-dmenu"

echo 'Linking polybar...'
rm ~/.config/polybar
ln -s /storage/src/dot_files/tiling-window-managers/polybar ~/.config/polybar

echo 'Linking zathura...'
rm -fr ~/.config/zathura/zathurarc
ln -s /storage/src/dot_files/zathurarc ~/.config/zathura/zathurarc

echo 'Linking systray (stalonetrayrc)...'
rm ~/.stalonetrayrc
ln -s /storage/src/dot_files/.stalonetrayrc ~/.stalonetrayrc

echo 'Linking styli.sh...'
rm ~/.config/styli.sh
ln -s /storage/src/dot_files/tiling-window-managers/styli.sh ~/.config/styli.sh

echo 'Linking autorandr...'
rm ~/.config/autorandr
ln -s /storage/src/dot_files/autorandr ~/.config/autorandr

echo 'Finished.'

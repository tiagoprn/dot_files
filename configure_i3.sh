#!/bin/bash

echo 'Linking main i3 config...'
rm -fr ~/.i3
rm -fr ~/.config/i3
ln -s /storage/src/dot_files/i3 ~/.config/i3

echo 'Linking gtk config...'
rm -fr ~/.gtkrc-2.0
ln -s /storage/src/dot_files/.gtkrc-2.0 ~/.gtkrc-2.0
rm -fr ~/.config/gtk-3.0/
ln -s /storage/src/dot_files/gtk-3.0 ~/.config/gtk-3.0

echo 'Linking Xresources...'
rm -fr ~/.Xresources
ln -s /storage/src/dot_files/.Xresources ~/.Xresources
xrdb .Xresources

echo 'Linking xsessionrc...'
rm -fr ~/.xsessionrc
ln -s /storage/src/dot_files/.xsessionrc ~/.xsessionrc

echo 'Linking urxvt extensions...'
rm -fr ~/.urxvt
ln -s /storage/src/dot_files/.urxvt ~/.urxvt
xrdb .Xresources

echo 'Linking kitty configuration...'
rm -fr ~/.config/kitty
ln -s /storage/src/dot_files/kitty ~/.config/kitty

echo 'Linking termite configuration...'
rm -fr ~/.config/termite
ln -s /storage/src/dot_files/termite ~/.config/termite

echo 'Linking rofi config...'
rm -fr ~/.config/rofi
ln -s /storage/src/dot_files/rofi ~/.config/rofi

echo 'Linking dunst config...'
rm -fr ~/.config/dunst/dunstrc
mkdir -p ~/.config/dunst
ln -s /storage/src/dot_files/dunstrc ~/.config/dunst/dunstrc

echo 'Linking conky and compton config...'
rm -fr ~/.Conky ~/compton.conf
ln -s /storage/src/dot_files/.Conky ~/.Conky
ln -s /storage/src/dot_files/compton.conf ~/compton.conf

echo 'Linking ranger configuration...'
rm -fr ~/.config/ranger
ln -s /storage/src/dot_files/ranger ~/.config/ranger

echo 'Linking mps-youtube configuration...'
mkdir -p ~/.config/mps-youtube
ln -s /storage/src/dot_files/mps-youtube/config ~/.config/mps-youtube/config

echo 'Linking ansible configuration...'
rm -fr ~/ansible
ln -s /storage/src/dot_files/ansible ~/ansible

echo 'Linking arandr (screenlayout) configuration...'
rm -fr ~/.screenlayout
ln -s /storage/src/dot_files/.screenlayout ~/.screenlayout

echo 'Linking flashfocus configuration...'
rm -fr ~/.config/flashfocus
ln -s /storage/src/dot_files/flashfocus ~/.config/flashfocus

echo 'Linking i3 layouts configuration...'
rm -fr ~/.layouts
ln -s /storage/src/dot_files/.layouts ~/.layouts

echo 'Linking sxiv (image viewer) configuration...'
rm -fr ~/.config/sxiv
ln -s /storage/src/dot_files/sxiv ~/.config/sxiv

echo 'Linking alacritty configuration...'
rm -fr ~/.config/alacritty
ln -s /storage/src/dot_files/alacritty ~/.config

echo 'Downloading i3 timer plugin (which uses go)...'
go get github.com/claudiodangelis/i3-timer

# read i3.md from tiagopr.nl content posts for more packages and python packages that should be
# installed.

echo 'Installing i3 alternating layout...'
mkdir -p ~/bin/i3-alternating-layout && git clone https://github.com/olemartinorg/i3-alternating-layout ~/bin/i3-alternating-layout && cd ~/bin/i3-alternating-layout && sed -i 's/python/python3/g' alternating_layouts.py

echo 'Installing dmenu/rofi networkmanager...'
rm $HOME/bin/networkmanager_dmenu
curl https://raw.githubusercontent.com/firecat53/networkmanager-dmenu/main/networkmanager_dmenu -o $HOME/bin/networkmanager_dmenu
chmod 700 $HOME/bin/networkmanager_dmenu
rm -fr $HOME/.config/networkmanager-dmenu
ln -s /storage/src/dot_files/networkmanager-dmenu $HOME/.config/networkmanager-dmenu

echo 'Linking polybar...'
rm -fr ~/.config/polybar
ln -s /storage/src/dot_files/polybar ~/.config/polybar

echo 'Copying scripts configuration...'
HOME_SCRIPTS=$HOME/apps/scripts
BIN_SCRIPTS=$HOME_SCRIPTS/bin
ROFI_SCRIPTS=$HOME_SCRIPTS/rofi
STATUSBAR_SCRIPTS=$BIN_SCRIPTS/statusbar
mkdir -p $HOME_SCRIPTS
mkdir -p $BIN_SCRIPTS
mkdir -p $ROFI_SCRIPTS
mkdir -p $STATUSBAR_SCRIPTS
sudo cp -farv /storage/src/dwm/startdwm /usr/bin
cp -farv /storage/src/devops/rofi/* $ROFI_SCRIPTS
cp -farv /storage/src/devops/bin/* $BIN_SCRIPTS
cp -farv /storage/src/devops/shellscripts/statusbar/* $STATUSBAR_SCRIPTS

echo 'Finished.'
